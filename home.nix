{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin

    ./nix/hm/hyprland
    ./nix/hm/theme
    ./nix/hm/rofi

    ./nix/hm/browser
    ./nix/hm/kitty.nix
    ./nix/hm/mpv.nix

    ./nix/hm/cli
    ./nix/hm/nvim
  ];

  catppuccin = {
    flavor = "mocha";
    btop.enable = true;
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    cacheHome = "${config.home.homeDirectory}/.local/cache";

    configFile = {
      "lf/icons".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/gokcehan/lf/refs/heads/master/etc/icons.example";
        hash = "sha256-c0orDQO4hedh+xaNrovC0geh5iq2K+e+PZIL5abxnIk=";
      };

      "npm/npmrc".source = ./nix/hm/config/npm/npmrc;
      "python/pythonrc".source = ./nix/hm/config/python/pythonrc.py;
    };
  };

  home = {
    username = "tarxz";
    homeDirectory = "/home/tarxz";
    packages = with pkgs; [
      sops
      iwgtk # Wifi
      overskride # Bluetooth
      # Audio
      qpwgraph
      pwvucontrol

      libreoffice-qt6-fresh # Applications

      # Games
      retroarch
      lutris
      umu-launcher
      ludusavi
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
      STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
      NVM_DIR = "${config.xdg.dataHome}/nvm";
      ANDROID_HOME = "${config.xdg.dataHome}/android";
      PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonrc";
      PARALLEL_HOME = "${config.xdg.configHome}/parallel";
      GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java -Djavafx.cachedir=${config.xdg.cacheHome}/openjfx";
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
      fast = "nh os test";
    };
    sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];
  };

  programs = {
    home-manager.enable = true;
    mangohud.enable = true;

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
  };

  services = {
    udiskie = {
      enable = true;
      settings = {
        device_config = {
          "- is_loop" = true;
          ignore = true;
        };
      };
    };
  };

  systemd.user = {
    sessionVariables = config.home.sessionVariables;
    startServices = true;
  };

  sops = {
    defaultSopsFile = ./nix/secrets.yaml;
    age.keyFile = "/var/lib/age.txt";

    secrets.ssh.path = "/home/tarxz/.ssh/id_ed25519";
  };

  home.stateVersion = "23.11";
}
