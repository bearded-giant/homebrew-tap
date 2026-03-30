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
brew install --cask giant-proxy-ui   # menubar app (includes CLI + daemon)
brew install giant-proxy              # CLI + daemon only (headless)
```

## What's available

| Formula | Description |
|---------|-------------|
| [gitlab-monitor](https://github.com/bearded-giant/gitlab-monitor) | K9s-style TUI for monitoring GitLab pipelines |
| [mdlive](https://github.com/bearded-giant/mdlive) | Markdown workspace server for AI coding agents |
| [giant-proxy](https://github.com/bearded-giant/gproxy) | HTTPS proxy CLI + daemon (headless) |
| [giant-proxy-ui](https://github.com/bearded-giant/gproxy) (cask) | Giant Proxy menubar app (bundles CLI + daemon) |

## Updating

```bash
brew upgrade gitlab-monitor
brew upgrade mdlive
brew upgrade giant-proxy        # or: brew upgrade --cask giant-proxy-ui
```

Formulae are automatically updated when new releases are published.
