class GiantProxyCli < Formula
  desc "Giant Proxy CLI + daemon (headless, no GUI)"
  homepage "https://github.com/bearded-giant/gproxy"
  version "0.5.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bearded-giant/gproxy/releases/download/v#{version}/giant-proxy-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "040d025ba45b5f15af4a2c7ccb2d429e183e58e1b461072e0346892c36bcf63f"
    end
  end

  def install
    bin.install "giantd"
    bin.install "giant-proxy"
  end

  def post_install
    ohai "Run `giant-proxy init` to set up CA certificate"
  end

  test do
    assert_match "giant-proxy", shell_output("#{bin}/giant-proxy version")
  end
end
