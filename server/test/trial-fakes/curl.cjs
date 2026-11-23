// A fake curl for the trial's weights test: answers from the state folder,
// only with the right token's header. Run by node from a wrapper on PATH.
const fs = require('fs'); const path = require('path');
const out = (b) => { const buf = Buffer.from(b); let o = 0; while (o < buf.length) { o += fs.writeSync(1, buf, o); } };
const state = process.env.FAKE_STATE; const args = process.argv.slice(2);
fs.appendFileSync(path.join(state, 'argv'), JSON.stringify(['curl', ...args]) + '\n');
const h = args[args.indexOf('-H') + 1];
const header = h && h.startsWith('@') ? fs.readFileSync(h.slice(1), 'utf8') : '';
if (header !== 'Authorization: Bearer ' + process.env.FAKE_TOKEN + '\n') { process.exit(22); }
const url = args[args.length - 1]; const base = process.env.FAKE_HUB + '/';
const rest = url.slice(base.length);
const tree = 'api/models/' + process.env.FAKE_REPO + '/tree/' + process.env.FAKE_REV + '?recursive=true';
if (rest === tree) { out(fs.readFileSync(path.join(state, 'tree.json'))); process.exit(0); }
const pre = process.env.FAKE_REPO + '/resolve/' + process.env.FAKE_REV + '/';
const file = path.join(state, 'hub', rest.slice(pre.length));
if (!rest.startsWith(pre) || !fs.existsSync(file)) { process.exit(22); }
out(fs.readFileSync(file));
