#!/usr/bin/env bash
set -euo pipefail

REPO="bearded-giant/mdlive"
TAP_DIR="$(cd "$(dirname "$0")" && pwd)"
FORMULA="${TAP_DIR}/Formula/mdlive.rb"
CASK="${TAP_DIR}/Casks/mdlive-app.rb"

# resolve version: argument, or latest from GH
if [[ -n "${1:-}" ]]; then
  VERSION="${1#v}"
else
  VERSION="$(gh release view -R "$REPO" --json tagName -q '.tagName' | sed 's/^v//')"
fi

echo "==> Updating mdlive tap to v${VERSION}"

# wait for all expected assets (GH actions may still be uploading)
FORMULA_ASSETS=(mdlive-aarch64-apple-darwin mdlive-x86_64-apple-darwin mdlive-aarch64-unknown-linux-gnu mdlive-x86_64-unknown-linux-gnu)
DMG_ASSET="mdlive_${VERSION}_aarch64.dmg"
ALL_ASSETS=("${FORMULA_ASSETS[@]}" "$DMG_ASSET")

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

# --- Formula ---
echo "==> Updating Formula/mdlive.rb"
sed -i '' "s/version \".*\"/version \"${VERSION}\"/" "$FORMULA"

for binary in "${FORMULA_ASSETS[@]}"; do
  url="https://github.com/${REPO}/releases/download/v${VERSION}/${binary}"
  sha="$(curl -sL "$url" | shasum -a 256 | awk '{print $1}')"
  # replace the sha on the line after the url containing this binary name
  awk -v bin="$binary" -v sha="$sha" '
    prev ~ bin { gsub(/sha256 "[^"]*"/, "sha256 \""sha"\"") }
    { prev=$0; print }
  ' "$FORMULA" > "$FORMULA.tmp" && mv "$FORMULA.tmp" "$FORMULA"
  echo "  ${binary}: ${sha}"
done

# --- Cask ---
echo "==> Updating Casks/mdlive-app.rb"
dmg_url="https://github.com/${REPO}/releases/download/v${VERSION}/${DMG_ASSET}"
dmg_sha="$(curl -sL "$dmg_url" | shasum -a 256 | awk '{print $1}')"
sed -i '' "s/version \".*\"/version \"${VERSION}\"/" "$CASK"
sed -i '' "s/sha256 \".*\"/sha256 \"${dmg_sha}\"/" "$CASK"
echo "  ${DMG_ASSET}: ${dmg_sha}"

echo ""
echo "Done. Review changes:"
echo "  cd ${TAP_DIR} && git diff"
