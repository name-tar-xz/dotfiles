{ ... }:
{
  services.playerctld.enable = true;
  systemd.user.services.waybar.Unit.ConditionEnvironment = "WAYLAND_DISPLAY";

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        rotate = 270;
        spacing = 0;
        margin = "0 0 0 0";

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "privacy"
          "mpris"
        ];
        modules-right = [
          "temperature"
          "custom/fan"
          "cpu"
          "memory"
          "network"
          "bluetooth"
          "group/audio"
          "battery"
          "clock"
          "idle_inhibitor"
          "tray"
        ];

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [
            ""
            ""
          ];
          on-scroll-down = "brightnessctl -c backlight set +5%";
          on-scroll-up = "brightnessctl -c backlight set 5%-";
        };
        battery = {
          format = "{icon}{capacity: >3}%";
          format-charging = "󰂄{capacity: >3}%";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          format-plugged = "󰚥{capacity: >3}%";
          interval = 1;
          states = {
            critical = 15;
            good = 95;
            warning = 30;
          };
        };
        bluetooth = {
          format = "";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} [{device_battery_percentage}%]";
          format-disabled = "";
          on-click = "overskride";
          tooltip-format = "{controller_alias}";
          tooltip-format-connected = "{controller_alias} : {num_connections} connected\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}";
          tooltip-format-enumerate-connected-battery = "{device_alias} [{device_battery_percentage}%]";
        };
        clock = {
          actions = {
            on-click-backward = "tz_down";
            on-click-forward = "tz_up";
            on-click-right = "mode";
            on-scroll-down = "shift_down";
            on-scroll-up = "shift_up";
          };
          calendar = {
            format = {
              days = "<span color='#cdd6f4'>{}</span>";
              months = "<span color='#89b4fa'><i><b>{}</b></i></span>";
              today = "<span color='#cba6f7'><b><i>{}</i></b></span>";
              weekdays = "<span color='#b4befe'><b>{}</b></span>";
              weeks = "<span color='#89dceb'><i>{}</i></span>";
            };
            mode = "year";
            mode-mon-col = 3;
            on-click-right = "mode";
            on-scroll = -1;
            weeks-pos = "left";
          };
          format = " {:%d/%m  %H:%M}";
          format-alt = " {:%a %d %b  %H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };
        cpu = {
          format = "󰻠 {max_frequency:2.1f}GHz";
          interval = 2;
        };
        "custom/fan" = {
          exec = "cat /sys/devices/platform/asus-nb-wmi/hwmon/hwmon*/fan1_input";
          format = "󰈐 {: >4}";
          interval = 5;
        };
        "group/audio" = {
          drawer = {
            children-class = "audio";
            transition-duration = 500;
            transition-left-to-right = false;
          };
          modules = [
            "pulseaudio"
            "pulseaudio#microphone"
          ];
          orientation = "inherit";
        };
        "hyprland/window" = {
          format = "{}";
          icon = true;
          icon-size = 18;
          max-length = 80;
          rewrite = {
            "(.*) - zsh" = "> [$1]";
            "(.*) — LibreWolf" = "$1";
          };
          separate-outputs = false;
        };
        "hyprland/workspaces" = {
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "10" = "0";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "󰈹";
            "7" = "";
            "8" = "8";
            "9" = "9";
            default = "󰟒";
            focused = "";
          };
          on-click = "activate";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          sort-by-number = true;
        };
        idle_inhibitor = {
          format = "{icon} ";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        memory = {
          format = " {used:2.0f}G";
          tooltip-format = "{used}GiB RAM\n{swapUsed}GiB Swap";
        };
        mpris = {
          dynamic-order = [
            "title"
            "album"
            "artist"
            "position"
            "length"
          ];
          format = "{player_icon} {dynamic}";
          format-paused = "{player_icon} <i>{dynamic}</i>";
          interval = 1;
          max-length = 80;
          player-icons = {
            default = "";
            firefox = "󰈹";
            librewolf = "󰈹";
            mpv = "";
          };
          status-icons = {
            paused = "󰐊";
            playing = "󰏤";
            stopped = "󰓛";
          };
        };
        network = {
          format = "󰤮 Off";
          format-disconnected = "󰤫 D/C";
          format-ethernet = " {ifname}: {ipaddr}/{cidr}";
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-wifi = "{icon} {bandwidthDownBytes}";
          interval = 1;
          on-click = "iwgtk";
          tooltip-format = "{essid} ({frequency} MHz) {signalStrength}%\n⇣{bandwidthDownBytes} ⇡{bandwidthUpBytes}";
        };
        privacy = {
          icon-size = 18;
          icon-spacing = 4;
          modules = [
            {
              tooltip = true;
              tooltip-icon-size = 24;
              type = "screenshare";
            }
            {
              tooltip = false;
              tooltip-icon-size = 24;
              type = "audio-out";
            }
            {
              tooltip = true;
              tooltip-icon-size = 24;
              type = "audio-in";
            }
          ];
          transition-duration = 250;
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-icons = {
            car = "";
            default = [
              ""
              ""
              ""
            ];
            handsfree = "";
            headphones = "";
            headset = "";
            phone = "";
            portable = "";
          };
          format-muted = "󰝟";
          on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
          on-scroll-down = "wpctl set-volume @DEFAULT_SINK@ 5%+";
          on-scroll-up = "wpctl set-volume @DEFAULT_SINK@ 5%-";
          scroll-step = 5;
        };
        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = "󰍬 {volume}%";
          format-source-muted = "󰍭";
          on-click = "wpctl set-mute @DEFAULT_SOURCE@ toggle";
          on-scroll-down = "wpctl set-volume @DEFAULT_SOURCE@ 5%+";
          on-scroll-up = "wpctl set-volume @DEFAULT_SOURCE@ 5%-";
          scroll-step = 5;
        };
        temperature = {
          format = "{icon} {temperatureC}°C";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          interval = 2;
        };
        tray = {
          icon-size = 15;
          spacing = 0;
        };
      };
    };
  };
}
