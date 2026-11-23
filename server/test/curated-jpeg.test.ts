// The curated set's bytes (D147): sizes, the colour profile and the AI tag
// (D123), on small JPEGs built here, segment by segment.
import assert from 'node:assert/strict';
import { existsSync, readFileSync } from 'node:fs';
import { test } from 'node:test';
import { AI_SOURCE_TYPE } from '../src/hosts.ts';
import { SRGB_PROFILE } from '../trial/curated.ts';
import { aiPacket, aiTagged, hasSrgb, jpegSize, pngSize, withAiTag, withProfile } from '../trial/jpeg.ts';
import { fakeJpeg, fakePng, fakeProfile, segment } from './curated-fakes.ts';

test("a PNG's size from its header; anything else is none", () => {
  assert.deepEqual(pngSize(fakePng(1600, 1200)), { width: 1600, height: 1200 });
  assert.equal(pngSize(Buffer.from('not a png at all, not at all')), null);
  assert.equal(pngSize(fakePng(4, 4).subarray(0, 20)), null);
});

test("a JPEG's size from its frame header", () => {
  assert.deepEqual(jpegSize(fakeJpeg(1600, 1200)), { width: 1600, height: 1200 });
  assert.deepEqual(jpegSize(fakeJpeg(1200, 336, { progressive: true })), { width: 1200, height: 336 });
});

test('a malformed JPEG is refused with a code', () => {
  assert.throws(() => jpegSize(Buffer.from([0x89, 0x50, 0x4e, 0x47])), /^Error: curated-jpeg$/);
  assert.throws(() => jpegSize(fakeJpeg(8, 8).subarray(0, 30)), /^Error: curated-jpeg$/);
  assert.throws(() => jpegSize(fakeJpeg(8, 8, { frame: false })), /^Error: curated-jpeg$/);
});

test('sRGB: an ICC profile naming it, in either encoding', () => {
  assert.equal(hasSrgb(fakeJpeg(8, 8)), true);
  assert.equal(hasSrgb(fakeJpeg(8, 8, { icc: 'utf16' })), true);
  assert.equal(hasSrgb(fakeJpeg(8, 8, { icc: 'p3' })), false);
  assert.equal(hasSrgb(fakeJpeg(8, 8, { icc: 'none' })), false);
});

test('the tag goes in after JFIF and is read back', () => {
  const plain = fakeJpeg(16, 12);
  assert.equal(aiTagged(plain), false);
  const tagged = withAiTag(plain);
  assert.equal(aiTagged(tagged), true);
  // Start, JFIF, then the tag's APP1; the rest unchanged.
  assert.deepEqual([...tagged.subarray(0, 4)], [0xff, 0xd8, 0xff, 0xe0]);
  const jfifEnd = 2 + 2 + plain.readUInt16BE(4);
  assert.deepEqual([...tagged.subarray(jfifEnd, jfifEnd + 2)], [0xff, 0xe1]);
  const added = tagged.length - plain.length;
  assert.ok(tagged.subarray(jfifEnd + added).equals(plain.subarray(jfifEnd)));
  assert.deepEqual(jpegSize(tagged), { width: 16, height: 12 });
  assert.equal(hasSrgb(tagged), true);
});

test('the tag goes in after the start when no JFIF leads', () => {
  const plain = fakeJpeg(16, 12, { jfif: false });
  const tagged = withAiTag(plain);
  assert.deepEqual([...tagged.subarray(0, 4)], [0xff, 0xd8, 0xff, 0xe1]);
  assert.equal(aiTagged(tagged), true);
});

test('a JPEG already holding XMP is refused', () => {
  assert.throws(() => withAiTag(withAiTag(fakeJpeg(8, 8))), /^Error: curated-xmp$/);
});

test('the packet names the IPTC source type and nothing else', () => {
  const packet = aiPacket();
  assert.ok(packet.includes(`Iptc4xmpExt:DigitalSourceType="${AI_SOURCE_TYPE}"`));
  assert.ok(AI_SOURCE_TYPE.endsWith('/trainedAlgorithmicMedia'));
  assert.equal(packet.match(/<rdf:Description /g)?.length, 1);
  assert.ok(packet.startsWith('<?xpacket begin='));
  assert.ok(packet.endsWith('<?xpacket end="r"?>'));
});

test('an untagged JPEG, or another packet, is not tagged', () => {
  const other = Buffer.concat([
    Buffer.from('http://ns.adobe.com/xap/1.0/\0', 'latin1'),
    Buffer.from('<x:xmpmeta xmlns:x="adobe:ns:meta/"></x:xmpmeta>', 'utf8'),
  ]);
  const jpeg = fakeJpeg(8, 8, { extra: [segment(0xe1, other)] });
  assert.equal(aiTagged(jpeg), false);
  assert.throws(() => withAiTag(jpeg), /^Error: curated-xmp$/);
});

// macOS 26's sips writes an sRGB JPEG as Exif and no ICC profile (found in
// the curated set's Task 3), so the profile is embedded by our own code.
const ICC_HEAD = Buffer.from('ICC_PROFILE\0\x01\x01', 'latin1');
const EXIF = segment(0xe1, Buffer.from('Exif\0\0MM', 'latin1'));
const PHOTOSHOP = segment(0xed, Buffer.from('Photoshop 3.0\0', 'latin1'));

test('a profile is embedded after the leading APP0 and APP1', () => {
  const profile = fakeProfile();
  const jpeg = fakeJpeg(8, 8, { icc: 'none', extra: [EXIF, PHOTOSHOP] });
  assert.equal(hasSrgb(jpeg), false);
  const out = withProfile(jpeg, profile);
  assert.equal(hasSrgb(out), true);
  assert.deepEqual(jpegSize(out), { width: 8, height: 8 });
  const icc = segment(0xe2, Buffer.concat([ICC_HEAD, profile]));
  const at = out.indexOf(icc);
  assert.ok(at > out.indexOf(EXIF) && at + icc.length === out.indexOf(PHOTOSHOP));
  assert.ok(Buffer.concat([out.subarray(0, at), out.subarray(at + icc.length)]).equals(jpeg));
  assert.equal(aiTagged(withAiTag(out)), true);
});

test('another profile is replaced, never doubled', () => {
  const out = withProfile(fakeJpeg(8, 8, { icc: 'p3' }), fakeProfile());
  assert.equal(hasSrgb(out), true);
  assert.equal(out.includes('Display P3'), false);
  assert.equal(out.toString('latin1').split('ICC_PROFILE').length, 2);
});

test('a false or too big profile is refused with a code', () => {
  const jpeg = fakeJpeg(8, 8, { icc: 'none' });
  assert.throws(() => withProfile(jpeg, Buffer.from('not a profile at all')), /^Error: curated-profile$/);
  assert.throws(() => withProfile(jpeg, Buffer.alloc(60)), /^Error: curated-profile$/);
  const big = Buffer.concat([fakeProfile(), Buffer.alloc(65520)]);
  assert.throws(() => withProfile(jpeg, big), /^Error: curated-profile$/);
});

test("the OS's own sRGB profile satisfies the sRGB check", { skip: !existsSync(SRGB_PROFILE) }, () => {
  const out = withProfile(fakeJpeg(8, 8, { icc: 'none' }), readFileSync(SRGB_PROFILE));
  assert.equal(hasSrgb(out), true);
});
