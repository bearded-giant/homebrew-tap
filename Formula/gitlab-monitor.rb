class GitlabMonitor < Formula
  desc "K9s-style TUI for monitoring GitLab pipelines"
  homepage "https://github.com/bearded-giant/gitlab-monitor"
  version "1.2.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-aarch64-apple-darwin"
      sha256 "42485889dfb089ce942b3ebb28cbaa1d7c902bdc2203837f33d5e585de4b71f5"
    else
      url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-x86_64-apple-darwin"
      sha256 "d13607f231d60927132564934a1542f6a5f6523a406c087b731537d9fc92bbf4"
    end
  end

  on_linux do
    url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-x86_64-unknown-linux-gnu"
    sha256 "5626336aa983c935a98e45d372d61b457d8b6a530f3a5f0d053988488c7344e6"
  end

  def install
    bin.install Dir["glmon-*"].first => "glmon"
    bin.install_symlink "glmon" => "gitlab-monitor"
  end

  test do
    assert_match "Error", shell_output("#{bin}/glmon 2>&1", 1)
  end
end
