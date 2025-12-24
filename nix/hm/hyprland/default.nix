{ pkgs, ... }:
{
  imports = [
    ./waybar
    ./hyprlock.nix
    ./dunst.nix
    ./hypridle.nix
  ];

  catppuccin.hyprland.enable = true;

  home.packages = with pkgs; [
    hyprpicker
    grimblast # Screenshot
    wl-clipboard # Clipboard
    brightnessctl # Brightness
    rofi-power-menu
  ];

  systemd.user.services = {
    cliphist.Unit.ConditionEnvironment = "WAYLAND_DISPLAY";
    cliphist-images.Unit.ConditionEnvironment = "WAYLAND_DISPLAY";

    lxqt-policykit-agent = {
      Install.WantedBy = [ "graphical-session.target" ];
      Unit = {
        After = [ "graphical-session.target" ];
        Description = "LXQT Polkit Agent";
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.lib.getExe pkgs.lxqt.lxqt-policykit}";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services.cliphist.enable = true;

  xdg.portal.enable = pkgs.lib.mkForce false;

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false;
    settings = {
      exec-once = [
        "${pkgs.lib.getExe pkgs.swaybg} -i ${./.walls/the_neon_shallows_by_leikoi.png} -m fill &"
        "[workspace special:1 silent] uwsm app kitty -1"
      ];

      monitor = ",preferred,auto,1.25";

      input = {
        kb_layout = "us";
        kb_options = "caps:swapescape,compose:ins";
        repeat_delay = 300;
        repeat_rate = 30;
        follow_mouse = 1;
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        touchpad = {
          natural_scroll = true;
          disable_while_typing = false;
          tap-to-click = true;
          drag_lock = true;
        };
        accel_profile = "adaptive";
      };

      gestures.gesture = [
        "3, horizontal, workspace"
        "3, vertical, special, 1"
        "3, pinchout, float"
        "3, pinchin, fullscreen"
      ];

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 2;
        "col.active_border" = "$accent";
        "col.inactive_border" = "rgba(00000000)";
        layout = "dwindle";
        no_border_on_floating = false;
        allow_tearing = true;
      };

      group = {
        "col.border_active" = "$accent";
        "col.border_inactive" = "rgba(00000000)";
        groupbar = {
          gradients = true;
          "col.inactive" = "rgba(00000000)";
          "col.active" = "$accent";
        };
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_autoreload = true;
        vfr = true;
        # vrr = 1;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        enable_swallow = false;
        animate_manual_resizes = true;
        swallow_regex = "^(kitty)$";
        focus_on_activate = true;
        new_window_takes_over_fullscreen = 2;
      };

      decoration = {
        rounding_power = 4;
        rounding = 10;

        active_opacity = 1.0;
        inactive_opacity = 0.95;

        dim_inactive = true;
        dim_strength = 0.3;
        dim_special = 0.3;

        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          new_optimizations = true;
          xray = false;
          special = false;
        };

        shadow.enabled = false;
      };

      xwayland.force_zero_scaling = true;

      animations = {
        bezier = [
          "emphasizedDecel, 0.05, 0.7, 0.1, 1"
          "emphasizedAccel, 0.3, 0, 0.8, 0.15"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.52, 0.03, 0.72, 0.08"
          "stall, 1, -0.1, 0.7, 0.85"
        ];
        animation = [
          "monitorAdded, 0"

          "windowsIn, 1, 3, emphasizedDecel, popin 80%"
          "fadeIn, 1, 3, emphasizedDecel"
          "windowsOut, 1, 2, emphasizedDecel, popin 90%"
          "fadeOut, 1, 2, emphasizedDecel"
          "windowsMove, 1, 3, emphasizedDecel, slide"
          "border, 1, 10, emphasizedDecel"
          "layersIn, 1, 2.7, emphasizedDecel, popin 93%"
          "layersOut, 1, 2.4, menu_accel, popin 94%"
          "fadeLayersIn, 1, 0.5, menu_decel"
          "fadeLayersOut, 1, 2.7, stall"
          "workspaces, 1, 7, menu_decel, slide"
          "specialWorkspaceIn, 1, 2.8, emphasizedDecel, slidevert"
          "specialWorkspaceOut, 1, 1.2, emphasizedAccel, slidevert"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = false;
      };

      master.mfact = 0.5;

      render.direct_scanout = true;

      windowrule = [
        "float, class:file_progress"
        "float, class:confirm"
        "float, class:dialog"
        "float, class:download"
        "float, class:notification"
        "float, class:error"
        "float, class:splash"
        "float, class:confirmreset"
        "float, title:Open File"
        "float, title:branchdialog"
        "float, class:viewnior"
        "float, class:file-roller"

        "idleinhibit focus, class:mpv"
        "fullscreen, class:mpv"
        "noborder, class:mpv"
        "opaque, class:mpv"
        "nodim, class:mpv"

        "idleinhibit fullscreen, class:firefox"

        "float, title:^(Media viewer)$"
        "float, title:^(Volume Control)$"
        "float, title:^(Authentication Required)$"
        "float, title:^(Bluetooth Devices)$"
        "float, title:^(iwgtk)$"
        "float, title:^(dconf Editor)$"
        "float, class:zoom"

        "float, title:^(Picture in picture)$"
        "keepaspectratio, title:^(Picture in picture)$"
        "pin, title:^(Picture in picture)$"
        "noborder, title:^(Picture in picture)$"
        "nodim, title:^(Picture in picture)$"
        "opaque, title:^(Picture in picture)$"

        "float, title:^(Firefox — Sharing Indicator)$"

        "stayfocused, class:^(rofi)$"
        "xray 1, class:^(kitty$)"

        "bordersize 0, floating:0, onworkspace:w[tv1]"
        "rounding 0, floating:0, onworkspace:w[tv1]"
        "bordersize 0, floating:0, onworkspace:f[1]"
        "rounding 0, floating:0, onworkspace:f[1]"
      ];

      workspace = [
        "name:special:1,rounding:false,bordersize:0"
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];

      layerrule = [
        "blur, gtk-layer-shell"
        "blur, notifications"
        "ignorezero, notifications"
        "blur, rofi"
        "blur, waybar"
        "ignorezero, waybar"
        "ignorezero, rofi"
      ];

      "$mod" = "SUPER";

      bind = [
        # Special Workspace
        "$mod ALT, M, movetoworkspace, special:1"
        "$mod,T,togglespecialworkspace,1"
        "$mod,M,togglespecialworkspace,2"

        # Launching
        "$mod, B, exec, uwsm app firefox"
        "$mod, Return, exec, uwsm app kitty -1"
        "$mod ALT, T, exec, uwsm app kitty -1"

        # Screenshot
        ", Print, exec, grimblast --notify copy screen"
        "ALT, Print, exec, grimblast --notify copy active"
        "SHIFT, Print, exec, grimblast --notify --freeze copy area"
        "$mod, Print, exec, grimblast --notify copysave screen"
        "$mod ALT, Print, exec, grimblast --notify copysave active"
        "$mod SHIFT, Print, exec, grimblast --notify --freeze copysave area"

        # Tools
        "$mod SHIFT, C, exec, hyprpicker -a -n"
        "$mod, W, exec, pkill -USR1 waybar||waybar"
        "$mod SHIFT, W, exec, pkill -USR2 waybar"
        "$mod CTRL, L, exec, hyprlock"
        "$mod, D, exec, dunstctl set-paused toggle"

        # Launcher
        "$mod, SPACE, exec, pkill rofi||rofi -show drun"
        "$mod, R, exec, pkill rofi||rofi -show run -no-sidebar-mode"
        "$mod, S, exec, pkill rofi||rofi-systemd"
        "$mod ALT, B, exec, pkill rofi||rofi-bluetooth"
        "$mod, E, exec, pkill rofi||rofi -show filebrowser -modes filebrowser -no-sidebar-mode"
        "$mod, escape, exec, pkill rofi||rofi -show p -modes p:rofi-power-menu -no-sidebar-mode"
        "$mod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"

        # Anime
        "$mod, A, exec, ~/.local/bin/jerry --rofi -q 1080"
        "$mod SHIFT, A, exec, ~/.local/bin/jerry --rofi --dub -q 1080"
        "$mod ALT, A, exec, ani-cli --rofi --skip -q best"
        "$mod ALT SHIFT, A, exec, ani-cli --rofi --skip --dub -q best"

        # Windows
        "$mod, C, killactive"
        "$mod, Q, killactive"
        "$mod SHIFT, F, fullscreen"
        "$mod, F, togglefloating"
        "$mod, P, pseudo"
        "$mod, I, togglesplit"

        # Window Management
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        "$mod ALT, H, movewindow, l"
        "$mod ALT, L, movewindow, r"
        "$mod ALT, K, movewindow, u"
        "$mod ALT, J, movewindow, d"

        # Group
        "$mod, g, togglegroup"
        "$mod, tab, changegroupactive"

        "$mod CTRL, H, moveintogroup, l"
        "$mod CTRL, L, moveintogroup, r"
        "$mod CTRL, K, moveintogroup, u"
        "$mod CTRL, J, moveintogroup, d"

        # Workspaces
        "$mod, grave, workspace, +1"
        "$mod SHIFT, grave, workspace, -1"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod ALT, down, workspace, e+1"
        "$mod ALT, up, workspace, e-1"

        "$mod ALT, 1, movetoworkspace, 1"
        "$mod ALT, 2, movetoworkspace, 2"
        "$mod ALT, 3, movetoworkspace, 3"
        "$mod ALT, 4, movetoworkspace, 4"
        "$mod ALT, 5, movetoworkspace, 5"
        "$mod ALT, 6, movetoworkspace, 6"
        "$mod ALT, 7, movetoworkspace, 7"
        "$mod ALT, 8, movetoworkspace, 8"
        "$mod ALT, 9, movetoworkspace, 9"
        "$mod ALT, 0, movetoworkspace, 10"

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      binde = [
        # Resize Windows
        "$mod SHIFT, H, resizeactive, -20 0"
        "$mod SHIFT, L, resizeactive, 20 0"
        "$mod SHIFT, K, resizeactive, 0 -20"
        "$mod SHIFT, J, resizeactive, 0 20"

        # Bind brightness and audio control
        ", XF86MonBrightnessUp, exec, changeBrightness +5%"
        ", XF86MonBrightnessDown, exec, changeBrightness 5%-"
        ", XF86AudioRaiseVolume, exec, changeVolume 5%+"
        ", XF86AudioLowerVolume, exec, changeVolume 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };
      experimental.xx_color_management_v4 = true;
    };
  };
}
