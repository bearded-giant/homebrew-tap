class GitlabMonitor < Formula
  desc "K9s-style TUI for monitoring GitLab pipelines"
  homepage "https://github.com/bearded-giant/gitlab-monitor"
  version "1.10.0"
  license "Apache-2.0"

  url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-aarch64-apple-darwin.tar.gz"
  sha256 "c5eb096896b088cc81da851c57927b69ccde52aa8851a0d4eff26af90f8be995"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"glmon"
    bin.install_symlink libexec/"glmon" => "gitlab-monitor"
  end

  test do
    assert_match "Error", shell_output("#{bin}/glmon 2>&1", 1)
  end
end
