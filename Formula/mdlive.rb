class Mdlive < Formula
  desc "Markdown workspace server for AI coding agents"
  homepage "https://github.com/bearded-giant/mdlive"
  version "2.2.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-aarch64-apple-darwin"
      sha256 "656b40cb977c85a2c7d2a10a996cac07e0aecb6b4d668d30c256ae4b5ae4d8d9"
    else
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-x86_64-apple-darwin"
      sha256 "801e677f111f2325424451767069e93d7d3e84ade9c384eff80de5d268449363"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-aarch64-unknown-linux-gnu"
      sha256 "4b587da77c7e62420ecacce96a8a223fa88cc212242473cba98b701ec8226dbe"
    else
      url "https://github.com/bearded-giant/mdlive/releases/download/v#{version}/mdlive-x86_64-unknown-linux-gnu"
      sha256 "1cf3898e861d56d2e31c08d5de1e69ed3f4e2f22a1d0e64d3588d60b0d755835"
    end
  end

  def install
    bin.install Dir["mdlive-*"].first => "mdlive"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdlive --version")
  end
end
