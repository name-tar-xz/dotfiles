{
  config,
  osConfig,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin

    ./hyprland
    ./theme.nix
    ./rofi

    ./browser
    ./games.nix
    ./kitty.nix
    ./mpv.nix

    ./cli
    ./nvim
  ];

  nix = { inherit (osConfig.nix) gc; };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      setSessionVariables = true;
      extraConfig.SCREENSHOTS = "${config.xdg.userDirs.pictures}/Screenshots";
    };
    cacheHome = "${config.home.homeDirectory}/.local/cache";

    autostart = {
      enable = true;
      readOnly = true;
      entries = [
        "${
          pkgs.makeDesktopItem {
            name = "iwgtk-indicator";
            desktopName = "inhibit-iwgtk";
          }
        }/share/applications/iwgtk-indicator.desktop"
      ];
    };

    configFile = {
      "lf/icons".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/gokcehan/lf/refs/heads/master/etc/icons.example";
        hash = "sha256-c0orDQO4hedh+xaNrovC0geh5iq2K+e+PZIL5abxnIk=";
      };

      "python/pythonrc".source = config/python/pythonrc.py;
    };
  };

  home = rec {
    username = "tarxz";
    homeDirectory = "/home/${username}";
  }
  // {
    stateVersion = "23.11";
    preferXdgDirectories = true;

    packages = with pkgs; [
      sops
      iwgtk # Wifi
      overskride # Bluetooth
      # Audio
      crosspipe
      pwvucontrol

      # libreoffice-qt6-fresh # Applications
    ];

    sessionVariables = {
      __HM_SESS_VARS_SOURCED = 1; # Prevent zsh from re-sourcing hm-session-vars.sh
      BROWSER = "firefox";
      PAGER = "less";

      NIXOS_OZONE_WL = 1;
      PROTON_USE_NTSYNC = 1;
    }
    // (with config.xdg; {
      KDEHOME = "${configHome}/kde";
      CARGO_HOME = "${dataHome}/cargo";
      CUDA_CACHE_PATH = "${cacheHome}/nv";
      GOPATH = "${dataHome}/go";
      RUSTUP_HOME = "${dataHome}/rustup";
      WINEPREFIX = "${dataHome}/wine";
      NODE_REPL_HISTORY = "${dataHome}/node_repl_history";
      NVM_DIR = "${dataHome}/nvm";
      ANDROID_USER_HOME = "${dataHome}/android";
      PYTHONSTARTUP = "${configHome}/python/pythonrc";
      PARALLEL_HOME = "${configHome}/parallel";
      GRADLE_USER_HOME = "${dataHome}/gradle";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${configHome}/java -Djavafx.cachedir=${cacheHome}/openjfx";
    });

    shellAliases = {
      jctl = "journalctl -b";
      sysfailed = "systemctl list-units --failed";
      ssn = "shutdown now";
      rb = "reboot";

      sudo = "run0 --setenv=TERMINFO=$TERMINFO ";
      getenv = "printenv|rg -i";

      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";

      v = "nvim";
      l = "ls";
      a = "ll";
      cp = "cp -ig";
      mv = "mv -ig";
      rm = "rmtrash -v";
      rmdir = "rmdirtrash -v --ignore-fail-on-non-empty";
      cat = "bat";
      diff = "git diff --no-index";
    }
    // (with config.xdg; {
      wget = "wget -c --hsts-file='${dataHome}/wget-hsts'";
      adb = "HOME=${dataHome}/android adb";
    })
    // rec {
      jaq = "noglob jaq";
      jq = jaq;

      clear = "clear -T xterm";
      cl = clear;
      c = clear;
    };
  };

  dconf.settings."org/gtk/settings/file-chooser" = {
    sort-directories-first = true;
    show-hidden = true;
  };

  programs = {
    home-manager.enable = true;

    ssh = {
      enable = true;
      package = pkgs.openssh_hpn;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          controlMaster = "auto";
          controlPersist = "yes";
          compression = true;
          controlPath = "~/.ssh/master-%r@%n:%p";
        };
        "github.com".controlMaster = "no";
      };
    };
    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
      settings = {
        cert-digest-algo = "SHA512";
        charset = "utf-8";
        default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
        fixed-list-mode = true;
        keyid-format = "0xlong";
        list-options = "show-uid-validity";
        no-comments = true;
        no-emit-version = true;
        no-greeting = true;
        no-symkey-cache = true;
        personal-cipher-preferences = "AES256 AES192 AES";
        personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
        personal-digest-preferences = "SHA512 SHA384 SHA256";
        require-cross-certification = true;
        s2k-cipher-algo = "AES256";
        s2k-digest-algo = "SHA512";
        throw-keyids = true;
        verify-options = "show-uid-validity";
        with-fingerprint = true;
      };
    };
  };

  services = {
    udiskie = {
      enable = true;
      settings = {
        device_config = [
          {
            is_loop = true;
            ignore = true;
          }
        ];
      };
    };
  };

  systemd.user = {
    inherit (config.home) sessionVariables;
    startServices = true;
    services.udiskie.Service.Slice = "background.slice";
  };

  sops = {
    defaultSopsFile = ../secrets.yaml;
    age.keyFile = "/var/lib/age.txt";

    secrets.ssh.path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  };
}
