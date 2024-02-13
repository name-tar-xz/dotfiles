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
      "nvim/parser/norg.so".source = "${pkgs.tree-sitter-grammars.tree-sitter-norg}/parser";

      "wlogout/icons".source = "${pkgs.wlogout}/share/wlogout/icons";
      "waybar/config.jsonc".source = ./config/waybar/config.jsonc;

      "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    };
  };

  home = {
    username = "***REMOVED***";
    homeDirectory = "/home/***REMOVED***";
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    packages = with pkgs; [
      # Hyprland
      hyprpicker
      swaybg
      grimblast # Screenshot
      iwgtk # System Control
      wl-clipboard # Clipboard
      brightnessctl # Brightness
      rofi-bluetooth # Bluetooth
      rofi-power-menu

      # Audio
      pamixer
      qpwgraph
      pavucontrol

      # Applications
      ferdium
      kitty
      libreoffice-fresh
      monophony
      wezterm

      # CLI tools
      btop
      doas-sudo-shim
      fastfetch
      hyperfine
      jq
      inputs.nix-alien.packages.${pkgs.system}.nix-alien
      nh
      onefetch
      sops
      unzip
      vivid
      zip
      ## Coreutil Replacements
      fd
      zoxide
      ## Downloaders
      ani-cli
      aria
      wget
      ## File Management
      file
      nix-tree
      rmtrash
      trash-cli
      xdg-utils

      # Neovim formatter,LSP,linters
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
      selene
      stylua
      ## JavaScript
      biome
      typescript-language-server
      ## Tailwind
      tailwindcss-language-server
      rustywind
      ## Go
      gopls
      gofumpt
      ## Python
      ruff-lsp
      pyright

      # Languages
      arduino-cli
      go
      ## C/C++
      clang
      gnumake
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
      FLAKE = "${config.home.homeDirectory}/.config/nixos";

      BROWSER = "librewolf";
      SUDO_EDITOR = "nvim";
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse --ignore-case --LONG-PROMPT --quit-on-intr --tilde";
      BAT_PAGER = config.home.sessionVariables.PAGER;
      LESSUTFCHARDEF = "E000-F8FF:p,F0000-FFFFD:p";

      NIXOS_OZONE_WL = "1";
      /* SDL_VIDEODRIVER = "wayland";
         XDG_SESSION_TYPE = "wayland";
         QT_QPA_PLATFORM = "wayland;xcb";
      */

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

      /* __GLX_VENDOR_LIBRARY_NAME = "nvidia";
         NVD_BACKEND = "direct";
         MOZ_DISABLE_RDD_SANDBOX = "1";
         EGL_PLATFORM = "wayland";
         LIBVA_DRIVER_NAME = "nvidia";
           __EGL_VENDOR_LIBRARY_FILENAMES = "/usr/share/glvnd/egl_vendor.d/10_nvidia.json";
      */

      /* QT_AUTO_SCREEN_SCALE_FACTOR = "1";
         QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
         GTK_THEME = "Catppuccin-Mocha-Compact-Mauve-Dark";
         GDK_SCALE = "2";
      */
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
      wget = "wget -c --hsts-file='$XDG_DATA_HOME/wget-hsts ' ";
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

      update = "nix flake update ${config.home.sessionVariables.FLAKE} --commit-lock-file;nh os switch";
      switch = "nh os switch";
      fast = "sudo nixos-rebuild switch --fast";
    };

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
    platformTheme = "qtct";
    style.package = pkgs.libsForQt5.lightly;
  };

  gtk = {
    enable = true;
    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    };

    theme = {
      name = "Catppuccin-Mocha-Compact-Mauve-Dark";
      package = (
        pkgs.catppuccin-gtk.override {
          accents = [
            "mauve"
            "sapphire"
          ];
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
      vars = builtins.mapAttrs (name: value: name + "," + builtins.toString (value)) config.home.sessionVariables;
    in
    {
      enable = true;
      xwayland.enable = true;
      settings.env = (map (key: builtins.getAttr key vars) (builtins.attrNames vars));
      extraConfig = builtins.readFile ./config/hypr/hyprland.conf;
    };

  programs = {
    home-manager.enable = true;

    firefox = {
      enable = true;
      package = (pkgs.librewolf.override { cfg.speechSynthesisSupport = false; }); # link ~/.mozilla/firefox and ~/.librewolf for this to work
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
            bitwarden
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
        hwdec = "auto-safe";
        vo = "gpu";
        ao = "pipewire,";
        gpu-context = "wayland";
        profile = "gpu-hq";
        scale = "ewa_lanczos";
        cscale = "ewa_lanczos";
        deband = true;
        audio-spdif = [
          "ac3"
          "eac3"
          "dts-hd"
          "truehd"
        ];
        sub-font = "Cascadia Code";
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
      systemd.enable = false;
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
        modes = "drun,window,calc";
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
    swaylock = {
      enable = true;
      package = inputs.nixpkgs-wayland.packages.${pkgs.system}.swaylock-effects;
      settings = {
        show-failed-attempts = true;
        clock = true;
        color = "1f1d2e80";
        font = "monospace";
        indicator = true;
        indicator-radius = 100;
        indicator-thickness = 15;
        line-color = "1f1d2e";
        ring-color = "191724";
        inside-color = "1f1d2e";
        key-hl-color = "eb6f92";
        separator-color = "00000000";
        text-color = "e0def4";
        line-ver-color = "eb6f92";
        ring-ver-color = "eb6f92";
        inside-ver-color = "1f1d2e";
        text-ver-color = "e0def4";
        ring-wrong-color = "31748f";
        text-wrong-color = "31748f";
        inside-wrong-color = "1f1d2e";
        inside-clear-color = "1f1d2e";
        text-clear-color = "e0def4";
        ring-clear-color = "9ccfd8";
        line-clear-color = "1f1d2e";
        line-wrong-color = "1f1d2e";
        bs-hl-color = "31748f";
        grace-no-mouse = true;
        grace-no-touch = true;
        datestr = "%d/%m";
        fade-in = 0.1;
        ignore-empty-password = true;
        effect-blur = "7x5";
        effect-vignette = "0.5:0.5";
        screenshots = true;
      };
    };

    git = {
      enable = true;
      userName = "name.tar.xz";
      userEmail = "git.3myp3@slmail.me";
      signing = {
        key = "D3C9DE564A3DBD30";
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
      enableAliases = true;
      extraOptions = [
        "-aX"
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
        ];
      };
      extraPackages = with pkgs.bat-extras; [
        batwatch
        batgrep
        batpipe
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
    lf = {
      enable = true;
      previewer.source = pkgs.writeShellScript "pv.sh" ''
        file=$1
        w=$2
        h=$3
        x=$4
        y=$5

        if [[ "$( file -Lb --mime-type "$file")" =~ ^image ]]; then
          kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
          exit 1
        fi

        pistol "$file"
      '';
      settings = {
        icons = true;
        hidden = true;
        number = true;
        relativenumber = true;
        info = "size";
        cursorpreviewfmt = "";
        scrolloff = 999;
        cleaner = "${pkgs.writeShellScript "cl.sh" "kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty"}";
      };
    };
    pistol = {
      enable = true;
      associations = [
        {
          mime = "text/*";
          command = "bat --paging=never --color=always %pistol-filename%";
        }
        {
          mime = "image/*";
          command = "kitty +kitten icat --silent --stdin no --transfer-mode file %pistol-filename%";
        }
        {
          mime = "inode/directory";
          command = "eza %pistol-filename% --icons=always -l";
        }
      ];
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
    /* zoxide = {
         enable = true;
         enableZshIntegration = true;
       };
    */
  };

  services = {
    blueman-applet.enable = false;
    udiskie.enable = true;
    cliphist.enable = true;
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 60;
          command = "${inputs.nixpkgs-wayland.packages.${pkgs.system}.swaylock-effects}/bin/swaylock -f";
        }
        {
          timeout = 60;
          command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          resumeCommand = "${pkgs.hyprland}/bin/hyprland dispatch dpms on";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${inputs.nixpkgs-wayland.packages.${pkgs.system}.swaylock-effects}/bin/swaylock -f";
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

          dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dunst:";
          browser = "${config.programs.firefox.package}/bin/librewolf --new-tab";

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

    playerctld.enable = true;
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/home/***REMOVED***/.config/sops/age/keys.txt";

    secrets.ssh.path = "/home/***REMOVED***/.ssh/id_ed25519";
    secrets.gpg.path = "/home/***REMOVED***/.local/share/gnupg/private-keys-v1.d/F2F3ACD0B6055BC445CFFFC1E3DD87591F0A6FC2.key";
  };

  home.stateVersion = "23.11";
}
