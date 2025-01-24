{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./power.nix
    ./minimal.nix
    ./syncthing.nix
    ./network.nix
    ./sysctl.nix
  ];

  boot = {
    tmp.useTmpfs = true;
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
      "udev.log_level=3"
    ];
  };

  # Set your time zone.
  time = {
    timeZone = "Asia/Kolkata";
    hardwareClockInLocalTime = true;
  };

  i18n.defaultLocale = "en_US.UTF8";

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
      ];
      shell = pkgs.dash;
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.lix;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
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
    systemPackages = with pkgs; [ git ];
    binsh = "${pkgs.lib.getExe pkgs.dash}";
  };

  programs = {
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
    userborn.enable = true;
    tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tailscale.path;
    };

    journald.extraConfig = "SystemMaxUse=100M";
  };

  systemd = {
    enableCgroupAccounting = true;

    extraConfig = ''
      DefaultTimeoutStopSec=10s
      DefaultTimeoutStartSec=15s
      DefaultLimitNOFILE=2048:2097152
    '';

    sleep.extraConfig = ''
      [Sleep]
      MemorySleepMode=deep
    '';
  };

  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          groups = [ "wheel" ];
          persist = true;
        }
      ];
    };
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
