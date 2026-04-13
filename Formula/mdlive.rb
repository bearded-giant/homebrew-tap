class Mdlive < Formula
  desc "Markdown workspace server for AI coding agents"
  homepage "https://github.com/bearded-giant/mdlive"
  version "2.3.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-aarch64-apple-darwin"
      sha256 "2872ab1c230563ea8ce01726be5a28dab51d4feb09bfbf5f8e2a0423ce7fe6d8"
    else
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-x86_64-apple-darwin"
      sha256 "7e4f0971f0cf1553b450689ed2d33fb5371218b7a81de7d59bb2f421fb0e3dd9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-aarch64-unknown-linux-gnu"
      sha256 "4a41db5dbdddd9f97917712f30c2b2629698a0147376f65c6534ef27d0514b6c"
    else
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-x86_64-unknown-linux-gnu"
      sha256 "c9117cefae987ffee7c7fb3448206a571b7e886f8bdc204a247e3e511c3a6ae5"
    end
  end

  def install
    bin.install Dir["mdlive-*"].first => "mdlive"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdlive --version")
  end
end
