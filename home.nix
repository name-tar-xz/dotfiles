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
      # Hyprland
      hyprpicker
      grimblast # Screenshot
      iwgtk # System Control
      wl-clipboard # Clipboard
      brightnessctl # Brightness
      rofi-bluetooth # Bluetooth
      overskride
      rofi-power-menu

      # Audio
      qpwgraph
      pwvucontrol

      # Applications
      libreoffice-fresh

      # Games
      retroarch
      lutris
      (inputs.umu.packages.${pkgs.system}.umu.override { version = inputs.umu.shortRev; })
      ludusavi

      # CLI tools
      doas-sudo-shim
      hyperfine
      jq
      onefetch
      sops
      unzip
      zip
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

        # Change the volume using wpctl
        wpctl set-volume @DEFAULT_SINK@ "$@" >/dev/null

        # Query wpctl for the current volume and whether or not the speaker is muted
        volume="$(wpctl get-volume @DEFAULT_SINK@ | awk '{print int($2*100)}')"
        mute="$(wpctl get-volume @DEFAULT_SINK@ | awk '{print $3}')"

        if [[ $volume == 0 || "$mute" == "[MUTED]" ]]; then
          # Show the sound muted notification
          dunstify -a "changeVolume" -u low -i audio-volume-muted -h string:x-dunst-stack-tag:$msgTag "Volume muted"
        else
          # Show the volume notification
          dunstify -a "changeVolume" -u low -i audio-volume-high -h string:x-dunst-stack-tag:$msgTag -h int:value:"$volume" "Volume: ''${volume}%"
        fi
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
        dunstify -a "changeBrightness" -u low -i brightnesssettings -h string:x-dunst-stack-tag:$msgTag -h int:value:"$brightness" "Brightness: ''${brightness}%"
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
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/var/lib/age.txt";

    secrets.ssh.path = "/home/tarxz/.ssh/id_ed25519";
  };

  home.stateVersion = "23.11";
}
