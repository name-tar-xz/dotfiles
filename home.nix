{ config, pkgs, inputs, ... }: {
  imports = [
    inputs.nur.nixosModules.nur
  ];

  xdg = {
    cacheHome = "/home/***REMOVED***/.local/cache";
    configHome = "/home/***REMOVED***/.config";
    dataHome = "/home/***REMOVED***/.local/share";
    stateHome = "/home/***REMOVED***/.local/state";
  };

  home = {
    username = "***REMOVED***";
    homeDirectory = "/home/***REMOVED***";
    # You can also create simple shell scripts directly inside your
    # configuration. For example, this adds a command 'my-hello' to your
    # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    packages = with pkgs; with nodePackages_latest; [
      # Hyprland
      dunst ## Notification Daemon
      hyprpicker
      inputs.nixpkgs-wayland.packages.${system}.swaylock-effects ## LockScreen
      swaybg
      swayidle
      waybar
      wlogout
      wofi ## Launcher
      rofi-wayland
      ## Screenshot
      grim
      slurp

      # System Control
      iwgtk
      ## Clipboard
      cliphist
      wl-clipboard
      ## Brightness
      brightnessctl
      ## Audio
      pamixer
      qpwgraph
      pavucontrol

      # Applications
      ferdium
      kitty
      libreoffice-fresh
      wezterm

      # CLI tools
      btop
      doas-sudo-shim
      fastfetch
      fzf
      hyperfine
      jq
      lazygit
      mcfly
      moar
      inputs.nix-alien.packages.${system}.nix-alien
      onefetch
      playerctl
      tealdeer
      unzip
      vivid
      zip
      zoxide
      ## Coreutil Replacements
      bat
      delta
      fd
      eza
      ripgrep
      ## Downloaders
      aria
      wget
      ## File Management
      file
      lf
      nix-tree
      ranger
      rmtrash
      trash-cli
      xdg-utils

      # MPV
      (mpv.override {
        scripts = with mpvScripts; [
          autodeint
          mpris
          sponsorblock
        ];
      })
      ani-cli
      yt-dlp

      # Neovim formatter,LSP,linters
      codespell
      vscode-langservers-extracted
      taplo ## TOML
      ## Arduino
      arduino-language-server
      astyle
      ## Nix
      nil
      nixpkgs-fmt
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
      nodejs
      bun
      ## Python
      python3

      # Misc
      bash-completion
      libnotify
      topgrade
      # Themes
      papirus-icon-theme
      libsForQt5.lightly
    ];

    sessionVariables = {
      XDG_DATA_HOME = "${config.xdg.dataHome}";
      XDG_CONFIG_HOME = "${config.xdg.configHome}";
      XDG_STATE_HOME = "${config.xdg.stateHome}";
      XDG_CACHE_HOME = "${config.xdg.cacheHome}";

      NIXOS_OZONE_WL = "1";
      /* SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
      QT_QPA_PLATFORM = "wayland;xcb"; */

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
        __EGL_VENDOR_LIBRARY_FILENAMES = "/usr/share/glvnd/egl_vendor.d/10_nvidia.json"; */

      /* QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      GTK_THEME = "Catppuccin-Mocha-Compact-Mauve-Dark";
      GDK_SCALE = "2"; */
    };

    shellAliases = {
      rg = "rg -SL";

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
      ".." = "z ..";
      "..." = "z ../..";
      "...." = "z ../../..";
      "....." = "z ../../../..";
      "......" = "z ../../../../..";
      rm = "rmtrash -v";
      rmdir = "rmdirtrash -v --ignore-fail-on-non-empty";

      v = "nvim";
      em = "/usr/bin/emacs -nw";
      hx = "helix";
      l = "eza -GA --group-directories-first --icons=auto --git-ignore";
      ls = "eza -GA --group-directories-first --icons=auto --git-ignore";
      la = "eza -lAX --group-directories-first --icons=auto --smart-group --git --git-repos --git-ignore";
      ll = "eza -lAX --group-directories-first --icons=auto --smart-group --git --git-repos --git-ignore";
      lt = "eza -lAX --group-directories-first --icons=auto --smart-group --git --git-repos --git-ignore --tree *"; # tree listing
      cp = "cp -i";
      mv = "mv -i";
      diff = "delta";
      cd = "z";
      getenv = "printenv|rg -i";
      cls = "TERM=xterm clear";
      cl = "TERM=xterm clear";
      c = "TERM=xterm clear";
      clear = "TERM=xterm clear";
      db = "dotbare";
      cat = "bat -Pp";
      nohup = "command rm nohup.out;nohup";

      update = "nix flake update ~/.config/nixos --commit-lock-file; sudo nixos-rebuild switch";
      switch = "sudo nixos-rebuild switch";
    };

    file = {
      "${config.xdg.configHome}/nvim/parser/norg.so".source = "${pkgs.tree-sitter-grammars.tree-sitter-norg}/parser";

      "${config.home.homeDirectory}/.mozilla/firefox/main/chrome/csshacks".source = "${inputs.csshacks}";
      "${config.home.homeDirectory}/.mozilla/firefox/main/chrome/includes".source = ./config/firefox/chrome/includes;

      "${config.xdg.configHome}/gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "${config.xdg.configHome}/gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
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
  };

  gtk = {
    enable = true;
    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    };

    theme = {
      name = "Catppuccin-Mocha-Compact-Mauve-Dark";
      package = (pkgs.catppuccin-gtk.override {
        accents = [ "mauve" "sapphire" ]; # You can specify multiple accents here to output multiple themes
        size = "compact";
        tweaks = [ "black" ]; # You can also specify multiple tweaks here
        variant = "mocha";
      });
    };
    font.name = "Noto Sans";
    iconTheme.name = "Papirus-Dark";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = "${builtins.readFile ./config/hypr/hyprland.conf}";
  };

  programs = {
    home-manager.enable = true;

    firefox = {
      enable = true;
      package = (pkgs.librewolf.override { cfg = { speechSynthesisSupport = false; }; }); # link ~/.mozilla/firefox and ~/.librewolf for this to work
      profiles = {
        main = {
          extraConfig = ''
            ${builtins.readFile "${inputs.betterfox}/user.js"}
            ${builtins.readFile ./config/firefox/user.js}
          '';

          userChrome = builtins.readFile ./config/firefox/chrome/userChrome.css;
          userContent = builtins.readFile ./config/firefox/chrome/userContent.css;

          extensions = with config.nur.repos.rycee.firefox-addons;[
            ublock-origin
            libredirect
            bitwarden
            tree-style-tab
            darkreader
            tridactyl
            nighttab

            redirector
            tampermonkey
            user-agent-string-switcher
          ];

          /* search = {
            default = "Brave";
            engines = {
              "Brave" = {
                template = "https://search.brave.com/search";
                params = [{ name = "q"; value = "{searchTerms}"; }];
              };
              "Bing".metaData.hidden = true;
              "Google".metaData.hidden = true;
            };
          }; */
        };
        test.id = 1;
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
      initExtra = "${builtins.readFile ./config/zsh/zshrc}";
      envExtra = "${builtins.readFile ./config/zsh/zshenv}";
    };
  };

  services = {
    blueman-applet.enable = true;
    udiskie.enable = true;
    swayidle = {
      enable = true;
      timeouts = [
        { timeout = 60; command = "${inputs.nixpkgs-wayland.packages."x86_64-linux".swaylock-effects}/bin/swaylock -f"; }
        { timeout = 60; command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off"; resumeCommand = "${pkgs.hyprland}/bin/hyprland dispatch dpms on"; }
      ];
      events = [
        { event = "before-sleep"; command = "${inputs.nixpkgs-wayland.packages."x86_64-linux".swaylock-effects}/bin/swaylock -f"; }
      ];
    };
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/home/***REMOVED***/.config/sops/age/keys.txt";

    secrets.ssh.path = "/home/***REMOVED***/.ssh/id_ed25519";
    secrets.gpg.path = "/home/***REMOVED***/.local/share/gnupg/private-keys-v1.d/F2F3ACD0B6055BC445CFFFC1E3DD87591F0A6FC2.key";
  };

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
