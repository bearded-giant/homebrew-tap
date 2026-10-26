class GitlabMonitor < Formula
  desc "K9s-style TUI for monitoring GitLab pipelines"
  homepage "https://github.com/bearded-giant/gitlab-monitor"
  version "1.11.2"
  license "Apache-2.0"

  url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-aarch64-apple-darwin.tar.gz"
  sha256 "660a38606772b64a4a15cc430d40239301c3ed7df6c48f928280d0015322d1ab"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"glmon"
    bin.install_symlink libexec/"glmon" => "gitlab-monitor"
  end

  test do
    assert_match "Error", shell_output("#{bin}/glmon 2>&1", 1)
  end
end
