#!/bin/bash
# The owner's reading of the feedback (D152 item 2), on his Mac with his AWS
# profile: every feedback in the bucket is moved into a folder of his own,
# ~/SoulDreams-feedback/<UTC day>/ (outside the repository and any synced
# folder), each object deleted from the bucket only after its own download
# (`aws s3 mv`), and each file then dated to its day's start, so the Mac keeps
# no time of day for it. It prints counts only, never a word of feedback.
# Usage: tool/read_feedback.sh <profile>
set -euo pipefail
profile=${1:-}
if [ -z "$profile" ]; then
  echo 'usage: tool/read_feedback.sh <profile>' >&2
  exit 2
fi
dest=${SOULDREAMS_FEEDBACK:-$HOME/SoulDreams-feedback}
region=eu-north-1
bucket=$(aws cloudformation describe-stacks --stack-name SoulDreamsServer --region "$region" --profile "$profile" \
  --query "Stacks[0].Outputs[?OutputKey=='FeedbackBucket'].OutputValue" --output text)
if [ -z "$bucket" ] || [ "$bucket" = None ]; then
  echo 'read-feedback: no FeedbackBucket output on SoulDreamsServer' >&2
  exit 1
fi
count() { find "$dest" -type f -name '*.txt' | wc -l | tr -d ' '; }
mkdir -p "$dest"
chmod 700 "$dest"
before=$(count)
aws s3 mv "s3://$bucket/" "$dest/" --recursive --region "$region" --profile "$profile" --only-show-errors
for folder in "$dest"/*/; do
  day=$(basename "$folder")
  if [[ $day =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    find "$folder" -type f -name '*.txt' -exec touch -t "${day//-/}0000" {} +
  fi
done
after=$(count)
echo "read-feedback: $((after - before)) new, $after in $dest"
