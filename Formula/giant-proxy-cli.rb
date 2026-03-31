class GiantProxyCli < Formula
  desc "Giant Proxy CLI + daemon (headless, no GUI)"
  homepage "https://github.com/bearded-giant/gproxy"
  version "0.5.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bearded-giant/gproxy/releases/download/v#{version}/giant-proxy-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "5913c520b318bc40b38489a1fd3eed2a48a2ece9c3450ac913f7473e83d584da"
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
