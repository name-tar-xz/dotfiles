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

    ../hosts/${hostname}
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
    initrd = {
      verbose = false;
      compressor = "zstd";
      compressorArgs = [
        "-19"
        "-T0"
      ];
    };

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
    users.root.hashedPassword = "!";
    users.tarxz = {
      uid = 1000;
      hashedPassword = "$y$j9T$988v1QRaUKdb9ce3TGIL5/$8/UFRFQ8bq7SQcUGUnnwxCW0RLg/It7hBD26m9J7AY5";
      isNormalUser = true;
      extraGroups = builtins.filter (group: builtins.hasAttr group config.users.groups) [
        "wheel"
        "video"
        "audio"

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

    registry = inputs |> lib.filterAttrs (_: v: lib.isType "flake" v) |> lib.mapAttrs (_: v: { flake = v; });
    nixPath = registry |> lib.mapAttrsToList (k: _: "${k}=flake:${k}");

    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      use-xdg-base-directories = true;
      auto-optimise-store = true;
      warn-dirty = false;
      cores = 0;
      http-connections = 0;
      http3 = true;
      narinfo-cache-negative-ttl = 1;

      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operator"
        "coerce-integers"
        "lix-custom-sub-commands"

        "cgroups"
        "auto-allocate-uids"
      ];

      use-cgroups = true;
      auto-allocate-uids = true;

      allowed-users = [ "@wheel" ];
      trusted-users = [ "@wheel" ];

      nix-path = nixPath;
    };
  };

  environment = {
    binsh = lib.getExe pkgs.dash;
    pathsToLink = [
      "/share/zsh"
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];
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
  };

  services = {
    tailscale = {
      enable = false;
      authKeyFile = config.sops.secrets.tailscale.path;
    };

    journald.extraConfig = "SystemMaxUse=100M";
  };

  systemd = {
    enableStrictShellChecks = true;
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
    run0 = {
      enable = true;
      enableSudoAlias = true;
      persistentAuth.enable = true;
    };
  };

  sops = {
    defaultSopsFile = ../secrets.yaml;
    age.keyFile = "/var/lib/age.txt";
    useTmpfs = true;

    secrets = {
      wg = { };
      tailscale = { };
    };
  };
}
