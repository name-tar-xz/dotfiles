{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = with inputs; [
    home-manager.nixosModules.home-manager
    chaotic.nixosModules.default
    lanzaboote.nixosModules.lanzaboote
    catppuccin.nixosModules.catppuccin
    sops-nix.nixosModules.sops

    ./nix/os/laptop-hardware.nix
    ./nix/os/common.nix

    ./nix/os/nvidia.nix
    ./nix/os/games.nix
    ./nix/os/perf.nix
    ./nix/os/fonts.nix
  ];

  boot = {
    initrd = {
      systemd.enable = true;
      includeDefaultModules = false;
    };
    kernelParams = [
      "nvme.noacpi=1"
      "gather_data_sampling=off"
    ];
    supportedFilesystems = [ "bacachefs" ];
    kernelPackages = pkgs.linuxPackages_cachyos-lto; # lqx xanmod xanmod_latest xanmod_stable zen

    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  console.earlySetup = true;

  networking = {
    hostName = "laptop";
    useNetworkd = true;
    wireless.iwd = {
      enable = true;
      settings = {
        General.AddressRandomization = "network";
        Settings = {
          AutoConnect = true;
          AlwaysRandomizeAddress = true;
        };
      };
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.tarxz = import ./home.nix;
    extraSpecialArgs = { inherit inputs; };
    sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
  };

  nixpkgs = {
    overlays = [
      (final: prev: {
        librewolf = prev.librewolf.override { cfg.speechSynthesisSupport = false; };

        retroarch = prev.retroarch.withCores (
          cores: with cores; [
            gambatte
            mgba
            melonds
            picodrive
            pcsx-rearmed
            pcsx2
            ppsspp
          ]
        );

        speechd = prev.speechd.override {
          withLibao = false;
          withFlite = false;
          withEspeak = false;
          withPico = false;
        };
      })
    ];
  };

  programs = {
    uwsm = {
      enable = true;
      waylandCompositors.hyprland = {
        binPath = "/etc/profiles/per-user/tarxz/bin/Hyprland";
        comment = "Hyprland session managed by uwsm";
        prettyName = "Hyprland";
      };
    };

    zsh = {
      enable = true;
      enableLsColors = false;
      enableGlobalCompInit = false;
      promptInit = "";
    };
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

    kmscon = {
      enable = true;
      hwRender = true;
      extraConfig = "font-size=16";
      extraOptions = "--term xterm-256color";
    };
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${lib.getExe pkgs.greetd.tuigreet} --time --user-menu";
          user = "greeter";
        };
      };
    };
    fprintd.enable = false; # Disable until https://gitlab.freedesktop.org/libfprint/libfprint/-/issues/401 gets fixed
    fwupd.enable = true;

    dbus = {
      enable = true;
      implementation = "broker";
    };

    udisks2.enable = true;
    fstrim.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };

  systemd = {
    sockets.rfkill.enable = false;
    services = {
      "systemd-backlight@".enable = false;
      "mount-pstore".enable = false;
      audit.enable = false;
      rfkill.enable = false;

      pci-latency = {
        enable = true;
        description = "PCI Latency";
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "oneshot";
        script = ''
          ${lib.getExe' pkgs.pciutils "setpci"} -v -s '*:*' latency_timer=20
          ${lib.getExe' pkgs.pciutils "setpci"} -v -s '0:0' latency_timer=0
          ${lib.getExe' pkgs.pciutils "setpci"} -v -d "*:*:04xx" latency_timer=80
        '';
      };
    };
  };

  security = {
    polkit.enable = true;
    pam.services.hyprlock = { };

    rtkit.enable = true;
  };

  system.stateVersion = "23.05";

  hardware = {
    firmware = [ pkgs.linux-firmware ];
    enableRedistributableFirmware = false;
    cpu.intel.updateMicrocode = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vpl-gpu-rt
      ];
      enable32Bit = true;
    };

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
