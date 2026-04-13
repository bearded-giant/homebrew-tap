cask "mdlive-app" do
  version "2.3.3"
  sha256 "afdf9bab1bc704a06c9a3375a46c840817afd3b0efc795039d55203bef055197"

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
