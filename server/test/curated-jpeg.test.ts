// The curated set's bytes (D147): sizes, the colour profile and the AI tag
// (D123), on small JPEGs built here, segment by segment.
import assert from 'node:assert/strict';
import { test } from 'node:test';
import { AI_SOURCE_TYPE } from '../src/hosts.ts';
import { aiPacket, aiTagged, hasSrgb, jpegSize, pngSize, withAiTag } from '../trial/jpeg.ts';
import { fakeJpeg, fakePng, segment } from './curated-fakes.ts';

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
