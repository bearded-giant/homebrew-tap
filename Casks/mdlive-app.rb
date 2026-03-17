cask "mdlive-app" do
  version "2.1.0"
  sha256 "b20591ad700899813d6b50db01026f374695349a098dfc714d7b6d7e8334adfc"

  url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive_#{version}_aarch64.dmg"
  name "mdlive"
  desc "Markdown workspace server for AI coding agents"
  homepage "https://github.com/bearded-giant/mdlive"

  app "mdlive.app"

  postflight do
    # cli is symlinked on first app launch via osascript admin prompt
  end

  zap trash: [
    "~/Library/Application Support/com.beardedgiant.mdlive",
    "~/.config/mdlive",
  ]
end
