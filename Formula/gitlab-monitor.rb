class GitlabMonitor < Formula
  desc "K9s-style TUI for monitoring GitLab pipelines"
  homepage "https://github.com/bearded-giant/gitlab-monitor"
  version "1.1.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-aarch64-apple-darwin"
      sha256 "710949f3df32d239535e802ecb0fd7822cf1e2d0281348b616b7fe9f8d4b1f08"
    else
      url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-x86_64-apple-darwin"
      sha256 "b50ef1d78f562b23890d6ca54ae57e4e9266454859d6bac5be19a6600d90f04d"
    end
  end

  on_linux do
    url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-x86_64-unknown-linux-gnu"
    sha256 "9ba798eff4b7e13958d7f78186c288e9646a216bf76700f650b304dffa2771a2"
  end

  def install
    bin.install Dir["glmon-*"].first => "glmon"
    bin.install_symlink "glmon" => "gitlab-monitor"
  end

  test do
    assert_match "Error", shell_output("#{bin}/glmon 2>&1", 1)
  end
end
