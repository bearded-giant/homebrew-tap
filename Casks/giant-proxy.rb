cask "giant-proxy" do
  version "0.5.0"

  on_arm do
    url "https://github.com/bearded-giant/gproxy/releases/download/v#{version}/Giant.Proxy_#{version}_aarch64.dmg"
    sha256 "4016276ac9b50b1ec4cd987c33fdfe8a334fac32218817643eac35f2698dfad2"
  end

  name "Giant Proxy"
  desc "HTTPS proxy with Map Remote rules"
  homepage "https://github.com/bearded-giant/gproxy"

  app "Giant Proxy.app"
end
