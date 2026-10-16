class GitlabMonitor < Formula
  desc "K9s-style TUI for monitoring GitLab pipelines"
  homepage "https://github.com/bearded-giant/gitlab-monitor"
  version "1.8.1"
  license "Apache-2.0"

  url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-aarch64-apple-darwin.tar.gz"
  sha256 "dde3fdc62aab31c643d739de0efd4964ed7c04398af409ddd15ebd95ac27b725"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"glmon"
    bin.install_symlink libexec/"glmon" => "gitlab-monitor"
  end

  test do
    assert_match "Error", shell_output("#{bin}/glmon 2>&1", 1)
  end
end
