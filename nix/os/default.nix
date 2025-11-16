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
      "systemd.show_status=auto"
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
        "networkmanager"
        "wheel"
        "docker"
        "video"
        "adbusers"
      ];
      shell = pkgs.dash;
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    registry = lib.mapAttrs (_: v: { flake = v; }) (
      lib.filterAttrs (_: v: lib.isType "flake" v) inputs
    );
    nixPath = lib.mapAttrsToList (k: _: "${k}=flake:${k}") config.nix.registry;
    settings = {
      use-xdg-base-directories = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [ "@wheel" ];
    };
  };

  environment = {
    binsh = "${pkgs.lib.getExe pkgs.dash}";
    systemPackages = [ pkgs.run0-sudo-shim ];
    pathsToLink = [ "/share/zsh" ];
  };

  programs = {
    git = {
      enable = true;
      lfs = {
        enable = true;
        enablePureSSHTransfer = true;
      };
    };

    ssh = {
      package = pkgs.openssh_hpn;
      ciphers = [
        "aes128-gcm@openssh.com"
        "aes256-gcm@openssh.com"
        "chacha20-poly1305@openssh.com"
        "aes256-ctr"
        "aes192-ctr"
        "aes128-ctr"
      ];
    };

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

  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "10s";
    DefaultTimeoutStartSec = "15s";
  };

  security.sudo.enable = false;

  sops = {
    defaultSopsFile = ../secrets.yaml;
    age.keyFile = "/var/lib/age.txt";

    secrets = {
      wg = { };
      tailscale = { };
    };
  };
}
