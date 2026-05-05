#!/usr/bin/env bash
set -euo pipefail

REPO="bearded-giant/gitlab-monitor"
TAP_DIR="$(cd "$(dirname "$0")" && pwd)"
FORMULA="${TAP_DIR}/Formula/gitlab-monitor.rb"
ASSET="glmon-aarch64-apple-darwin"

if [[ -n "${1:-}" ]]; then
  VERSION="${1#v}"
else
  VERSION="$(gh release view -R "$REPO" --json tagName -q '.tagName' | sed 's/^v//')"
fi

echo "==> Updating gitlab-monitor tap to v${VERSION}"

echo "==> Checking release asset exists..."
AVAILABLE="$(gh release view "v${VERSION}" -R "$REPO" --json assets -q '.assets[].name')"
if ! grep -qx "$ASSET" <<< "$AVAILABLE"; then
  echo "ERROR: missing asset ${ASSET} (build still running?)"
  exit 1
fi

echo "==> Updating Formula/gitlab-monitor.rb"
sed -i '' "s/version \".*\"/version \"${VERSION}\"/" "$FORMULA"

url="https://github.com/${REPO}/releases/download/v${VERSION}/${ASSET}"
sha="$(curl -sL "$url" | shasum -a 256 | awk '{print $1}')"
sed -i '' "s/sha256 \".*\"/sha256 \"${sha}\"/" "$FORMULA"
echo "  ${ASSET}: ${sha}"

echo ""
echo "Done. Review changes:"
echo "  cd ${TAP_DIR} && git diff"
