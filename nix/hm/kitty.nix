{ config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    shellIntegration.mode = "no-cursor no-sudo";
    font = {
      name = "monospace";
      size = 12.7;
    };
    settings = {
      cursor_shape = "underline";
      cursor_underline_thickness = 2;
      cursor_blink_interval = -1;
      cursor_stop_blinking_after = 0;

      scrollback_lines = -1;
      scrollback_pager = config.home.sessionVariables.PAGER;

      mouse_hide_wait = 0;
      url_style = "straight";
      strip_trailing_spaces = "always";

      default_pointer_shape = "arrow";
      pointer_shape_when_dragging = "beam";
      sync_to_monitor = true;

      remember_window_size = true;

      enabled_layouts = "tall,grid";
      window_border_width = 1;
      draw_minimal_borders = false;
      window_margin_width = 0;
      single_window_margin_width = -1;
      window_padding_width = 0;

      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_max_length = 32;

      background_opacity = "0.8";
      # The basic colors
      foreground = "#cdd6f4";
      background = "#000000";
      selection_foreground = "none";
      selection_background = "none";
      cursor = "none";
      url_color = "#f5e0dc";
      # Kitty window border colors
      active_border_color = "#b4befe";
      inactive_border_color = "#000000";
      bell_border_color = "#f9e2af";
      # Tab bar colors
      active_tab_foreground = "#11111b";
      active_tab_background = "#cba6f7";
      inactive_tab_foreground = "#cdd6f4";
      inactive_tab_background = "#181825";
      tab_bar_background = "#11111b";
      # Colors for marks (marked text in the terminal)
      mark1_foreground = "#1e1e2e";
      mark1_background = "#b4befe";
      mark2_foreground = "#1e1e2e";
      mark2_background = "#cba6f7";
      mark3_foreground = "#1e1e2e";
      mark3_background = "#74c7ec";
      # black
      color0 = "#45475a";
      color8 = "#585b70";
      # red
      color1 = "#f38ba8";
      color9 = "#eba0ac";
      # green
      color2 = "#a6e3a1";
      color10 = "#94e2d5";
      # yellow
      color3 = "#fab387";
      color11 = "#f9e2af";
      # blue
      color4 = "#89b4fa";
      color12 = "#b4befe";
      # magenta
      color5 = "#cba6f7";
      color13 = "#f5c2e7";
      # cyan
      color6 = "#74c7ec";
      color14 = "#89dceb";
      # white
      color7 = "#bac2de";
      color15 = "#a6adc8";

      shell = "${pkgs.lib.getExe pkgs.zsh}";

      update_check_interval = 0;
      allow_hyperlinks = true;

      kitty_mod = "ctrl+shift";
    };
    keybindings = {
      "kitty_mod+u" = "scroll_page_up";
      "kitty_mod+d" = "scroll_page_down";
      "kitty_mod+enter" = "launch --cwd=current";
      "kitty_mod+space" = "kitten unicode_input";
    };
    extraConfig = ''
      font_features IosevkaTermNFM +dlig
      font_features IosevkaTermNFM-SemiBold +dlig
      font_features IosevkaTermNFM-Italic +dlig
      font_features IosevkaTermNFM-SemiBoldItalic +dlig
    '';
  };
}
