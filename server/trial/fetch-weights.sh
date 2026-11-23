#!/bin/bash
# The image trial's weights (D135, D136): from the model hub into the
# trial bucket, run by the owner in CloudShell in eu-north-1
# (docs/plans/image-trial.md). Only the files of the pipeline's parts at
# the pinned revision: no single-file copies, no fp16 copies, no other
# formats. A file already in the bucket at its size is kept, so a cut
# session simply runs again. Each new file is checked against the hub's
# hash: a large one read back from S3, a small one before it goes up.
# The hub's address is the owner's argument. The token is read from
# Parameter Store into a header file, never onto a command line or the
# screen (R5). It writes counts and codes only.
#   fetch-weights.sh <hub> <repo> <revision> <flux|sdxl> <bucket>
set -euo pipefail

fail() {
  echo "$1" >&2
  exit "$2"
}

[ "$#" -eq 5 ] || fail fetch-usage 2
hub=$1
repo=$2
rev=$3
model=$4
bucket=$5
case $model in
  flux | sdxl) ;;
  *) fail fetch-usage 2 ;;
esac
case $rev in
  '' | *[!0-9a-f]*) fail fetch-revision 2 ;;
esac
[ "${#rev}" -eq 40 ] || fail fetch-revision 2

umask 077
work=$(mktemp -d "${TMPDIR:-/tmp}/fetch-weights.XXXXXX")
trap 'rm -rf "$work"' EXIT
headers="$work/headers"
token=$(aws ssm get-parameter --region eu-north-1 --name /souldreams/trial/hf-token \
  --with-decryption --query Parameter.Value --output text)
printf 'Authorization: Bearer %s\n' "$token" >"$headers"
unset token

# The header goes only to the hub: curl drops it on a redirect elsewhere.
get() {
  curl -sSfL --retry 3 -H "@$headers" "$hub/$1"
}

get "api/models/$repo/tree/$rev?recursive=true" >"$work/tree.json"
get "$repo/resolve/$rev/model_index.json" >"$work/model_index.json"
jq -r 'keys[]|select(startswith("_")|not)' "$work/model_index.json" >"$work/parts.all"
grep -Ex '[A-Za-z0-9_]+' "$work/parts.all" >"$work/parts" || true
jq -r '.[]|select(.type=="file")|[.path,(.size|tostring),(.lfs.oid//"-"),.oid]|@tsv' \
  "$work/tree.json" >"$work/all"
# model_index.json, and each part's own files one folder deep; never an
# fp16 copy, and only these kinds of file.
while IFS=$'\t' read -r path size sha oid; do
  case $path in
    *.fp16.*) continue ;;
    *.json | *.txt | *.model | *.safetensors) ;;
    *) continue ;;
  esac
  if [ "$path" != model_index.json ]; then
    part=${path%%/*}
    rest=${path#*/}
    [ "$part" != "$path" ] && [ "${rest#*/}" = "$rest" ] && grep -Fxq "$part" "$work/parts" || continue
  fi
  printf '%s\t%s\t%s\t%s\n' "$path" "$size" "$sha" "$oid"
done <"$work/all" >"$work/files"
[ -s "$work/files" ] || fail fetch-nothing 3

fetched=0
kept=0
while IFS=$'\t' read -r path size sha oid <&3; do
  key="models/$model/$path"
  have=$(aws s3api head-object --region eu-north-1 --bucket "$bucket" --key "$key" \
    --query ContentLength --output text 2>/dev/null || true)
  if [ "$have" = "$size" ]; then
    kept=$((kept + 1))
    continue
  fi
  if [ "$sha" = "-" ]; then
    get "$repo/resolve/$rev/$path" >"$work/small"
    got=$( (printf 'blob %s\0' "$size" && cat "$work/small") | sha1sum | cut -c1-40)
    [ "$got" = "$oid" ] || fail "fetch-hash $path" 3
    aws s3 cp "$work/small" "s3://$bucket/$key" --region eu-north-1 --only-show-errors
  else
    get "$repo/resolve/$rev/$path" |
      aws s3 cp - "s3://$bucket/$key" --region eu-north-1 --expected-size "$size" --only-show-errors
    got=$(aws s3 cp "s3://$bucket/$key" - --region eu-north-1 --only-show-errors | sha256sum | cut -c1-64)
    if [ "$got" != "$sha" ]; then
      aws s3 rm "s3://$bucket/$key" --region eu-north-1 --only-show-errors
      fail "fetch-hash $path" 3
    fi
  fi
  fetched=$((fetched + 1))
done 3<"$work/files"
echo "fetched $fetched kept $kept"
