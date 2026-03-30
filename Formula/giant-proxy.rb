class GiantProxy < Formula
  desc "HTTPS proxy with Map Remote rules"
  homepage "https://github.com/bearded-giant/gproxy"
  version "0.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bearded-giant/gproxy/releases/download/v#{version}/giant-proxy-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "59820766c95556b79af34b0000d1a61e27e413b1e61087687ff3c75640b3e8f7"
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
