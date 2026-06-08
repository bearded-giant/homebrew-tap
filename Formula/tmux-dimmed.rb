class TmuxDimmed < Formula
  desc "Terminal multiplexer, patched to dim inactive panes"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.6b/tmux-3.6b.tar.gz"
  sha256 "390759d25fdba016887ec982b808927e637070fd7d03a8021f8ef3102b9ae3c7"
  license "ISC"

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "ncurses"
  depends_on "utf8proc"

  uses_from_macos "bison" => :build # for yacc

  patch do
    url "https://raw.githubusercontent.com/bearded-giant/homebrew-tap/main/patches/tmux-dimmed-3.6b.patch"
    sha256 "f0142b28c8427a79c85416356952e9863791bfada011cb36b26460107acc2330"
  end

  def install
    args = %W[
      --enable-sixel
      --sysconfdir=#{etc}
      --enable-utf8proc
    ]
    args << "--with-TERM=screen-256color" if OS.mac? && MacOS.version < :sonoma

    system "./configure", *args, *std_configure_args
    system "make", "install"

    pkgshare.install "example_tmux.conf"
  end

  def caveats
    <<~EOS
      Patched tmux that dims inactive panes. Installs the `tmux` binary.
      Core tmux is kept (sesh depends on it) but should be unlinked:
        brew unlink tmux && brew link --overwrite tmux-dimmed
        brew pin tmux   # stop future brew upgrade from relinking core
    EOS
  end

  test do
    system bin/"tmux", "-V"
  end
end
