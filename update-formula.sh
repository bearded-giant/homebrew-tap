#!/usr/bin/env bash
set -euo pipefail

FORMULA="Formula/gitlab-monitor.rb"
REPO="bearded-giant/gitlab-monitor"
VERSION="${1:?Usage: ./update-formula.sh <version> (e.g. 1.0.0)}"

echo "Updating formula to v${VERSION}..."

# update version
sed -i '' "s/version \".*\"/version \"${VERSION}\"/" "$FORMULA"

for binary in glmon-aarch64-apple-darwin glmon-x86_64-apple-darwin glmon-x86_64-unknown-linux-gnu; do
  url="https://github.com/${REPO}/releases/download/v${VERSION}/${binary}"
  echo "Fetching SHA for ${binary}..."
  sha=$(curl -sL "$url" | shasum -a 256 | awk '{print $1}')

  case "$binary" in
    *aarch64-apple*)  placeholder="PLACEHOLDER_MACOS_ARM64" ;;
    *x86_64-apple*)   placeholder="PLACEHOLDER_MACOS_X86" ;;
    *linux*)          placeholder="PLACEHOLDER_LINUX_X86" ;;
  esac

  # replace placeholder or existing sha on the line after the matching url
  sed -i '' "s/sha256 \"${placeholder}\"/sha256 \"${sha}\"/" "$FORMULA"
  # also handle updating existing shas (re-runs)
  grep -q "$placeholder" "$FORMULA" || \
    awk -v url="$binary" -v sha="$sha" '
      prev ~ url { gsub(/sha256 "[^"]*"/, "sha256 \""sha"\"") }
      { prev=$0; print }
    ' "$FORMULA" > "$FORMULA.tmp" && mv "$FORMULA.tmp" "$FORMULA"

  echo "  ${binary}: ${sha}"
done

echo "Done. Review ${FORMULA} then commit and push."
