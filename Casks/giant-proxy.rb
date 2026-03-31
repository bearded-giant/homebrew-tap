cask "giant-proxy" do
  version "0.5.1"

  on_arm do
    url "https://github.com/bearded-giant/gproxy/releases/download/v#{version}/Giant.Proxy_#{version}_aarch64.dmg"
    sha256 "b7acefbc87cfb1b06a0fb51dfc400ebd94e910dc2be785959e9b2de38699ec6b"
  end

  name "Giant Proxy"
  desc "HTTPS proxy with Map Remote rules"
  homepage "https://github.com/bearded-giant/gproxy"

  app "Giant Proxy.app"
end
