cask "mdlive-app" do
  version "2.2.2"
  sha256 "c357590bb354d3d2040dd3ef6f72f249a822d47bd1a80ce578fea399ba994ba8"

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
