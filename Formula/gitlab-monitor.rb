class GitlabMonitor < Formula
  desc "K9s-style TUI for monitoring GitLab pipelines"
  homepage "https://github.com/bearded-giant/gitlab-monitor"
  version "1.0.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-aarch64-apple-darwin"
      sha256 "PLACEHOLDER_MACOS_ARM64"
    else
      url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-x86_64-apple-darwin"
      sha256 "PLACEHOLDER_MACOS_X86"
    end
  end

  on_linux do
    url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-x86_64-unknown-linux-gnu"
    sha256 "PLACEHOLDER_LINUX_X86"
  end

  def install
    bin.install Dir["glmon-*"].first => "glmon"
    bin.install_symlink "glmon" => "gitlab-monitor"
  end

  test do
    assert_match "Error", shell_output("#{bin}/glmon 2>&1", 1)
  end
end
