{ config, pkgs, ... }:
{
  catppuccin.dunst.enable = true;

  home.packages = with pkgs; [
    libnotify

    (writeShellScriptBin "changeVolume" ''
      #!/usr/bin/env bash
      # Arbitrary but unique message tag
      msgTag="myvolume"

      # Change the volume using wpctl
      wpctl set-volume @DEFAULT_SINK@ "$@" >/dev/null

      # Query wpctl for the current volume and whether or not the speaker is muted
      volume="$(wpctl get-volume @DEFAULT_SINK@ | awk '{print int($2*100)}')"
      mute="$(wpctl get-volume @DEFAULT_SINK@ | awk '{print $3}')"

      if [[ $volume == 0 || "$mute" == "[MUTED]" ]]; then
        # Show the sound muted notification
        dunstify -a "changeVolume" -u low -i audio-volume-muted -h string:x-dunst-stack-tag:$msgTag "Volume muted"
      else
        # Show the volume notification
        dunstify -a "changeVolume" -u low -i audio-volume-high -h string:x-dunst-stack-tag:$msgTag -h int:value:"$volume" "Volume: ''${volume}%"
      fi
    '')
    (writeShellScriptBin "changeBrightness" ''
      #!/usr/bin/env bash
      # Arbitrary but unique message tag
      msgTag="mybrightness"

      # Change the brightness using brightnessctl
      brightnessctl set "$@" >/dev/null

      # Query brightnessctl for the current brightness
      brightness="$(brightnessctl i | grep .% | awk '{print $4}' | sed 's/[^0-9]*//g')"

      # Show the brightness notification
      dunstify -a "changeBrightness" -u low -i brightnesssettings -h string:x-dunst-stack-tag:$msgTag -h int:value:"$brightness" "Brightness: ''${brightness}%"
    '')
  ];

  systemd.user.services.dunst.Service.Slice = "background.slice";

  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "mouse";
        indicate_hidden = "yes";

        offset = "(10, 10)";
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
        browser = "${pkgs.lib.getExe config.programs.firefox.finalPackage} --new-tab";

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
