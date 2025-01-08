{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = with inputs; [
    nur.modules.homeManager.default
    catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin = {
    flavor = "mocha";
    bat.enable = true;
    btop.enable = true;
    dunst.enable = true;
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    cacheHome = "${config.home.homeDirectory}/.local/cache";

    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config = {
        common.default = [ "gtk" ];
        hyprland.default = [
          "hyprland"
          "gtk"
        ];
      };
    };

    configFile = {
      "waybar/config.jsonc".source = ./config/waybar/config.jsonc;
      "sh/functions.sh".source = ./config/sh/functions.sh;

      "lf/icons".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/gokcehan/lf/refs/heads/master/etc/icons.example";
        hash = "sha256-c0orDQO4hedh+xaNrovC0geh5iq2K+e+PZIL5abxnIk=";
      };

      "qt5ct/colors/Catppuccin-Black.conf".source = ./config/qtct/Catppuccin-Black.conf;
      "qt6ct/colors/Catppuccin-Black.conf".source = ./config/qtct/Catppuccin-Black.conf;

      "gtk-4.0/assets".source =
        "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk-dark.css".source =
        "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";

      "npm/npmrc".source = ./config/npm/npmrc;
      "python/pythonrc".source = ./config/python/pythonrc.py;

      "nixos/config/nvim/.runtime".source = "${config.programs.neovim.finalPackage}/share/nvim/runtime";

      "nvim/lua".source = ./config/nvim/lua;
      "nvim/after".source = ./config/nvim/after;
    };
  };

  home = {
    username = "tarxz";
    homeDirectory = "/home/tarxz";
    packages = with pkgs; [
      # Hyprland
      hyprpicker
      swaybg
      grimblast # Screenshot
      iwgtk # System Control
      wl-clipboard # Clipboard
      brightnessctl # Brightness
      rofi-bluetooth # Bluetooth
      overskride
      rofi-power-menu

      # Audio
      pamixer
      qpwgraph
      pwvucontrol

      # Applications
      libreoffice-fresh
      syncplay

      # Games
      retroarch
      lutris
      (inputs.umu.packages.${pkgs.system}.umu.override { version = "${inputs.umu.shortRev}"; })
      ludusavi

      # CLI tools
      doas-sudo-shim
      hyperfine
      jq
      onefetch
      sops
      unzip
      zip
      ## Coreutil Replacements
      fd
      ## Downloaders
      ani-cli
      aria
      wget
      ## File Management
      file
      rmtrash
      trash-cli
      xdg-utils

      # Languages
      arduino-cli
      go
      ## JavaScript
      nodePackages_latest.nodejs
      bun
      ## Python
      python3

      # Misc
      bash-completion
      zsh-completions
      libnotify

      (writeShellScriptBin "changeVolume" ''
        #!/usr/bin/env bash
        # Arbitrary but unique message tag
        msgTag="myvolume"

        # Change the volume using alsa(might differ if you use pulseaudio)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "$@" >/dev/null

        # Query amixer for the current volume and whether or not the speaker is muted
        volume="$(pamixer --get-volume)"
        mute="$(pamixer --get-mute)"
        if [[ $volume == 0 || "$mute" == "off" ]]; then
          # Show the sound muted notification
          dunstify -a "changeVolume" -u low -i audio-volume-muted -h string:x-dunst-stack-tag:$msgTag "Volume muted"
        else
          # Show the volume notification
          dunstify -a "changeVolume" -u low -i audio-volume-high -h string:x-dunst-stack-tag:$msgTag \
            -h int:value:"$volume" "Volume: ''${volume}%"
        fi

        # Play the volume changed sound
        canberra-gtk-play -i audio-volume-change -d "changeVolume"
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
        dunstify -a "changeBrightness" -u low -i brightnesssettings -h string:x-dunst-stack-tag:$msgTag \
        -h int:value:"$brightness" "Brightness: ''${brightness}%"

        # Play the brightness changed sound
        canberra-gtk-play -i brightness-change -d "changeBrightness"
      '')
    ];

    sessionVariables = {
      FLAKE = "${config.xdg.configHome}/nixos";

      BROWSER = "librewolf";
      SUDO_EDITOR = "nvim";
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less";

      NIXOS_OZONE_WL = "1";

      KDEHOME = "${config.xdg.configHome}/kde";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
      GOPATH = "${config.xdg.dataHome}/go";
      HISTFILE = "${config.xdg.stateHome}/bash/history";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      WINEPREFIX = "${config.xdg.dataHome}/wine";
      NODE_REPL_HISTORY = "${config.xdg.dataHome}/node_repl_history";
      NVM_DIR = "${config.xdg.dataHome}/nvm";
      ANDROID_HOME = "${config.xdg.dataHome}/android";
      PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonrc";
      PARALLEL_HOME = "${config.xdg.configHome}/parallel";
      GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}}/java -djavafx.cachedir=${config.xdg.cacheHome}/openjfx";
    };

    shellAliases = {
      jctl = "journalctl -b";
      sysfailed = "systemctl list-units --failed";
      ssn = "shutdown now";
      rb = "reboot";

      sudo = "sudo ";
      doas = "doas ";
      ds = "doas ";
      su = "doas -s";
      sudoedit = "doasedit";
      de = "doasedit";
      wget = "wget -c --hsts-file='${config.xdg.dataHome}/wget-hsts'";
      adb = "HOME=${config.xdg.dataHome}/android adb";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
      rm = "rmtrash -v";
      rmdir = "rmdirtrash -v --ignore-fail-on-non-empty";

      v = "nvim";
      em = "/usr/bin/emacs -nw";
      hx = "helix";
      l = "ls";
      a = "ll";
      cp = "cp -i";
      mv = "mv -i";
      diff = "delta";
      cd = "z";
      getenv = "printenv|rg -i";
      clear = "clear -T xterm";
      cls = "clear -T xterm";
      cl = "clear -T xterm";
      c = "clear -T xterm";
      db = "dotbare";
      cat = "bat";
      nohup = "command rm nohup.out;nohup";

      update = "nix flake update --flake ${config.home.sessionVariables.FLAKE} --commit-lock-file; nh os boot";
      switch = "nh os switch";
      fast = "sudo nixos-rebuild test --fast --flake ${config.home.sessionVariables.FLAKE}";
    };
    sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

    file = {
      ".mozilla/firefox/main/chrome/csshacks".source = inputs.csshacks;
      ".mozilla/firefox/main/chrome/includes".source = ./config/firefox/chrome/includes;
      ".icons/default/index.theme".enable = false;
      ".icons/${config.home.pointerCursor.name}".enable = false;
    };

    pointerCursor = {
      gtk.enable = true;
      x11.enable = false;
      size = 24;
      name = "Nero";
      hyprcursor = {
        enable = true;
        size = 24;
      };
      package = pkgs.runCommand "Nero" { } ''
        mkdir -p $out/share/icons
        ln -s ${inputs.nero} $out/share/icons/Nero'';
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.package = with pkgs; [
      libsForQt5.lightly
      kdePackages.breeze
    ];
  };

  gtk = {
    enable = true;
    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    };

    theme = {
      name = "catppuccin-mocha-mauve-compact+black";
      package = (
        pkgs.catppuccin-gtk.override {
          accents = [ "mauve" ];
          size = "compact";
          tweaks = [ "black" ];
          variant = "mocha";
        }
      );
    };
    font.name = "Noto Sans";
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  wayland.windowManager.hyprland =
    let
      vars = builtins.mapAttrs (
        name: value: name + "," + builtins.toString value
      ) config.home.sessionVariables;
    in
    {
      enable = true;
      xwayland.enable = true;
      settings = {
        env = map (key: builtins.getAttr key vars) (builtins.attrNames vars);

        exec-once = [
          "swaybg -i ~/Pictures/Wallpaper/the_neon_shallows_by_leikoi_ddm6tx0.png -m fill &"
          "[workspace special:1 silent] kitty -1"
        ];

        monitor = ",highres,auto,1.25,bitdepth,10";

        input = {
          kb_layout = "us";
          kb_options = "caps:escape";
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
        gestures = {
          workspace_swipe = true;
          workspace_swipe_create_new = true;
          workspace_swipe_forever = false;
        };

        general = {
          gaps_in = 0;
          gaps_out = 0;
          border_size = 2;
          "col.active_border" = "rgb(cba6f7)";
          "col.inactive_border" = "rgba(00000000)";
          layout = "dwindle";
          no_border_on_floating = false;
          allow_tearing = true;
        };

        group = {
          "col.border_active" = "rgb(cba6f7)";
          "col.border_inactive" = "rgba(00000000)";
          groupbar = {
            gradients = true;
            "col.inactive" = "rgba(00000000)";
            "col.active" = "rgb(cba6f7)";
          };
        };
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
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
          enabled = true;
          first_launch_animation = false;
          # bezier = overshot, 0.05, 0.9, 0.1, 1.05;
          # bezier = smoothOut, 0.36, 0, 0.66, -0.56;
          # bezier = smoothIn, 0.25, 1, 0.5, 1;
          # bezier = linear, 0.45, 0, 0.55, 1;

          # animation = borderangle, 1, 100, linear, loop;
          # animation = windows, 1, 5, overshot, slide;
          # animation = windowsOut, 1, 4, smoothOut, slide;
          # animation = windowsMove, 1, 4, default;
          # animation = border, 1, 10, default;
          # animation = fade, 1, 10, smoothIn;
          # animation = fadeDim, 1, 10, smoothIn;
          # animation = workspaces, 1, 6, default;
        };

        dwindle = {
          pseudotile = true;
          preserve_split = false;
        };

        master.mfact = 0.5;

        opengl.nvidia_anti_flicker = false;

        windowrule = [
          "float, file_progress"
          "float, confirm"
          "float, dialog"
          "float, download"
          "float, notification"
          "float, error"
          "float, splash"
          "float, confirmreset"
          "float, title:Open File"
          "float, title:branchdialog"
          "float, viewnior"
          "float, file-roller"

          "idleinhibit focus, mpv"
          "fullscreen, mpv"
          "noborder, mpv"
          "opaque, mpv"
          "nodim, mpv"

          "idleinhibit fullscreen, librewolf"

          "float, title:^(Media viewer)$"
          "float, title:^(Volume Control)$"
          "float, title:^(Authentication Required)$"
          "float, title:^(Bluetooth Devices)$"
          "float, title:^(iwgtk)$"
          "float, title:^(dconf Editor)$"
          "float, zoom"

          "float, title:^(Picture-in-Picture)$"
          "keepaspectratio, title:^(Picture-in-Picture)$"
          "pin, title:^(Picture-in-Picture)$"
          "noborder, title:^(Picture-in-Picture)$"
          "nodim, title:^(Picture-in-Picture)$"
          "opaque, title:^(Picture-in-Picture)$"

          "float, title:^(LibreWolf — Sharing Indicator)$"
          "float, title:^(FireDragon — Sharing Indicator)$"
          "float, title:^(Firefox — Sharing Indicator)$"

          "stayfocused, ^(rofi)$"
          "xray 1, ^(kitty$)"
          "xray 1, ^(Alacritty$)"
        ];

        windowrulev2 = [
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
          "$mod, B, exec, librewolf"
          "$mod, Return, exec, kitty -1"
          "$mod ALT, T, exec, kitty -1"

          # Screenshot
          ", Print, exec, grimblast --notify copy screen"
          "ALT, Print, exec, grimblast --notify copy active"
          "SHIFT, Print, exec, grimblast --notify --freeze --cursor copy area"
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
          ", XF86AudioMute, exec, pamixer --toggle-mute"
        ];

        # Mouse
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };

  programs = {
    home-manager.enable = true;
    mangohud.enable = true;

    firefox = {
      enable = true;
      package = pkgs.librewolf; # link ~/.mozilla/firefox and ~/.librewolf for this to work
      profiles = {
        main = {
          extraConfig = ''
            ${builtins.readFile "${inputs.betterfox}/user.js"}
            ${builtins.readFile ./config/firefox/user.js}
          '';

          userChrome = builtins.readFile ./config/firefox/chrome/userChrome.css;
          userContent = builtins.readFile ./config/firefox/chrome/userContent.css;

          extensions = with inputs.nur.legacyPackages.${pkgs.system}.repos.rycee.firefox-addons; [
            ublock-origin
            libredirect
            proton-pass
            tree-style-tab
            darkreader
            tridactyl
            nighttab

            redirector
            violentmonkey
            user-agent-string-switcher
          ];
        };
        test.id = 1;
      };
    };

    mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
        autodeint
        mpris
        sponsorblock
      ];
      config = {
        hwdec = "vaapi,auto-safe";
        vo = "gpu,auto";
        ao = "pipewire,";
        gpu-context = "wayland";
        deband = true;
        audio-spdif = [
          "ac3"
          "eac3"
          "dts-hd"
          "truehd"
        ];
        sub-font = "monospace";
        cache = true;
        speed = 2;
        volume-max = 100;
        hls-bitrate = "max";

        cursor-autohide = 200;
        cursor-autohide-fs-only = true;
        msg-color = true;
        msg-module = true;
        term-osd-bar = true;
      };
      scriptOpts.ytdl_hook.try_ytdl_first = true;
    };
    yt-dlp = {
      enable = true;
      settings = {
        downloader = "aria2c";
        downloader-args = "'-c -j 6 -x 6 -s 6 -k 1M'";
      };
    };

    waybar = {
      enable = true;
      systemd.enable = true;
      style = ./config/waybar/style.css;
    };
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins = with pkgs; [
        rofi-calc
        rofi-power-menu
      ];

      cycle = true;
      font = "monospace 12";
      theme = ./config/rofi/theme.rasi;
      extraConfig = {
        modes = "drun,window";
        fixed-num-lines = false;
        show-icons = true;
        terminal = "kitty";
        run-shell-command = "{terminal} -e bash -c {cmd}";
        drun-url-launcher = "xdg-open";
        disable-history = false;
        case-sensitive = false;
        sidebar-mode = true;
        matching = "fuzzy";
        sort = true;
        sorting-method = "fzf";
        scroll-method = 1;
        window-format = "{w} {c} : {t}";
        display-drun = " 󰣆  Apps ";
        display-run = "   Run ";
        display-window = " 󰕰  Window";
        display-filebrowser = "   Files";
        display-calc = " 󰪚  Calc";
        steal-focus = true;
      };
    };
    hyprlock = {
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

    git = {
      enable = true;
      userName = "tarzst";
      userEmail = "git.3myp3@slmail.me";
      signing = {
        key = "DA1AE234F1953A10F6078E9B9E604C53FBEFE1D9";
        signByDefault = true;
      };
      aliases = {
        lg = "log --graph";
        history = "log -p";
      };
      extraConfig = {
        log = {
          decorate = true;
          initialDecorationSet = "all";
          date = "human";
        };

        init.dafaultBranch = "master";
        merge.conflictstyle = "diff3";

        diff = {
          tool = "vimdiff";
          colorMoved = "default";
        };
        difftool.prompt = false;
      };
      delta = {
        enable = true;
        options = {
          navigate = true;
          features = "decorations";
          true-color = "always";
          decorations = {
            file-style = "omit";
            hunk-header-style = "file line-number syntax";
            hunk-header-line-number-style = "yellow";
            syntax-theme = config.programs.bat.config.theme;
            blame-palette = "#1e1e2e #181825 #11111b #313244 #45475a";
            dark = true;
            file-decoration-style = "#cdd6f4";
            # hunk-header-file-style = "bold";
            line-numbers = true;
            line-numbers-left-style = "#6c7086";
            line-numbers-minus-style = "bold #f38ba8";
            line-numbers-plus-style = "bold #a6e3a1";
            line-numbers-right-style = "#6c7086";
            line-numbers-zero-style = "#6c7086";
            # 40% red 60% base
            minus-emph-style = "syntax #613743";
            # 20% red 80% base
            minus-style = "syntax #301b21";
            # 40% green 60% base
            plus-emph-style = "syntax #425a40";
            # 20% green 80% base
            plus-style = "syntax #212d20";
          };
        };
      };
    };
    ssh = {
      enable = true;
      package = pkgs.openssh_hpn;
      controlMaster = "auto";
      controlPersist = "yes";
      extraConfig = "Ciphers aes128-gcm@openssh.com,aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr";
    };
    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    kitty = {
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

        shell = "${pkgs.zsh}/bin/zsh";

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
        font_features CascadiaCode +ss20 +ss02
        font_features CascadiaCode-Bold +ss20 +ss02
        font_features CascadiaCode-Italic +ss20 +ss02
        font_features CascadiaCode-BoldItalic +ss20 +ss02

        font_features FiraCodeNF-Reg +ss09 +cv25 +cv26 +cv32 +cv27 +cv28 +ss06 +ss07

        font_features Iosevka-Term-Extended +dlig +MTLB VLAD=2 VLAC=2
        font_features Iosevka-Term-Bold-Extended +dlig +MTLB
        font_features Iosevka-Term-Extended-Italic +dlig +MTLB
        font_features Iosevka-Term-Bold-Extended-Italic +dlig  +MTLB
      '';
    };

    neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      vimdiffAlias = true;

      withPython3 = false;
      withRuby = false;

      plugins = with pkgs.vimPlugins; [ lazy-nvim ];

      extraLuaConfig =
        with pkgs.vimPlugins; # lua
        ''
          P = {
            -- init.lua
            catppuccin = "${catppuccin-nvim}",
            snacks = "${snacks-nvim}",
            dial = "${dial-nvim}",
            marks = "${marks-nvim}",

            -- bars.lua
            dropbar = "${dropbar-nvim}",
            heirline = "${heirline-nvim}",
            mini_icons = "${mini-icons}",

            -- cmp.lua
            friendly_snippets = "${friendly-snippets}",
            blink = "${blink-cmp}",

            -- lsp.lua
            lspconfig = "${nvim-lspconfig}",
            lint = "${nvim-lint}",
            conform = "${conform-nvim}",
            trouble = "${trouble-nvim}",

            -- mini.lua
            mini_move = "${mini-move}",
            mini_surround = "${mini-surround}",
            mini_ai = "${mini-ai}",
            mini_bracketed = "${mini-bracketed}",

            -- move.lua
            flash = "${flash-nvim}",
            spider = "${nvim-spider}",
            texobjs = "${nvim-various-textobjs}",

            -- ts.lua
            treesitter = "${nvim-treesitter}",
              treesitter_textobjects = "${nvim-treesitter-textobjects}",
              treesitter_context = "${nvim-treesitter-context}",
              ts_context_commentstring = "${nvim-ts-context-commentstring}",
              rainbow_delimiters = "${rainbow-delimiters-nvim}",
              ts_autotag = "${nvim-ts-autotag}",
              matchup = "${vim-matchup}",

            headlines = "${headlines-nvim}",
            treesj = "${treesj}",

            -- ui.lua
            which_key = "${which-key-nvim}",

            noice = "${noice-nvim}",
              nui = "${nui-nvim}",
            mini_files = "${mini-files}",
            fzf = "${fzf-lua}",

            gitsigns = "${gitsigns-nvim}",
            colorizer = "${nvim-colorizer-lua}",
          }
          require("startup")
          vim.opt.rtp:append("${
            pkgs.symlinkJoin {
              name = "treesitter";
              paths =
                (nvim-treesitter.withPlugins (
                  p: with p; [
                    # c, lua, markdown, query, vim, vimdoc installed by default
                    arduino
                    bash
                    css
                    git_config
                    git_rebase
                    gitattributes
                    gitcommit
                    gitignore
                    go
                    html
                    java
                    javascript
                    jsdoc
                    json
                    json5
                    jsonc
                    luap
                    markdown
                    markdown_inline
                    nix
                    norg
                    python
                    regex
                    rust
                    svelte
                    toml
                    typescript
                    udev
                    vim
                    vimdoc
                    vue
                    yaml
                    xml
                  ]
                )).dependencies;
            }
          }")
        '';

      extraPackages = with pkgs; [
        # lazy.nvim deps
        luarocks
        lua51Packages.lua
        # Formatter, LSP, Linters
        codespell
        vscode-langservers-extracted
        ## TOML
        taplo
        ## Arduino
        arduino-language-server
        astyle
        ## Nix
        nixd
        nixfmt-rfc-style
        ## Shell
        shfmt
        shellcheck
        ## Lua
        lua-language-server
        stylua
        ## JavaScript
        biome
        vtsls
        ## Tailwind
        tailwindcss-language-server
        rustywind
        ## Go
        gopls
        gofumpt
        ## Python
        ruff
        pyright
      ];
    };

    zsh = {
      enable = true;
      dotDir = ".config/zsh";

      enableCompletion = true;
      completionInit = "autoload -Uz compinit && compinit -i -u -C -d $XDG_CACHE_HOME/zsh/zcompdump";
      defaultKeymap = "emacs";
      autocd = true;

      history = {
        path = "${config.xdg.stateHome}/zsh/history";
        size = 100000;
        save = 100000;
        ignoreAllDups = true;
      };

      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
        ];
        styles = {
          path = "fg=magenta,underline";
          single-hyphen-option = "fg=cyan";
          double-hyphen-option = "fg=cyan";
        };
      };

      historySubstringSearch.enable = true;

      envExtra = # sh
        ''
          export LS_COLORS="$(${pkgs.vivid}/bin/vivid generate catppuccin-mocha)"

          export MANROFFOPT="-c"
          export MANPAGER="/bin/sh -c 'col -bx | ${pkgs.bat}/bin/bat --language=help --color=always -p'"
        '';

      initExtraFirst = "${config.programs.fastfetch.package}/bin/fastfetch";

      initExtraBeforeCompInit = # sh
        ''
          zstyle ':completion:*' auto-description '+%d'
          zstyle ':completion:*' completer _oldlist _expand _expand_alias _complete _ignored _correct _approximate _prefix
          zstyle ':completion:*' file-sort name
          # zstyle ':completion:*' group-name ""
          zstyle ':completion:*' ignore-parents parent pwd
          zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
          zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
          zstyle ':completion:*' matcher-list "" 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**' '+l:|=* r:|=*'
          zstyle ':completion:*' menu select
          zstyle ':completion:*' original true
          zstyle ':completion:*' preserve-prefix '//[^/]##/'
          zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
          zstyle ':completion:*' verbose true
          zstyle ':completion:*:descriptions' format '%U%F{cyan}%d%f%u'
          zstyle ':completion:*:warnings' format 'No matches for: %d'
          zstyle ':completion:*' format ' %d'

          zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
          zstyle ':completion:*' rehash true                              # automatically find new executables in path

          zmodload zsh/complist
          zmodload zsh/zpty
          _comp_options+=(globdots)

          # Speed up completions
          zstyle ':completion:*' accept-exact '*(N)'
          zstyle ':completion:*' use-cache on
          zstyle ':completion:*' cache-path ~/.local/cache/zsh
        '';

      initExtra = # sh
        ''
          source ~/.config/sh/functions.sh
          zle -N lfcd

          ctrlz() {
            if [[ $#BUFFER -eq 0 ]]; then
              BUFFER="fg"
              zle accept-line
            else
              zle push-input
              zle clear-screen
            fi
          }
          zle -N ctrlz

          ## Options section
          setopt correct                                                  # Auto correct mistakes
          setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
          setopt nocaseglob                                               # Case insensitive globbing
          setopt rcexpandparam                                            # Array expansion with parameters
          setopt nocheckjobs                                              # Don't warn about running processes when exiting
          setopt numericglobsort                                          # Sort filenames numerically when it makes sense
          setopt nobeep                                                   # No beep
          setopt appendhistory                                            # Immediately append history instead of overwriting
          setopt auto_pushd
          setopt pushd_ignore_dups
          setopt pushdminus
          setopt globdots
          setopt interactive_comments

          bindkey '^Z' ctrlz
          bindkey '^O' lfcd
          bindkey  "^[[H"   beginning-of-line
          bindkey  "^[[F"   end-of-line
          bindkey  "^[[3~"  delete-char

          autoload -U colors && colors # Load colors
        '';
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings =
        pkgs.lib.attrsets.recursiveUpdate
          (builtins.fromTOML (
            builtins.readFile "${config.programs.starship.package}/share/starship/presets/nerd-font-symbols.toml"
          ))
          {
            add_newline = false;
            format = "$os$directory$git_commit$git_branch$git_metrics$git_status$character";
            right_format = "$all";
            continuation_prompt = "[▸▹ ](bright-black)";

            os.disabled = false;

            directory = {
              fish_style_pwd_dir_length = 1;
              format = "[ $path]($style)[$read_only]($read_only_style) ";
              style = "blue";
              # truncation_length = 8;
              # truncation_symbol = "…/";
            };

            git_branch.format = "[$symbol$branch(:$remote_branch)]($style) ";
            git_metrics.disabled = true;
            git_status = {
              style = "yellow";

              ahead = " ⇡\${count}";
              behind = " ⇣\${count}";
              conflicted = " =\${count}";
              deleted = " ✘\${count}";
              diverged = " ⇕⇡\${ahead_count}⇣\${behind_count}";
              modified = " !\${count}";
              renamed = " »\${count}";
              staged = " +\${count}";
              stashed = " *\${count}";
              untracked = " ?\${count}";
            };

            cmd_duration = {
              format = "[ $duration]($style) ";
              min_time = 0;
              show_milliseconds = true;
            };

            status.disabled = false;
          };
    };

    eza = {
      enable = true;
      extraOptions = [
        "-a"
        "--group-directories-first"
        "--icons=auto"
        "--smart-group"
        "--git"
        "--git-repos"
        "--git-ignore"
      ];
    };
    bat = {
      enable = true;
      config = {
        style = "changes,header-filename,rule,numbers,snip";
        pager = config.home.sessionVariables.PAGER;

        map-syntax = [
          "*.ino:C++"
          "*.ignore:Git Ignore"
          "*.rasi:CSS"
          "*.jsonc:JSON"
          "*.norg:orgmode"
        ];
      };
      extraPackages = with pkgs.bat-extras; [
        batwatch
        batpipe
      ];
    };
    pistol = {
      enable = true;
      associations = [
        {
          mime = "text/*";
          command = "${pkgs.bat}/bin/bat --color=always %pistol-filename%";
        }
        {
          mime = "inode/directory";
          command = "${config.programs.zsh.shellAliases.lla} --color=always --icons=always %pistol-filename%"; # Uses alias made by eza
        }
      ];
    };
    less = {
      enable = true;
      keys = ''
        #env
        LESS = --RAW-CONTROL-CHARS --quit-if-one-screen --mouse --ignore-case --LONG-PROMPT --quit-on-intr --tilde
        LESSUTFCHARDEF = E000-F8FF:p,F0000-FFFFD:p
        LESSHISTFILE = ${config.xdg.cacheHome}/less/history
      '';
    };
    fd = {
      enable = true;
      ignores = [
        "Games"
        "Public/cfg"
        "*Cache*"
        "*cache*"
        "Templates"
        "node_modules"
        "nix/store"
      ];
    };
    fzf = {
      enable = true;
      defaultCommand = "fd --type file -LH --color=always --max-depth=3";
      defaultOptions = [
        "--inline-info"
        "--ansi"
        "--cycle"
        "--multi"
        "--height ~100%"
        "--border"
        "--preview 'pistol {}'"
        "--bind='alt-/:toggle-preview'"
        "--bind='ctrl-u:preview-page-up'"
        "--bind='ctrl-d:preview-page-down'"
        "--preview-window 'right,border-left,<60(down,border)'"
        "--bind 'ctrl-r:reload(${config.programs.fzf.defaultCommand})'"
      ];
      colors = {
        "bg+" = "#313244";
        "fg+" = "#cdd6f4";
        "hl+" = "#f38ba8";
        fg = "#cdd6f4";
        header = "#f38ba8";
        hl = "#f38ba8";
        info = "#cba6f7";
        marker = "#f5e0dc";
        pointer = "#f5e0dc";
        prompt = "#cba6f7";
        spinner = "#f5e0dc";
      };

      changeDirWidgetCommand = "fd --type d -LH --color=always --max-depth=3";
      fileWidgetCommand = "fd --type f -LH --color=always --max-depth=3";
      enableZshIntegration = true;
    };
    ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--follow"
        "--pretty"
      ];
    };
    tealdeer = {
      enable = true;
      settings = {
        display.compact = true;
        style = {
          command_name.foreground = "green";
          example_text.foreground = "yellow";
          example_code.foreground = "cyan";
          example_variable = {
            foreground = "magenta";
            underline = true;
          };
        };
        updates.auto_update = true;
      };
    };

    lazygit = {
      enable = true;
      settings = {
        git.paging.pager = "delta --dark --paging=never";
        gui = {
          showIcons = true;
          nerdFontsVersion = "3";
          theme = {
            activeBorderColor = [
              "#cba6f7"
              "bold"
            ];
            inactiveBorderColor = [ "#a6adc8" ];
            optionsTextColor = [ "#89b4fa" ];
            selectedLineBgColor = [ "#313244" ];
            cherryPickedCommitBgColor = [ "#45475a" ];
            cherryPickedCommitFgColor = [ "#cba6f7" ];
            unstagedChangesColor = [ "#f38ba8" ];
            defaultFgColor = [ "#cdd6f4" ];
            searchingActiveBorderColor = [ "#f9e2af" ];
          };
        };
      };
    };

    lf = {
      enable = true;
      previewer.source = pkgs.writeShellScript "pv.sh" ''
        file=$1
        w=$2
        h=$3
        x=$4
        y=$5

        if [[ "$( file -Lb --mime-type "$file")" =~ ^image ]]; then
          ${pkgs.kitty}/bin/kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
          exit 1
        fi

        ${pkgs.bat}/bin/bat --color=always "$file"
      '';
      settings = {
        icons = true;
        hidden = true;
        number = true;
        relativenumber = true;
        info = "size";
        cursorpreviewfmt = "";
        scrolloff = 999;
        cleaner = "${pkgs.writeShellScript "cl.sh" "${pkgs.kitty}/bin/kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty"}";
      };
    };
    fastfetch = {
      enable = true;
      settings = {
        display = {
          size.binaryPrefix = "si";
          hideCursor = true;
          percent = {
            type = 3;
          };
          separator = " ➜ ";
        };
        modules = [
          "title"
          "separator"
          /*
            {
              format = "\u001b[30m● \u001b[31m● \u001b[32m● \u001b[33m● \u001b[34m● \u001b[35m● \u001b[36m● \u001b[37m●    \u001b[97m● \u001b[96m● \u001b[95m● \u001b[94m● \u001b[93m● \u001b[92m● \u001b[91m● \u001b[90m●";
              type = "custom";
            } \ escaping does not work
          */
          {
            key = "";
            keyColor = "cyan";
            text = "grep ^VERSION= /etc/os-release|cut -d'\"' -f2";
            type = "command";
          }
          {
            key = "󰻀";
            keyColor = "light_yellow";
            type = "kernel";
          }
          {
            key = "󰥔";
            keyColor = "blue";
            type = "uptime";
          }
          {
            key = "󰏖";
            keyColor = "red";
            type = "packages";
          }
          "break"
          {
            key = "󱆃";
            keyColor = "magenta";
            type = "shell";
          }
          {
            key = "";
            keyColor = "yellow";
            type = "terminal";
          }
          {
            key = "";
            keyColor = "light_green";
            type = "wm";
          }
          "break"
          {
            key = "󰻠";
            keyColor = "light_cyan";
            type = "cpu";
          }
          {
            key = "󰘚";
            keyColor = "light_red";
            type = "gpu";
          }
          {
            key = "󰍛";
            keyColor = "light_magenta";
            type = "memory";
          }
          {
            key = "󰋊";
            keyColor = "light_blue";
            type = "disk";
          }
          {
            key = "󰁹";
            keyColor = "green";
            type = "battery";
          }
          "break"
          {
            type = "colors";
            symbol = "triangle";
          }
        ];
      };
    };
    btop = {
      enable = true;
      settings = {
        theme_background = false;
        update_ms = 100;
        base_10_sizes = true;

        proc_gradient = false;
        proc_left = true;
        proc_per_core = true;
        proc_filter_kernel = true;

        cpu_graph_upper = "user";
        cpu_graph_lower = "system";

        net_sync = false;
        net_auto = false;
        net_download = 96;
        net_upload = 8;
      };
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  services = {
    udiskie.enable = true;
    cliphist.enable = true;
    playerctld.enable = true;

    hypridle = {
      enable = true;
      settings = {
        general.before_sleep_cmd = "${pkgs.procps}/bin/pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        listener = [
          {
            timeout = 60;
            on-timeout = "${pkgs.procps}/bin/pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
          }
          {
            timeout = 60;
            on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
          }
        ];
      };
    };

    dunst = {
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

          dmenu = "${config.programs.rofi.finalPackage}/bin/rofi -dmenu -p dunst:";
          browser = "${config.programs.firefox.finalPackage}/bin/librewolf --new-tab";

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
  };

  systemd.user = {
    startServices = true;
    services.waybar.Unit.ConditionEnvironment = "WAYLAND_DISPLAY";
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/var/lib/age.txt";

    secrets.ssh.path = "/home/tarxz/.ssh/id_ed25519";
  };

  home.stateVersion = "23.11";
}
