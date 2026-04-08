#!/usr/bin/env bash
set -euo pipefail

REPO="bearded-giant/gproxy"
TAP_DIR="$(cd "$(dirname "$0")" && pwd)"
FORMULA="${TAP_DIR}/Formula/giant-proxy-cli.rb"
CASK="${TAP_DIR}/Casks/giant-proxy.rb"

# resolve version: argument, or latest from GH
if [[ -n "${1:-}" ]]; then
  VERSION="${1#v}"
else
  VERSION="$(gh release view -R "$REPO" --json tagName -q '.tagName' | sed 's/^v//')"
fi

echo "==> Updating giant-proxy tap to v${VERSION}"

# expected assets
CLI_ASSET="gproxy-v${VERSION}-aarch64-apple-darwin.tar.gz"
DMG_ASSET="Giant.Proxy_${VERSION}_aarch64.dmg"
ALL_ASSETS=("$CLI_ASSET" "$DMG_ASSET")

echo "==> Checking release assets exist..."
AVAILABLE="$(gh release view "v${VERSION}" -R "$REPO" --json assets -q '.assets[].name')"
MISSING=()
for a in "${ALL_ASSETS[@]}"; do
  grep -qx "$a" <<< "$AVAILABLE" || MISSING+=("$a")
done
if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo "ERROR: missing assets (build still running?):"
  printf '  %s\n' "${MISSING[@]}"
  exit 1
fi

# --- Formula (CLI) ---
echo "==> Updating Formula/giant-proxy-cli.rb"
sed -i '' "s/version \".*\"/version \"${VERSION}\"/" "$FORMULA"

cli_url="https://github.com/${REPO}/releases/download/v${VERSION}/${CLI_ASSET}"
cli_sha="$(curl -sL "$cli_url" | shasum -a 256 | awk '{print $1}')"
sed -i '' "s/sha256 \".*\"/sha256 \"${cli_sha}\"/" "$FORMULA"
echo "  ${CLI_ASSET}: ${cli_sha}"

# --- Cask (DMG) ---
echo "==> Updating Casks/giant-proxy.rb"
dmg_url="https://github.com/${REPO}/releases/download/v${VERSION}/${DMG_ASSET}"
dmg_sha="$(curl -sL "$dmg_url" | shasum -a 256 | awk '{print $1}')"
sed -i '' "s/version \".*\"/version \"${VERSION}\"/" "$CASK"
sed -i '' "s/sha256 \".*\"/sha256 \"${dmg_sha}\"/" "$CASK"
echo "  ${DMG_ASSET}: ${dmg_sha}"

echo ""
echo "Done. Review changes:"
echo "  cd ${TAP_DIR} && git diff"
