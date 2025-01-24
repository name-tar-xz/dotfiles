{ config, pkgs, ... }:
{
  catppuccin.dunst.enable = true;

  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "mouse";
        indicate_hidden = "yes";

        offset = "10x10";
        origin = "top-center";

        separator_height = 2;

        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 2;

        sort = "yes";
        idle_threshold = 120;
        font = "monospace 10";
        line_height = 0;
        markup = "full";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        word_wrap = "yes";
        stack_duplicates = true;
        hide_duplicate_count = false;

        show_indicators = "yes";

        min_icon_size = 0;
        max_icon_size = 64;

        dmenu = "${pkgs.lib.getExe config.programs.rofi.finalPackage} -dmenu -p dunst:";
        browser = "${pkgs.lib.getExe config.programs.librewolf.finalPackage} --new-tab";

        title = "Dunst";
        class = "Dunst";

        corner_radius = 10;
        timeout = 5;
      };
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
      size = "16x16";
    };
  };
}
