_: {
  services.playerctld.enable = true;
  systemd.user.services = {
    noctalia.Service.Slice = "background.slice";
    playerctld.Service.Slice = "background.slice";
  };
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      audio = {
        sound_volume = 0;
      };
      bar = {
        default = {
          end = [
            "tray"
            "network"
            "network_rx"
            "bluetooth"
            "output_volume"
            "input_volume"
            "brightness"
            "temp"
            "cpu"
            "ram"
            "battery"
            "power_profile"
          ];
          font_scale = 0.85;
          margin_ends = 0;
          panel_overlap = 0;
          position = "left";
          radius_bottom_left = 0;
          radius_top_left = 0;
          shadow = false;
          start = [
            "workspaces"
            "media"
          ];
        };
      };
      calendar = { };
      control_center = {
        calendar = {
          show_events_card = false;
          show_week_numbers = true;
        };
      };
      lockscreen = {
        enabled = false;
      };
      lockscreen_widgets = {
        enabled = false;
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        schema_version = 2;
        widget = {
          "lockscreen-login-box@eDP-1" = {
            box_height = 196;
            box_width = 810;
            cx = 1152;
            cy = 1258;
            output = "eDP-1";
            placement_height = 1440;
            placement_width = 2304;
            rotation = 0;
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12;
              center_password_text = false;
              input_opacity = 1;
              input_radius = 6;
              layout = "regular";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_session_buttons = true;
              show_unlock_hint = true;
              show_weather = true;
            };
            type = "login_box";
          };
        };
        widget_order = [ "lockscreen-login-box@eDP-1" ];
      };
      notification = {
        enable_daemon = false;
      };
      osd = {
        enabled = false;
        orientation = "vertical";
        position = "bottom_left";
        position_vertical = "bottom_left";
      };
      shell = {
        panel = {
          open_near_click_control_center = true;
          open_near_click_session = true;
        };
        popup_shadows = false;
      };
      theme = {
        builtin = "Catppuccin";
        community_palette = "Osaka jade";
        mode = "dark";
        pure_black_dark = true;
        source = "builtin";
        templates = {
          enable_builtin_templates = false;
        };
        wallpaper_scheme = "m3-content";
      };
      wallpaper = {
        default = {
          path = "/nix/store/bcizdbjfzqiwhnshdz4cdmxzm2i1gwbc-noctalia-5.1.0/share/noctalia/assets/noctalia-wallpaper.png";
        };
        enabled = false;
        last = {
          path = "/nix/store/bcizdbjfzqiwhnshdz4cdmxzm2i1gwbc-noctalia-5.1.0/share/noctalia/assets/noctalia-wallpaper.png";
        };
      };
      widget = {
        battery = {
          color = "#A6E3A1";
        };
        bluetooth = {
          color = "#89B4FA";
        };
        brightness = {
          color = "#F9E2AF";
        };
        clock = {
          format = "{:%H %M ·· %d %m}";
          scale = 1.4;
          tooltip_format = "{:%d/%m/%Y}";
        };
        cpu = {
          color = "#B4BEFE";
          glyph = "cpu";
          label_show_units = false;
          stat = "cpu_freq";
          visualization = "none";
        };
        input_volume = {
          actions = {
            scroll_down = "mic-volume-up";
            scroll_up = "mic-volume-down";
          };
          color = "#F5C2E7";
          mute_color = "#313244";
        };
        lock_keys = {
          enabled = false;
        };
        media = {
          hide_when_no_media = true;
          title_scroll = "always";
        };
        network = {
          color = "secondary";
          show_label = false;
        };
        network_rx = {
          actions = {
            left = "panel-toggle control-center network";
            right = "network-toggle";
          };
          color = "secondary";
          network_speed_compact = true;
          network_speed_unit = "mb";
          show_glyph = false;
          visualization = "none";
        };
        output_volume = {
          actions = {
            scroll_down = "volume-up";
            scroll_up = "volume-down";
          };
          color = "#F5C2E7";
          mute_color = "#313244";
        };
        ram = {
          glyph = "database";
          label_show_units = false;
          visualization = "none";
        };
        temp = {
          color = "#89DCEB";
          glyph = "temperature";
          highlight_color = "#F38BA8";
          visualization = "none";
        };
        workspaces = {
          change_color_on_hover = false;
          empty_color = "surface";
          focused_color = "#89B4FA";
          occupied_color = "surface";
          scale = 1.2;
        };
      };
    };
  };
}
