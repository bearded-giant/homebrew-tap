# Homebrew Tap

Homebrew formulae for [bearded-giant](https://github.com/bearded-giant) projects.

## Install

```bash
brew tap bearded-giant/tap
brew install gitlab-monitor
brew install mdlive
brew install tmux-dimmed
brew install --cask redis-tui
```

Giant Proxy -- pick one:

```bash
brew install --cask giant-proxy       # app + CLI + daemon (recommended)
brew install giant-proxy-cli           # CLI + daemon only (headless)
```

## What's available

| Formula | Description |
|---------|-------------|
| [gitlab-monitor](https://github.com/bearded-giant/gitlab-monitor) | K9s-style TUI for monitoring GitLab pipelines |
| [mdlive](https://github.com/bearded-giant/mdlive) | Markdown workspace server for AI coding agents |
| [redis-tui](https://github.com/bearded-giant/redis-tui) (cask) | TUI for managing Redis databases |
| [giant-proxy](https://github.com/bearded-giant/gproxy) (cask) | Giant Proxy app + CLI + daemon |
| [giant-proxy-cli](https://github.com/bearded-giant/gproxy) | Giant Proxy CLI + daemon (headless, no GUI) |
| [tmux-dimmed](https://github.com/bearded-giant/tmux) | tmux 3.6b patched to dim inactive panes |

## Updating

```bash
brew upgrade gitlab-monitor
brew upgrade mdlive
brew upgrade tmux-dimmed
brew upgrade --cask redis-tui
brew upgrade --cask giant-proxy     # or: brew upgrade giant-proxy-cli
```

Formulae are automatically updated when new releases are published via per-project GitHub Actions (`update-homebrew.yml`) — no manual scripts needed.

### Exception: tmux-dimmed

Patches upstream tmux 3.6b inline — no source repo. Patch lives at `patches/tmux-dimmed-3.6b.patch` and is fetched by the formula via raw GitHub URL with a pinned SHA256. To edit:

```bash
$EDITOR patches/tmux-dimmed-3.6b.patch
./update-tmux-dimmed.sh           # recomputes SHA, patches Formula/tmux-dimmed.rb
git diff                          # review
git add Formula/tmux-dimmed.rb patches/tmux-dimmed-3.6b.patch
git commit -m "tmux-dimmed: <change>"
git push
```

Pinned SHA + `main`-branch URL means consumers must `brew update` (or reinstall) to pick up the new patch.
