cask "giant-proxy-ui" do
  version "0.3.0"

  on_arm do
    url "https://github.com/bearded-giant/gproxy/releases/download/v#{version}/Giant.Proxy_#{version}_aarch64.dmg"
    sha256 "2be7bb6f69ed59025a6e85288d010ed3bbe157267a13897557ee5414857a3e12"
  end

  name "Giant Proxy"
  desc "Menubar app for Giant Proxy"
  homepage "https://github.com/bearded-giant/gproxy"

  depends_on formula: "bearded-giant/tap/giant-proxy"

  app "Giant Proxy.app"
end
