cask "mdlive-app" do
  version "2.3.2"
  sha256 "dec1b46a7b6e681de30e34bc4a619c2f37ff068e7c5a40f3eed21cf3acf588d3"

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
