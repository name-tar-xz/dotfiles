_: {
  programs.hyprlock = {
    enable = true;
    settings =
      let
        font = "sans";
        fc = "rgb(217,225,239)";
      in
      {
        background = [
          {
            path = "${./.walls/windows-error.jpg}";
            blur_passes = 0;
            blur_size = 0;
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
            position = "0, 124";
            text_align = "center";
            valign = "bottom";
            halign = "center";
          }
          {
            text = "cmd[update:0] echo \"<b><big> $(/run/current-system/sw/bin/date +'%d/%m/%y') </big></b>\"";
            font_size = 16;
            font_family = font;
            color = fc;
            position = "0, 116";
            text_align = "center";
            valign = "bottom";
            halign = "center";
          }
        ];
      };
  };
}
