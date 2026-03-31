cask "giant-proxy" do
  version "0.5.2"

  on_arm do
    url "https://github.com/bearded-giant/gproxy/releases/download/v#{version}/Giant.Proxy_#{version}_aarch64.dmg"
    sha256 "714543d3da2222df7991335bbb122d996122a1f6c84d1d2a9ce2eeb7520d2515"
  end

  name "Giant Proxy"
  desc "HTTPS proxy with Map Remote rules"
  homepage "https://github.com/bearded-giant/gproxy"

  app "Giant Proxy.app"
end
