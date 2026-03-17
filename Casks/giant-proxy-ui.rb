cask "giant-proxy-ui" do
  version "0.1.0"

  on_arm do
    url "https://github.com/bearded-giant/gproxy/releases/download/v#{version}/Giant.Proxy_#{version}_aarch64.dmg"
    sha256 "PLACEHOLDER"
  end
  on_intel do
    url "https://github.com/bearded-giant/gproxy/releases/download/v#{version}/Giant.Proxy_#{version}_x64.dmg"
    sha256 "PLACEHOLDER"
  end

  name "Giant Proxy"
  desc "Menubar app for Giant Proxy"
  homepage "https://github.com/bearded-giant/gproxy"

  depends_on formula: "bearded-giant/tap/giant-proxy"

  app "Giant Proxy.app"
end
