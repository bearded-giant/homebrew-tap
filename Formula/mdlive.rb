class Mdlive < Formula
  desc "Markdown workspace server for AI coding agents"
  homepage "https://github.com/bearded-giant/mdlive"
  version "2.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-aarch64-apple-darwin"
      sha256 "3bb995e8530ab8db60fb40f750b6ccbbc8da4f78aa12b7b3632b60fb664a6e94"
    else
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-x86_64-apple-darwin"
      sha256 "d37b0530d1c6cc3a39f5551e2a7dbacf54b9e7ab640808d83865deda12cf8323"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-aarch64-unknown-linux-gnu"
      sha256 "7d81b09aeca12cd2389e3866724a65cfca01091581864addb9cbc48a77f8f7f3"
    else
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-x86_64-unknown-linux-gnu"
      sha256 "4f7cc39a47ac2846d19a0aa99408b920bacba372f5bd1bfd2f5819ccf02cb5c7"
    end
  end

  def install
    bin.install Dir["mdlive-*"].first => "mdlive"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdlive --version")
  end
end
