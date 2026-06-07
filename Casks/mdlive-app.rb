cask "mdlive-app" do
  version "2.3.6"
  sha256 "73b589ddb86fede80e14cde5842446cb32114d25db53c77d181c5c5afd8b07e5"

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
