class GitlabMonitor < Formula
  desc "K9s-style TUI for monitoring GitLab pipelines"
  homepage "https://github.com/bearded-giant/gitlab-monitor"
  version "1.3.0"
  license "Apache-2.0"

  url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-aarch64-apple-darwin"
  sha256 "5239e23ae9d8efebab216affef41b81341869fd4fdef769d9d0dfb80c31b61de"

  def install
    bin.install "glmon-aarch64-apple-darwin" => "glmon"
    bin.install_symlink "glmon" => "gitlab-monitor"
  end

  test do
    assert_match "Error", shell_output("#{bin}/glmon 2>&1", 1)
  end
end
