class Mdlive < Formula
  desc "Markdown workspace server for AI coding agents"
  homepage "https://github.com/bearded-giant/mdlive"
  version "2.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-aarch64-apple-darwin"
      sha256 "84384cfa81a2d12861822571ee3c28a9d4f3cb03e89a00809ddeb69899a06eb2"
    else
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-x86_64-apple-darwin"
      sha256 "df5487b551bc028f364751a559c09fc7d4ee9c422bc369cad7e08361da8e357a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-aarch64-unknown-linux-gnu"
      sha256 "8e2795f09c9a6f2fb3ddfad913888d57a6c2b908dc37396cbb0255331e71300b"
    else
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-x86_64-unknown-linux-gnu"
      sha256 "24bddb62c59c61f9fb5d89ab3bbe871f1a1e746ce95d04c61ebc17f871c6c2b4"
    end
  end

  def install
    bin.install Dir["mdlive-*"].first => "mdlive"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdlive --version")
  end
end
