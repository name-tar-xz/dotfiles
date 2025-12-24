{
  config,
  pkgs,
  lib,
  inputs,
  hostname,
  ...
}:
{
  imports = [
    ./harden.nix
    ./minimal.nix
    ./network.nix
    ./perf.nix
    ./syncthing.nix
    ./time.nix

    inputs.run0-sudo-shim.nixosModules.default

    ./hosts/${hostname}-hardware.nix
    ./hosts/${hostname}.nix
  ];

  boot = {
    tmp = {
      useTmpfs = true;
      tmpfsHugeMemoryPages = "within_size";
    };
    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 30;
        consoleMode = "max";
      };
    };
    initrd.verbose = false;

    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "vt.global_cursor_default=0"
      "rd.systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];
  };

  users = {
    mutableUsers = false;
    users.tarxz = {
      uid = 1000;
      hashedPassword = "$y$j9T$988v1QRaUKdb9ce3TGIL5/$8/UFRFQ8bq7SQcUGUnnwxCW0RLg/It7hBD26m9J7AY5";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "video"
        "audio"
      ]
      ++ builtins.filter (group: builtins.hasAttr group config.users.groups) [
        "adbusers"
        "disk"
        "docker"
        "flatpak"
        "kvm"
        "libvirtd"
        "openrazer"
        "podman"
      ];
      shell = pkgs.dash;
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix = rec {
    channel.enable = false;
    package = pkgs.lixPackageSets.latest.lix;

    registry = lib.mapAttrs (_: v: { flake = v; }) (
      lib.filterAttrs (_: v: lib.isType "flake" v) inputs
    );
    nixPath = lib.mapAttrsToList (k: _: "${k}=flake:${k}") registry;

    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

    settings = {
      use-xdg-base-directories = true;
      auto-optimise-store = true;
      warn-dirty = false;

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      allowed-users = [ "@wheel" ];
      trusted-users = [ "@wheel" ];

      nix-path = nixPath;
    };
  };

  environment = {
    binsh = pkgs.lib.getExe pkgs.dash;
    pathsToLink = [ "/share/zsh" ];
    systemPackages = [ pkgs.uutils-coreutils-noprefix ];
  };

  programs = {
    git = {
      enable = true;
      lfs = {
        enable = true;
        enablePureSSHTransfer = true;
      };
    };

    ssh.package = pkgs.openssh_hpn;

    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 3";
      };
    };
  };

  services = {
    tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tailscale.path;
    };

    journald.extraConfig = "SystemMaxUse=100M";
  };

  systemd = {
    oomd = {
      enable = true;
      enableRootSlice = true;
      enableSystemSlice = true;
      enableUserSlices = true;
      settings.OOM.DefaultMemoryPressureDurationSec = "20s";
    };

    settings.Manager = {
      DefaultTimeoutStopSec = "10s";
      DefaultTimeoutStartSec = "15s";
    };
  };

  security = {
    sudo.enable = false;
    run0-sudo-shim.enable = true;
    polkit.persistentAuthentication = true;
  };

  sops = {
    defaultSopsFile = ../secrets.yaml;
    age.keyFile = "/var/lib/age.txt";

    secrets = {
      wg = { };
      tailscale = { };
    };
  };
}
