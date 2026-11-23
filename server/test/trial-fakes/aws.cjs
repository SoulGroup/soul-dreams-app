// A fake AWS CLI for the trial's weights test: S3 as a folder in the
// state folder. Run by node from a wrapper on PATH.
const fs = require('fs'); const path = require('path');
const out = (b) => { const buf = Buffer.from(b); let o = 0; while (o < buf.length) { o += fs.writeSync(1, buf, o); } };
const state = process.env.FAKE_STATE; const args = process.argv.slice(2);
fs.appendFileSync(path.join(state, 'argv'), JSON.stringify(['aws', ...args]) + '\n');
const s3 = (u) => path.join(state, 's3', u.replace(/^s3:\/\//, ''));
if (args[0] === 'ssm') { out(process.env.FAKE_TOKEN + '\n'); process.exit(0); }
if (args[0] === 's3api' && args[1] === 'head-object') {
  const f = path.join(state, 's3', args[args.indexOf('--bucket') + 1], args[args.indexOf('--key') + 1]);
  if (!fs.existsSync(f)) { process.exit(254); }
  out(fs.statSync(f).size + '\n'); process.exit(0);
}
if (args[0] === 's3' && args[1] === 'cp') {
  const [from, to] = [args[2], args[3]];
  if (to === '-' && process.env.FAKE_CUT && from.includes(process.env.FAKE_CUT)) { process.exit(1); }
  const data = from === '-' ? fs.readFileSync(0) : from.startsWith('s3://') ? fs.readFileSync(s3(from)) : fs.readFileSync(from);
  if (to === '-') { out(data); process.exit(0); }
  const stored = process.env.FAKE_CORRUPT && to.includes(process.env.FAKE_CORRUPT) ? Buffer.from('corrupt') : data;
  fs.mkdirSync(path.dirname(s3(to)), { recursive: true }); fs.writeFileSync(s3(to), stored); process.exit(0);
}
if (args[0] === 's3' && args[1] === 'rm') { fs.rmSync(s3(args[2]), { force: true }); process.exit(0); }
if (args[0] === 's3' && args[1] === 'mv') {
  fs.mkdirSync(path.dirname(s3(args[3])), { recursive: true });
  fs.renameSync(s3(args[2]), s3(args[3])); process.exit(0);
}
process.exit(99);
