class GiantProxyCli < Formula
  desc "Giant Proxy CLI + daemon (headless, no GUI)"
  homepage "https://github.com/bearded-giant/gproxy"
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bearded-giant/gproxy/releases/download/v#{version}/gproxy-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "a72749f1631e22623a7ce121d2810b7e8023df053478c94e3c62aefb893d634f"
    end
  end

  def install
    bin.install "giantd"
    bin.install "gproxy"
  end

  def post_install
    ohai "Run `gproxy init` to set up CA certificate"
  end

  test do
    assert_match "gproxy", shell_output("#{bin}/gproxy version")
  end
end
