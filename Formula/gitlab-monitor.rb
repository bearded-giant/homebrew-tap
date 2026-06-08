class GitlabMonitor < Formula
  desc "K9s-style TUI for monitoring GitLab pipelines"
  homepage "https://github.com/bearded-giant/gitlab-monitor"
  version "1.5.3"
  license "Apache-2.0"

  url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-aarch64-apple-darwin"
  sha256 "0913750de68a16e0ac7146de75098fe28f0af47aedb0678f65a580e1ae5d7afd"

  def install
    bin.install "glmon-aarch64-apple-darwin" => "glmon"
    bin.install_symlink "glmon" => "gitlab-monitor"
  end

  test do
    assert_match "Error", shell_output("#{bin}/glmon 2>&1", 1)
  end
end
