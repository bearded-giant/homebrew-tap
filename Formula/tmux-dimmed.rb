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

  patch :DATA

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

__END__
diff --git i/colour.c w/colour.c
index 791c5fd..2006fcf 100644
--- i/colour.c
+++ w/colour.c
@@ -120,6 +120,70 @@ colour_force_rgb(int c)
 	return (-1);
 }
 
+/*
+ * Local patch: produce a dimmed version of a colour for inactive-pane content.
+ * Two-stage algorithm:
+ *   1. Desaturate by blending each channel 10% toward perceptual luma. This
+ *      keeps a hint of the hue but kills extreme saturation, which prevented
+ *      e.g. very saturated blues from blowing out on some terminals.
+ *   2. Blend the desaturated result 25% toward the target colour (normally the
+ *      pane's default bg) so everything fades into the muted bg.
+ * Works correctly for both dark and light themes because the target colour
+ * drives the dim direction. If either colour can't be resolved to RGB the
+ * input is returned unchanged.
+ */
+int
+colour_dim(int c, int target)
+{
+	u_char	r, g, b, tr, tg, tb;
+	int	rgb, trgb;
+	int	luma, sr, sg, sb;
+
+	rgb = colour_force_rgb(c);
+	if (rgb == -1)
+		return (c);
+	trgb = colour_force_rgb(target);
+	if (trgb == -1)
+		trgb = colour_join_rgb(0x18, 0x18, 0x1f);
+
+	colour_split_rgb(rgb, &r, &g, &b);
+	colour_split_rgb(trgb, &tr, &tg, &tb);
+
+	/* Perceptual luma (Rec. 601 weights), scaled by 1000 for integer math. */
+	luma = (299 * r + 587 * g + 114 * b) / 1000;
+
+	/* Step 1: desaturate 10% toward luma — keeps 90% of the chroma. */
+	sr = (r * 90 + luma * 10) / 100;
+	sg = (g * 90 + luma * 10) / 100;
+	sb = (b * 90 + luma * 10) / 100;
+
+	/* Step 2: blend 25% toward target — pulls colors into the muted bg. */
+	sr = (sr * 75 + tr * 25) / 100;
+	sg = (sg * 75 + tg * 25) / 100;
+	sb = (sb * 75 + tb * 25) / 100;
+
+	return (colour_join_rgb((u_char)sr, (u_char)sg, (u_char)sb));
+}
+
+/*
+ * Local patch: hue-preserving darken. Scale each RGB channel to keep% of its
+ * value (keep=75 -> 25% darker). Used to push inactive-pane backgrounds darker
+ * than the content dim alone, without shifting hue. Returns input unchanged if
+ * it can't be resolved to RGB.
+ */
+int
+colour_darken(int c, int keep)
+{
+	u_char	r, g, b;
+	int	rgb;
+
+	rgb = colour_force_rgb(c);
+	if (rgb == -1)
+		return (c);
+	colour_split_rgb(rgb, &r, &g, &b);
+	return (colour_join_rgb(r * keep / 100, g * keep / 100, b * keep / 100));
+}
+
 /* Convert colour to a string. */
 const char *
 colour_tostring(int c)
diff --git i/screen-redraw.c w/screen-redraw.c
index 1c1b850..4b9a98b 100644
--- i/screen-redraw.c
+++ w/screen-redraw.c
@@ -905,6 +905,14 @@ screen_redraw_draw_pane(struct screen_redraw_ctx *ctx, struct window_pane *wp)
 		top = ctx->statuslines;
 	else
 		top = 0;
+
+	/*
+	 * Local patch: full-redraw path. tty_attributes() will dim cells while
+	 * this flag is set; clear it after drawing this pane so subsequent
+	 * borders/status lines render at full brightness.
+	 */
+	tty->dim_inactive = (wp != w->active);
+
 	for (j = 0; j < wp->sy; j++) {
 		if (wp->yoff + j < ctx->oy || wp->yoff + j >= ctx->oy + ctx->sy)
 			continue;
@@ -940,6 +948,8 @@ screen_redraw_draw_pane(struct screen_redraw_ctx *ctx, struct window_pane *wp)
 		tty_draw_line(tty, s, i, j, width, x, y, &defaults, palette);
 	}
 
+	tty->dim_inactive = 0;
+
 #ifdef ENABLE_SIXEL
 	tty_draw_images(c, wp, s);
 #endif
diff --git i/screen-write.c w/screen-write.c
index a2755d3..cbef4f5 100644
--- i/screen-write.c
+++ w/screen-write.c
@@ -164,6 +164,13 @@ screen_write_set_client_cb(struct tty_ctx *ttyctx, struct client *c)
 	if (status_at_line(c) == 0)
 		ttyctx->yoff += status_line_size(c);
 
+	/*
+	 * Local patch: flag the client tty so subsequent tty_attributes() calls
+	 * dim cells when the pane is not the active pane in its window.
+	 * tty_write() clears this after the per-command call returns.
+	 */
+	c->tty.dim_inactive = (wp != wp->window->active);
+
 	return (1);
 }
 
diff --git i/tmux.h w/tmux.h
index 1927fa9..73b74c8 100644
--- i/tmux.h
+++ w/tmux.h
@@ -1620,6 +1620,15 @@ struct tty {
 
 	struct event	 key_timer;
 	struct tty_key	*key_tree;
+
+	/*
+	 * Local patch: when nonzero, the cells about to be drawn belong to a
+	 * pane that is not the active pane in its window. tty_attributes() uses
+	 * this to blend fg/bg/us toward the pane's default bg, dimming arbitrary
+	 * ANSI-colored content (e.g. lazygit) — not just cells using the
+	 * terminal default colors that window-style already covers.
+	 */
+	int		 dim_inactive;
 };
 
 /* Terminal command context. */
@@ -3006,6 +3015,8 @@ int	 colour_find_rgb(u_char, u_char, u_char);
 int	 colour_join_rgb(u_char, u_char, u_char);
 void	 colour_split_rgb(int, u_char *, u_char *, u_char *);
 int	 colour_force_rgb(int);
+int	 colour_dim(int, int);
+int	 colour_darken(int, int);
 const char *colour_tostring(int);
 enum client_theme colour_totheme(int);
 int	 colour_fromstring(const char *);
diff --git i/tty.c w/tty.c
index 71293f6..4adb60e 100644
--- i/tty.c
+++ w/tty.c
@@ -1769,6 +1769,8 @@ tty_write(void (*cmdfn)(struct tty *, const struct tty_ctx *),
 			if (state == 0)
 				continue;
 			cmdfn(&c->tty, ctx);
+			/* Local patch: clear inactive-dim state set by the cb. */
+			c->tty.dim_inactive = 0;
 		}
 	}
 }
@@ -2756,6 +2758,19 @@ tty_attributes(struct tty *tty, const struct grid_cell *gc,
 	tty_check_bg(tty, palette, &gc2);
 	tty_check_us(tty, palette, &gc2);
 
+	/*
+	 * Local patch: if the cell belongs to an inactive pane, darken ONLY its
+	 * background, leaving fg/underline at full color. Resolves a default bg
+	 * (8/9/-1) to the terminal's real bg first so default-bg cells darken too.
+	 * Text keeps its hue; only the canvas behind it dims.
+	 */
+	if (tty->dim_inactive) {
+		int bg = gc2.bg;
+		if (bg == 8 || bg == 9 || bg == -1)
+			bg = tty->bg;
+		gc2.bg = colour_darken(bg, 80);
+	}
+
 	/*
 	 * If any bits are being cleared or the underline colour is now default,
 	 * reset everything.
