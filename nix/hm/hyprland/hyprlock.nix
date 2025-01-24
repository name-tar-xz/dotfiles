{ ... }:
{
  programs.hyprlock = {
    enable = true;
    settings =
      let
        font = "sans";
        fc = "rgb(205,214,244)";
      in
      {
        background = [
          {
            path = "/home/tarxz/Pictures/Wallpaper/the_neon_shallows_by_leikoi_ddm6tx0.png";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        input-field = [
          {
            outer_color = "rgba(0,0,0,0)";
            inner_color = "rgba(17,17,27,0.5)";
            font_color = fc;
            valign = "bottom";
            placeholder_text = "";
            position = "0, 32";
            size = "200, 50";
          }
        ];

        label = [
          {
            text = "cmd[update:1000] echo \"<b><big> $(/run/current-system/sw/bin/date +'%-H:%M:%S') </big></b>\"";
            font_size = "112";
            font_family = font;
            color = fc;
            position = "0, 0";
            text_align = "center";
            valign = "center";
            halign = "center";
          }
          {
            text = "cmd[update:0] echo \"<b><big> $(/run/current-system/sw/bin/date +'%d/%m/%y') </big></b>\"";
            font_size = 16;
            font_family = font;
            color = fc;
            position = "0, -96";
            text_align = "center";
            valign = "center";
            halign = "center";
          }
        ];
      };
  };
}
