{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = with inputs; [ nur.nixosModules.nur ];

  xdg = {
    cacheHome = "${config.home.homeDirectory}/.local/cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

    configFile = {
      "waybar/config.jsonc".source = ./config/waybar/config.jsonc;

      "bat/themes/Catppuccin-mocha.tmTheme".source = ./config/bat/Catppuccin-mocha.tmTheme;
      "btop/themes/catppuccin_mocha.theme".source = ./config/btop/catppuccin_mocha.theme;

      "qt5ct/colors/Catppuccin-Black.conf".source = ./config/qtct/Catppuccin-Black.conf;
      "qt6ct/colors/Catppuccin-Black.conf".source = ./config/qtct/Catppuccin-Black.conf;

      "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";

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
      pavucontrol

      # Applications
      libreoffice-fresh
      retroarch
      lutris
      ludusavi
      wineWowPackages.waylandFull

      # CLI tools
      btop
      doas-sudo-shim
      hyperfine
      jq
      onefetch
      sops
      unzip
      vivid
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
      libnotify
      topgrade
    ];

    sessionVariables = {
      XDG_DATA_HOME = config.xdg.dataHome;
      XDG_CONFIG_HOME = config.xdg.configHome;
      XDG_STATE_HOME = config.xdg.stateHome;
      XDG_CACHE_HOME = config.xdg.cacheHome;
      FLAKE = "${config.xdg.configHome}/nixos";

      BROWSER = "librewolf";
      SUDO_EDITOR = "nvim";
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse --ignore-case --LONG-PROMPT --quit-on-intr --tilde";
      LESSUTFCHARDEF = "E000-F8FF:p,F0000-FFFFD:p";

      NIXOS_OZONE_WL = "1";

      KDEHOME = "${config.xdg.configHome}/kde";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
      GOPATH = "${config.xdg.dataHome}/go";
      LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
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
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}}/java - djavafx.cachedir=${config.xdg.cacheHome}/openjfx";
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
      less = config.home.sessionVariables.PAGER;

      update = "nix flake update --flake ${config.home.sessionVariables.FLAKE} --commit-lock-file; nh os boot";
      switch = "nh os switch";
      fast = "sudo nixos-rebuild test --fast --flake ${config.home.sessionVariables.FLAKE}";
    };
    sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

    file = {
      ".mozilla/firefox/main/chrome/csshacks".source = inputs.csshacks;
      ".mozilla/firefox/main/chrome/includes".source = ./config/firefox/chrome/includes;
    };

    pointerCursor = {
      gtk.enable = true;
      x11.enable = false;
      size = 24;
      name = "Nero";
      package = pkgs.runCommand "Nero" { } ''
        mkdir -p $out/share/icons
        ln -s ${inputs.nero} $out/share/icons/Nero'';
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.package = pkgs.libsForQt5.lightly;
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
        name: value: name + "," + builtins.toString (value)
      ) config.home.sessionVariables;
    in
    {
      enable = true;
      xwayland.enable = true;
      settings = {
        env = (map (key: builtins.getAttr key vars) (builtins.attrNames vars));

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
          enable_swallow = true;
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

          drop_shadow = false;
        };

        xwayland = {
          force_zero_scaling = true;
        };

        animations = {
          enabled = true;
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
          no_gaps_when_only = 1;
          pseudotile = true;
          preserve_split = false;
        };

        master = {
          no_gaps_when_only = 1;
          mfact = 0.5;
        };

        opengl = {
          nvidia_anti_flicker = false;
        };

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

        workspace = "name:special:1,rounding:false,bordersize:0";

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
          ", XF86MonBrightnessUp, exec, ~/.local/bin/changeBrightness +5%"
          ", XF86MonBrightnessDown, exec, ~/.local/bin/changeBrightness 5%-"
          ", XF86AudioRaiseVolume, exec, ~/.local/bin/changeVolume 5%+"
          ", XF86AudioLowerVolume, exec, ~/.local/bin/changeVolume 5%-"
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

          extensions = with config.nur.repos.rycee.firefox-addons; [
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
          font = "monospace";
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
              position = "0, 0";
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
            syntax-theme = "Catppuccin-mocha";
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
        copy_on_slect = false;
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

      extraLuaConfig = # lua
        ''
          P = {
            -- init.lua
            catppuccin = "${pkgs.vimPlugins.catppuccin-nvim}",
            bufdelete = "${pkgs.vimPlugins.bufdelete-nvim}",
            smart_splits = "${pkgs.vimPlugins.smart-splits-nvim}",
            dial = "${pkgs.vimPlugins.dial-nvim}",
            marks = "${pkgs.vimPlugins.marks-nvim}",

            -- bars.lua
            dropbar = "${pkgs.vimPlugins.dropbar-nvim}",
            heirline = "${pkgs.vimPlugins.heirline-nvim}",
              web_devicons = "${pkgs.vimPlugins.nvim-web-devicons}",

            -- cmp.lua
            luasnip = "${pkgs.vimPlugins.luasnip}",
              friendly_snippets = "${pkgs.vimPlugins.friendly-snippets}",
            cmp = "${pkgs.vimPlugins.nvim-cmp}",
              cmp_lsp = "${pkgs.vimPlugins.cmp-nvim-lsp}",
              cmp_luasnip = "${pkgs.vimPlugins.cmp_luasnip}",
              cmp_lua = "${pkgs.vimPlugins.cmp-nvim-lua}",
              cmp_cmdline = "${pkgs.vimPlugins.cmp-cmdline}",
              cmp_cmdline_history = "${pkgs.vimPlugins.cmp-cmdline-history}",
              cmp_buffer = "${pkgs.vimPlugins.cmp-buffer}",
              cmp_async_path = "${pkgs.vimPlugins.cmp-async-path}",
              cmp_treesitter = "${pkgs.vimPlugins.cmp-treesitter}",
              lspkind = "${pkgs.vimPlugins.lspkind-nvim}",

            -- lsp.lua
            SchemaStore = "${pkgs.vimPlugins.SchemaStore-nvim}",
            lspconfig = "${pkgs.vimPlugins.nvim-lspconfig}",
            lint = "${pkgs.vimPlugins.nvim-lint}",
            conform = "${pkgs.vimPlugins.conform-nvim}",
            trouble = "${pkgs.vimPlugins.trouble-nvim}",
            aerial = "${pkgs.vimPlugins.aerial-nvim}",

            -- mini.lua 
            -- TODO: use mini.nvim instead of separate plugins

            -- move.lua
            flash = "${pkgs.vimPlugins.flash-nvim}",
            spider = "${pkgs.vimPlugins.nvim-spider}",

            -- ts.lua
            treesitter = "${pkgs.vimPlugins.nvim-treesitter}",
              treesitter_textobjects = "${pkgs.vimPlugins.nvim-treesitter-textobjects}",
              treesitter_context = "${pkgs.vimPlugins.nvim-treesitter-context}",
              ts_context_commentstring = "${pkgs.vimPlugins.nvim-ts-context-commentstring}",
              rainbow_delimiters = "${pkgs.vimPlugins.rainbow-delimiters-nvim}",
              ts_autotag = "${pkgs.vimPlugins.nvim-ts-autotag}",
              matchup = "${pkgs.vimPlugins.vim-matchup}",
              treesitter_endwise = "${pkgs.vimPlugins.nvim-treesitter-endwise}",

            headlines = "${pkgs.vimPlugins.headlines-nvim}",
            treesj = "${pkgs.vimPlugins.treesj}",

            -- ui.lua
            -- alpha = "${pkgs.vimPlugins.alpha-nvim}",
            which_key = "${pkgs.vimPlugins.which-key-nvim}",

            noice = "${pkgs.vimPlugins.noice-nvim}",
              nui = "${pkgs.vimPlugins.nui-nvim}",
            fidget = "${pkgs.vimPlugins.fidget-nvim}",
            oil = "${pkgs.vimPlugins.oil-nvim}",
            scope = "${pkgs.vimPlugins.scope-nvim}",
            -- telescope = "${pkgs.vimPlugins.telescope-nvim}",
              telescope_fzf_native = "${pkgs.vimPlugins.telescope-fzf-native-nvim}",
              telescope_undo = "${pkgs.vimPlugins.telescope-undo-nvim}",

            dressing = "${pkgs.vimPlugins.dressing-nvim}",
            gitsigns = "${pkgs.vimPlugins.gitsigns-nvim}",
            ufo = "${pkgs.vimPlugins.nvim-ufo}",
              promise_async = "${pkgs.vimPlugins.promise-async}",
            todo_comments = "${pkgs.vimPlugins.todo-comments-nvim}",
              plenary = "${pkgs.vimPlugins.plenary-nvim}",
            colorizer = "${pkgs.vimPlugins.nvim-colorizer-lua}",

          }
          require("startup")
          vim.opt.rtp:append("${
            pkgs.symlinkJoin {
              name = "treesitter";
              paths =
                (pkgs.vimPlugins.nvim-treesitter.withPlugins (
                  p: with p; [
                    # bash, c, lua, markdown, python, query, vim, vimdoc installed by default
                    arduino
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
                    markdown_inline
                    nix
                    norg
                    regex
                    rust
                    svelte
                    toml
                    typescript
                    udev
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
        nil
        nixfmt-rfc-style
        ## Shell
        shfmt
        shellcheck
        ## Lua
        lua-language-server
        stylua
        ## JavaScript
        biome
        nodePackages_latest.typescript-language-server
        ## Tailwind
        tailwindcss-language-server
        rustywind
        ## Go
        gopls
        gofumpt
        ## Python
        ruff-lsp
        pyright
      ];
    };

    zsh = {
      enable = true;
      enableCompletion = false;
      dotDir = ".config/zsh";
      initExtra = builtins.readFile ./config/zsh/zshrc;
      envExtra = builtins.readFile ./config/zsh/zshenv;
      history = {
        path = "${config.xdg.stateHome}/zsh/history";
        size = 100000;
        save = 100000;
      };
    };

    eza = {
      enable = true;
      #enableAliases = true;
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
        theme = "Catppuccin-mocha";
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
      defaultCommand = "fd --prune --type file -L --color=always";
      defaultOptions = [
        "--inline-info"
        "--ansi"
        "--cycle"
        "--multi"
        "--height ~100%"
        "--border"
        "--preview 'bat --force-colorization --paging=always {}'"
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
            selectedRangeBgColor = [ "#313244" ];
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
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  services = {
    udiskie.enable = true;
    cliphist.enable = true;
    playerctld.enable = true;

    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 65;
          command = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock -f";
        }
        {
          timeout = 60;
          command = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
          resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock -f";
        }
      ];
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

          frame_color = "#89B4FA";
          separator_color = "frame";

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
        urgency_low = {
          background = "#1E1E2ECC";
          foreground = "#CDD6F4";
          # frame_color = "#c0caf5";
        };
        urgency_normal = {
          background = "#1E1E2ECC";
          foreground = "#CDD6F4";
          # frame_color = "#c0caf5";
        };
        urgency_critical = {
          background = "#1E1E2ECC";
          foreground = "#CDD6F4";
          frame_color = "#FAB387";
        };
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
        size = "16x16";
      };
    };
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/var/lib/age.txt";

    secrets.ssh.path = "/home/tarxz/.ssh/id_ed25519";
  };

  home.stateVersion = "23.11";
}
