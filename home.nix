{ config, pkgs, inputs, ... }: {
  home.username = "***REMOVED***";
  home.homeDirectory = "/home/***REMOVED***";
  xdg.cacheHome = "/home/***REMOVED***/.local/cache";

  imports = [ inputs.ags.homeManagerModules.default ];


  home = {
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
      wluma
      ## Audio
      pamixer
      qpwgraph
      pavucontrol

      # Applications
      brave
      distrobox
      ferdium
      kitty
      libreoffice-fresh
      (librewolf.override { cfg = { speechSynthesisSupport = false; }; })
      monophony
      wezterm

      # CLI tools
      btop
      doas-sudo-shim
      fastfetch
      fzf
      git
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
      lsd
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
      rustup
      ## C/C++
      clang
      gnumake
      ## JavaScript
      nodejs
      bun
      ## Python
      pipx
      python3

      # Misc
      bash-completion
      libnotify
      topgrade
      # Themes
      papirus-icon-theme
      libsForQt5.lightly
      (catppuccin-gtk.override {
        accents = [ "mauve" ]; # You can specify multiple accents here to output multiple themes
        size = "compact";
        tweaks = [ "black" ]; # You can also specify multiple tweaks here
        variant = "mocha";
      })
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
      QT_QPA_PLATFORM = "wayland;xcb";
      WLR_NO_HARDWARE_CURSORS = "1";
      KITTY_ENABLE_WAYLAND = "1";

      KDEHOME = "$XDG_CONFIG_HOME/kde";
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      GOPATH = "$XDG_DATA_HOME/go";
      LESSHISTFILE = "$XDG_CACHE_HOME/less/history";
      HISTFILE = "$XDG_STATE_HOME/bash/history";
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
      GNUPGHOME = "$XDG_DATA_HOME/gnupg";
      WINEPREFIX = "$XDG_DATA_HOME/wine";
      NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
      NVM_DIR = "$XDG_DATA_HOME/nvm";
      ANDROID_HOME = "$XDG_DATA_HOME/android";
      PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
      PARALLEL_HOME = "$XDG_CONFIG_HOME/parallel";
      GRADLE_USER_HOME = "$XDG_DATA_HOME/gradle";

      /* __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
      MOZ_DISABLE_RDD_SANDBOX = "1";
      EGL_PLATFORM = "wayland";
      LIBVA_DRIVER_NAME = "nvidia";
        __EGL_VENDOR_LIBRARY_FILENAMES = "/usr/share/glvnd/egl_vendor.d/10_nvidia.json"; */

      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      GTK_THEME = "Catppuccin-Mocha-Compact-Mauve-Dark";
      GDK_SCALE = "2";
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
      l = "lsd";
      lt = "lsd --tree"; # tree listing
      ls = "lsd";
      la = "lsd -l";
      ll = "lsd -l";
      "l." = "lsd -A|egrep '^.'";
      cp = "cp -i";
      mv = "mv -i";
      diff = "delta";
      cd = "z";
      getenv = "printenv|rg -i";
      cls = "TERM=alacritty clear";
      cl = "TERM=alacritty clear";
      c = "TERM=alacritty clear";
      clear = "TERM=alacritty clear";
      db = "dotbare";
      cat = "bat -Pp";
      nohup = "command rm nohup.out;nohup";

      update = "nix flake update ~/.config/nixos; sudo nixos-rebuild switch";
      switch = "sudo nixos-rebuild switch";
    };

    file = {
      "${config.xdg.configHome}/nvim/parser/norg.so".source = "${pkgs.tree-sitter-grammars.tree-sitter-norg}/parser";
    };
  };

  qt = {
    enable = true;
    platformTheme = "qtct";
    style = {
      name = "lightly";
    };
  };

  gtk = {
    theme = {
      name = "Catppuccin-Mocha-Compact-Mauve-Dark";
    };
    font = { name = "Noto Sans"; };
    iconTheme = {
      name = "Papirus-Dark";
    };
    cursorTheme = { name = "Nero"; size = 24; };
    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = "${builtins.readFile ./.config/hypr/hyprland.conf}";
  };

  programs = {
    home-manager.enable = true;

    zsh = {
      enable = true;
      enableCompletion = false;
      dotDir = ".config/zsh";
      initExtra = "${builtins.readFile ./.config/zsh/.zshrc}";
      envExtra = "${builtins.readFile ./.config/zsh/.zshenv}";
    };

    ags = {
      enable = true;

      # packages to add to gjs's runtime
      # extraPackages = with pkgs; [ ];
    };
  };

  services = {
    blueman-applet.enable = true;
    udiskie.enable = true;
  };

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
