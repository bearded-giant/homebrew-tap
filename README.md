# Homebrew Tap

Homebrew formulae for [bearded-giant](https://github.com/bearded-giant) projects.

## Install

```bash
brew tap bearded-giant/tap
brew install gitlab-monitor
brew install mdlive
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
| [giant-proxy](https://github.com/bearded-giant/gproxy) (cask) | Giant Proxy app + CLI + daemon |
| [giant-proxy-cli](https://github.com/bearded-giant/gproxy) | Giant Proxy CLI + daemon (headless, no GUI) |

## Updating

```bash
brew upgrade gitlab-monitor
brew upgrade mdlive
brew upgrade --cask giant-proxy     # or: brew upgrade giant-proxy-cli
```

Formulae are automatically updated when new releases are published.
