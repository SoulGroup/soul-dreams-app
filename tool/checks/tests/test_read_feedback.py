# tool/read_feedback.sh, the owner's reading of the feedback (D152 item 2),
# run against a stand-in `aws` that records what it is asked and plays the
# bucket: the stack's output names the bucket, `s3 mv` moves every object
# into the folder by its day, each file then dated to its day's start, and
# only counts are printed. No real AWS is reached.
import os
import stat
import subprocess
import tempfile
import time
import unittest

from helpers import CHECKS

SCRIPT = os.path.join(os.path.dirname(os.path.dirname(CHECKS)), 'tool', 'read_feedback.sh')

FAKE = '\n'.join((
    '#!/bin/bash',
    'printf \'%s\\n\' "$*" >> "$CALLS"',
    'case "$1" in',
    '  cloudformation) printf \'%s\\n\' "$BUCKET"; exit "${CF_EXIT:-0}" ;;',
    '  s3)',
    '    [ -n "${MV_EXIT:-}" ] && exit "$MV_EXIT"',
    '    dest="$4"',
    '    mkdir -p "$dest/2026-11-24" "$dest/2026-11-25"',
    '    printf \'one\' > "$dest/2026-11-24/$(printf \'a%.0s\' {1..32}).txt"',
    '    printf \'two\' > "$dest/2026-11-25/$(printf \'b%.0s\' {1..32}).txt"',
    '    exit 0 ;;',
    'esac',
    'exit 9',
    '',
))


class ReadFeedback(unittest.TestCase):
    def run_script(self, args, bucket='souldreamsserver-feedbacka1b2-c3d4', earlier=False, **env):
        root = tempfile.mkdtemp(prefix='read-feedback-')
        bin_dir = os.path.join(root, 'bin')
        os.mkdir(bin_dir)
        fake = os.path.join(bin_dir, 'aws')
        with open(fake, 'w', encoding='utf-8') as f:
            f.write(FAKE)
        os.chmod(fake, stat.S_IRWXU)
        calls = os.path.join(root, 'calls')
        dest = os.path.join(root, 'feedback')
        if earlier:
            os.makedirs(os.path.join(dest, '2026-11-01'))
            with open(os.path.join(dest, '2026-11-01', 'c' * 32 + '.txt'), 'w', encoding='utf-8') as f:
                f.write('read before')
        full = {'PATH': bin_dir + os.pathsep + '/usr/bin:/bin', 'HOME': root, 'CALLS': calls,
                'BUCKET': bucket, 'SOULDREAMS_FEEDBACK': dest}
        full.update(env)
        out = subprocess.run(['/bin/bash', SCRIPT] + args, env=full, capture_output=True, text=True)
        lines = open(calls, encoding='utf-8').read().splitlines() if os.path.exists(calls) else []
        return out, lines, dest

    def test_moves_every_feedback_to_the_folder_by_its_day(self):
        out, calls, dest = self.run_script(['workload'])
        self.assertEqual(out.returncode, 0, out.stderr)
        self.assertEqual(calls, [
            'cloudformation describe-stacks --stack-name SoulDreamsServer --region eu-north-1 --profile workload '
            "--query Stacks[0].Outputs[?OutputKey=='FeedbackBucket'].OutputValue --output text",
            's3 mv s3://souldreamsserver-feedbacka1b2-c3d4/ ' + dest + '/ --recursive --region eu-north-1 '
            '--profile workload --only-show-errors',
        ])
        self.assertEqual(out.stdout, 'read-feedback: 2 new, 2 in ' + dest + '\n')
        self.assertEqual(out.stderr, '')

    def test_feedback_read_before_stays_and_is_not_counted_new(self):
        out, _, dest = self.run_script(['workload'], earlier=True)
        self.assertEqual(out.returncode, 0, out.stderr)
        self.assertEqual(out.stdout, 'read-feedback: 2 new, 3 in ' + dest + '\n')

    def test_the_folder_is_the_owners_alone(self):
        _, _, dest = self.run_script(['workload'])
        self.assertEqual(stat.S_IMODE(os.stat(dest).st_mode), 0o700)

    def test_each_file_dated_to_its_days_start(self):
        _, _, dest = self.run_script(['workload'])
        for day in ('2026-11-24', '2026-11-25'):
            folder = os.path.join(dest, day)
            (name,) = os.listdir(folder)
            want = time.mktime(time.strptime(day, '%Y-%m-%d'))
            self.assertEqual(os.stat(os.path.join(folder, name)).st_mtime, want, day)

    def test_the_default_folder_is_in_home_outside_the_repository(self):
        out, calls, dest = self.run_script(['workload'], SOULDREAMS_FEEDBACK='')
        self.assertEqual(out.returncode, 0, out.stderr)
        home = os.path.dirname(dest)
        self.assertIn(' ' + os.path.join(home, 'SoulDreams-feedback') + '/ --recursive', calls[1])
        self.assertTrue(os.path.isdir(os.path.join(home, 'SoulDreams-feedback', '2026-11-24')))

    def test_no_profile_named_nothing_asked(self):
        out, calls, _ = self.run_script([])
        self.assertEqual(out.returncode, 2)
        self.assertEqual(calls, [])

    def test_no_bucket_found_nothing_moved(self):
        for bucket in ('None', ''):
            out, calls, dest = self.run_script(['workload'], bucket=bucket)
            self.assertEqual(out.returncode, 1, bucket)
            self.assertEqual(len(calls), 1, bucket)
            self.assertFalse(os.path.exists(dest), bucket)

    def test_a_failure_stops_with_its_status(self):
        out, calls, _ = self.run_script(['workload'], CF_EXIT='254')
        self.assertNotEqual(out.returncode, 0)
        self.assertEqual(len(calls), 1)
        out, calls, _ = self.run_script(['workload'], MV_EXIT='1')
        self.assertEqual(out.returncode, 1)
        self.assertEqual(len(calls), 2)
        self.assertNotIn('read-feedback:', out.stdout)


if __name__ == '__main__':
    unittest.main()
