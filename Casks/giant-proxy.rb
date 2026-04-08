cask "giant-proxy" do
  version "0.6.0"

  on_arm do
    url "https://github.com/bearded-giant/gproxy/releases/download/v#{version}/Giant.Proxy_#{version}_aarch64.dmg"
    sha256 "1ad9cf98356ee4446034fcad0e06f7b12fe2451715d4b088add89e4e05a155c6"
  end

  name "Giant Proxy"
  desc "HTTPS proxy with Map Remote rules"
  homepage "https://github.com/bearded-giant/gproxy"

  app "Giant Proxy.app"
end
