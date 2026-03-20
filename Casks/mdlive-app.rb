cask "mdlive-app" do
  version "2.2.1"
  sha256 "aab4237ada9b931505f6a9277b921a67abf5e313839bea66437d7bf06c6e2d52"

  url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive_#{version}_aarch64.dmg"
  name "mdlive"
  desc "Markdown workspace server for AI coding agents"
  homepage "https://github.com/bearded-giant/mdlive"

  app "mdlive.app"

  zap trash: [
    "~/Library/Application Support/com.beardedgiant.mdlive",
    "~/.config/mdlive",
  ]
end
