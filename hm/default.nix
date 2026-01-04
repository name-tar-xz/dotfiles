{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin

    ./hyprland
    ./theme
    ./rofi

    ./browser
    ./games.nix
    ./kitty.nix
    ./mpv.nix

    ./cli
    ./nvim
  ];

  catppuccin.flavor = "mocha";

  xdg = {
    enable = true;
    userDirs.enable = true;
    cacheHome = "${config.home.homeDirectory}/.local/cache";

    autostart = {
      enable = true;
      readOnly = true;
      entries = [
        "${
          pkgs.runCommand "block iwgtk autostart" { } ''
            mkdir -p $out/share/autostart
            touch $out/share/autostart/iwgtk-indicator.desktop''
        }/share/autostart/iwgtk-indicator.desktop"
      ];
    };

    configFile = {
      "lf/icons".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/gokcehan/lf/refs/heads/master/etc/icons.example";
        hash = "sha256-c0orDQO4hedh+xaNrovC0geh5iq2K+e+PZIL5abxnIk=";
      };

      "npm/npmrc".source = ./config/npm/npmrc;
      "python/pythonrc".source = ./config/python/pythonrc.py;
    };
  };

  home = rec {
    username = "tarxz";
    homeDirectory = "/home/${username}";
    preferXdgDirectories = true;

    packages = with pkgs; [
      sops
      iwgtk # Wifi
      overskride # Bluetooth
      # Audio
      helvum
      pwvucontrol

      libreoffice-qt6-fresh # Applications
    ];

    sessionVariables = {
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
      NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
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

      sudo = "sudo ";
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
      l = "ls";
      a = "ll";
      cp = "cp -i";
      mv = "mv -i";
      diff = "delta";
      getenv = "printenv|rg -i";
      clear = "clear -T xterm";
      cl = "clear -T xterm";
      c = "clear -T xterm";
      cat = "bat";
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
      matchBlocks."*" = {
        controlMaster = "auto";
        controlPersist = "yes";
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

  home.stateVersion = "23.11";
}
