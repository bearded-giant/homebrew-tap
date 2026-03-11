class GitlabMonitor < Formula
  desc "K9s-style TUI for monitoring GitLab pipelines"
  homepage "https://github.com/bearded-giant/gitlab-monitor"
  version "1.1.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-aarch64-apple-darwin"
      sha256 "a5767d392da93e20a4917be3e13a827f3c62abea95068a76d9a7fbaf29d52986"
    else
      url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-x86_64-apple-darwin"
      sha256 "0a87958af922468574384f42c61faf0c3b894dfb32b0c2b40f52dcf3b1a8d09a"
    end
  end

  on_linux do
    url "https://github.com/bearded-giant/gitlab-monitor/releases/download/v#{version}/glmon-x86_64-unknown-linux-gnu"
    sha256 "2e563af22e5296c7564b8d7b3a79891e9102dd9506c36cdcbdd28a202fa45ae3"
  end

  def install
    bin.install Dir["glmon-*"].first => "glmon"
    bin.install_symlink "glmon" => "gitlab-monitor"
  end

  test do
    assert_match "Error", shell_output("#{bin}/glmon 2>&1", 1)
  end
end
