class GitlabMonitor < Formula
  desc "K9s-style TUI for monitoring GitLab pipelines"
  homepage "https://github.com/bearded-giant/gitlab-monitor"
  version "1.7.0"
  license "Apache-2.0"

  url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-aarch64-apple-darwin.tar.gz"
  sha256 "4c366f97a24421dab079bca5ead01b45092c34a587ab8624d0381cdee278ce38"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"glmon"
    bin.install_symlink libexec/"glmon" => "gitlab-monitor"
  end

  test do
    assert_match "Error", shell_output("#{bin}/glmon 2>&1", 1)
  end
end
