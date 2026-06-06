class GitlabMonitor < Formula
  desc "K9s-style TUI for monitoring GitLab pipelines"
  homepage "https://github.com/bearded-giant/gitlab-monitor"
  version "1.4.0"
  license "Apache-2.0"

  url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-aarch64-apple-darwin"
  sha256 "15c7b1420e28caa2d095bd6db3b1724a0167157d85bb83a9be45242fca76b870"

  def install
    bin.install "glmon-aarch64-apple-darwin" => "glmon"
    bin.install_symlink "glmon" => "gitlab-monitor"
  end

  test do
    assert_match "Error", shell_output("#{bin}/glmon 2>&1", 1)
  end
end
