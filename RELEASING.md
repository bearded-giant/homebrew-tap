# Releasing — bearded-giant projects

Cheat sheet for cutting releases across all repos that publish to this tap.

## Flow (any repo)

```
push code → ./release.sh <version> → release.yml builds → release published
                                              ↓
                                  update-homebrew.yml fires auto
                                              ↓
                                  this tap repo updated by github-actions[bot]
                                              ↓
                                  brew upgrade <formula>
```

## Per-repo specifics

| Repo | Lang | Version file | release.sh path | Tap target | Asset(s) |
|---|---|---|---|---|---|
| [redis-tui](https://github.com/bearded-giant/redis-tui) | Go | none (ldflags) | `./release.sh <ver>` | `Casks/redis-tui.rb` (goreleaser inline) | binaries + .deb/.rpm/.apk |
| [gitlab-monitor](https://github.com/bearded-giant/gitlab-monitor) | Python | `pyproject.toml` | `./release.sh <ver>` | `Formula/gitlab-monitor.rb` | `glmon-aarch64-apple-darwin` |
| [mdlive](https://github.com/bearded-giant/mdlive) | Rust | `Cargo.toml` + `src-tauri/Cargo.toml` + `tauri.conf.json` | `./release.sh <ver>` | `Formula/mdlive.rb` + `Casks/mdlive-app.rb` | `mdlive-*` per arch + `mdlive_*.dmg` |
| [gproxy](https://github.com/bearded-giant/gproxy) | Rust | `crates/*/Cargo.toml` + `tauri.conf.json` | `./release.sh <ver>` | `Formula/giant-proxy-cli.rb` + `Casks/giant-proxy.rb` | `gproxy-v*-aarch64-apple-darwin.tar.gz` + `Giant.Proxy_*.dmg` |

## Standard steps

```bash
cd ~/dev/<repo>
git push origin main                       # push code first
./release.sh 1.2.3                         # bump + tag + push
gh run watch -R bearded-giant/<repo>       # optional, watch build
brew update && brew upgrade <formula>      # consume
```

## Manual backfill

If `update-homebrew.yml` failed/skipped, rerun against an existing tag:

```bash
gh workflow run update-homebrew.yml -R bearded-giant/<repo> -f tag=v<version>
```

(redis-tui has no separate update-homebrew workflow — re-run release.yml or re-tag.)

## Tap exception: tmux-dimmed

No source repo. Patches upstream tmux 3.6b inline. See `README.md → Exception: tmux-dimmed` for edit flow. TL;DR:

```bash
$EDITOR patches/tmux-dimmed-3.6b.patch
./update-tmux-dimmed.sh
git add -A && git commit -m "tmux-dimmed: <change>" && git push
```

## Secrets required

| Secret | Where | What |
|---|---|---|
| `HOMEBREW_TAP_TOKEN` | each app repo | PAT with `contents: write` on `bearded-giant/homebrew-tap`. Same token value across all repos. Set via `gh secret set HOMEBREW_TAP_TOKEN -R bearded-giant/<repo> --body "$HOMEBREW_TAP_TOKEN"` |
| `GITHUB_TOKEN` | auto | provided by Actions, used to download release assets within the same repo |

## Common failures

| Symptom | Cause | Fix |
|---|---|---|
| release.yml red | build/test broke | fix on main, `git tag -d v1.2.3 && git push origin :v1.2.3 && ./release.sh 1.2.3` |
| update-homebrew can't download asset | asset name changed | update pattern in `update-homebrew.yml` to match `release.yml` output |
| tap push 403 | `HOMEBREW_TAP_TOKEN` expired | regen fine-grained PAT on tap repo, `gh secret set` on each app repo |
| Cask SHA mismatch on install | tap not pushed yet | wait 1 min, `brew update`, retry |
