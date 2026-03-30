class GiantProxy < Formula
  desc "HTTPS proxy with Map Remote rules"
  homepage "https://github.com/bearded-giant/gproxy"
  version "0.4.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bearded-giant/gproxy/releases/download/v#{version}/giant-proxy-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "b50f0ccb2aa0340926f7f39189054070e9ba6b1f92833ea928dcbe253ee13bb3"
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
