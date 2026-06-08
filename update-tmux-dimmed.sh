#!/usr/bin/env bash
# After editing patches/tmux-dimmed-*.patch, run this to recompute the SHA256
# and patch it into Formula/tmux-dimmed.rb. Commit both files together.
#
# Single arg = patch file. Default is the only patch matching tmux-dimmed-*.
set -euo pipefail

TAP_DIR="$(cd "$(dirname "$0")" && pwd)"
FORMULA="${TAP_DIR}/Formula/tmux-dimmed.rb"

if [[ -n "${1:-}" ]]; then
  PATCH="$1"
else
  shopt -s nullglob
  matches=("${TAP_DIR}/patches/tmux-dimmed-"*.patch)
  if [[ ${#matches[@]} -ne 1 ]]; then
    echo "ERROR: expected exactly one tmux-dimmed-*.patch, got ${#matches[@]}" >&2
    echo "       pass explicit path as arg" >&2
    exit 1
  fi
  PATCH="${matches[0]}"
fi

if [[ ! -f "$PATCH" ]]; then
  echo "ERROR: patch file not found: $PATCH" >&2
  exit 1
fi

OLD=$(sed -n '/patch do/,/end/p' "$FORMULA" | sed -n 's/.*sha256 "\([^"]*\)".*/\1/p')
NEW=$(shasum -a 256 "$PATCH" | awk '{print $1}')

if [[ "$OLD" == "$NEW" ]]; then
  echo "==> SHA already current: $NEW"
  exit 0
fi

echo "==> patch: $(basename "$PATCH")"
echo "    old SHA: $OLD"
echo "    new SHA: $NEW"

# narrow sed to only the line inside the `patch do` block to avoid bumping
# the upstream tmux tarball sha256 by accident
awk -v new="$NEW" '
  /patch do/ { inblock=1 }
  inblock && /sha256/ { sub(/sha256 "[^"]*"/, "sha256 \"" new "\""); inblock=0 }
  { print }
' "$FORMULA" > "${FORMULA}.tmp" && mv "${FORMULA}.tmp" "$FORMULA"

echo "==> Formula/tmux-dimmed.rb updated. Review:"
echo "    git diff Formula/tmux-dimmed.rb"
echo ""
echo "Then commit both:"
REL_PATCH="${PATCH#"$TAP_DIR"/}"
echo "    git add Formula/tmux-dimmed.rb $REL_PATCH"
echo "    git commit -m 'tmux-dimmed: <describe change>'"
