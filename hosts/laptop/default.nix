{
  pkgs,
  inputs,
  ...
}:
{
  imports = with inputs; [
    home-manager.nixosModules.home-manager
    lanzaboote.nixosModules.lanzaboote
    sops-nix.nixosModules.sops
    phoenix.nixosModules.default

    ./boot.nix
    ./hardware.nix

    ../../os/audio.nix
    ../../os/fonts.nix
    ../../os/games.nix
    ../../os/greetd.nix
    ../../os/intel.nix
    ../../os/nvidia.nix
    ../../os/perf.nix
  ];

  boot = {
    kernelParams = [ "nvme.noacpi=1" ];
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v4; # lqx xanmod xanmod_latest xanmod_stable zen
  };

  environment.memoryAllocator.provider = "graphene-hardened-light";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    startAsUserService = true;
    users.tarxz = import ../../hm;
    extraSpecialArgs = { inherit inputs; };
    sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
  };

  nixpkgs.overlays = [
    (_: prev: {
      speechd = prev.speechd.override {
        withLibao = false;
        withPulse = false;
        withAlsa = false;
        withOss = false;
        withFlite = false;
        withEspeak = false;
        withPico = false;
        libsOnly = true;
      };
    })
  ]
  ++ (with inputs; [
    neovim-nightly-overlay.overlays.default
    nix-cachyos-kernel.overlays.pinned
  ]);

  programs = {
    firefox.phoenix.firefoxPackages = [ "firefox-bin" ];

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      withPython3 = false;
      withRuby = false;
    };
    nano.enable = false;

    dconf.enable = true;
  };

  services = {
    syncthing = {
      user = "tarxz";
      configDir = "/home/tarxz/.config/syncthing";
      dataDir = "/home/tarxz";
    };

    fprintd.enable = false; # Disable until https://gitlab.freedesktop.org/libfprint/libfprint/-/issues/401 gets fixed
    fwupd.enable = false;

    dbus = {
      enable = true;
      implementation = "broker";
    };

    udisks2.enable = true;
    fstrim.enable = true;
  };

  systemd = {
    enableEmergencyMode = false;
    suppressedSystemUnits = [ "systemd-backlight@.service" ];
    services.audit.enable = false;

    user.services.dconf.serviceConfig.Slice = "session.slice";
  };

  security = {
    polkit.enable = true;
    pam.services.hyprlock = { };

    wrappers.btop = {
      owner = "root";
      group = "root";
      source = pkgs.lib.getExe pkgs.btop;
      capabilities = "cap_perfmon=+ep";
    };

    rtkit.enable = true;
  };

  system.stateVersion = "23.05";

  hardware = {
    firmware = [ pkgs.linux-firmware ];
    enableRedistributableFirmware = false;
    graphics.enable32Bit = true;

    bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings.General = {
        ControllerMode = "bredr";
        Experimental = true;
      };
    };

    openrazer = {
      enable = true;
      users = [ "@wheel" ];
    };
  };
}
