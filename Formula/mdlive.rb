class Mdlive < Formula
  desc "Markdown workspace server for AI coding agents"
  homepage "https://github.com/bearded-giant/mdlive"
  version "2.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-aarch64-apple-darwin"
      sha256 "2bac9460d55ef00efcc19ea56e2f443ed4c7856059c588d082a681ec3e8fdacc"
    else
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-x86_64-apple-darwin"
      sha256 "12203bbb66742689f625f74fda7c78986b85b08062f9cf7100dddc66ac4ed9f6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-aarch64-unknown-linux-gnu"
      sha256 "643601df225f56eecb8f0ffe35f0b0b4bf73b91342b89457a637e41e4b51cf39"
    else
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-x86_64-unknown-linux-gnu"
      sha256 "c85adc56c7e9081faaae4d01f4ae9843cc11d8b96e6c68b3a2ee397f314dcb5a"
    end
  end

  def install
    bin.install Dir["mdlive-*"].first => "mdlive"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdlive --version")
  end
end
