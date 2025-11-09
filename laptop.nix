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
    catppuccin.nixosModules.catppuccin
    sops-nix.nixosModules.sops

    ./nix/os
    ./nix/os/laptop-hardware.nix

    ./nix/os/intel.nix
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
    kernelParams = [ "nvme.noacpi=1" ];
    kernelPackages = pkgs.linuxPackages_cachyos-lto; # lqx xanmod xanmod_latest xanmod_stable zen
    supportedFilesystems = [ "btrfs" ];

    loader = {
      systemd-boot.enable = lib.mkForce false;
      limine = {
        enable = true;
        secureBoot.enable = true;
        style.wallpapers = [ ];
        extraConfig = ''
          timeout: 1
          quiet: yes
        '';
      };
    };
  };

  console.earlySetup = true;

  networking.hostName = "laptop";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.tarxz = import ./home.nix;
    extraSpecialArgs = { inherit inputs; };
    sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
  };

  system.replaceDependencies.replacements = [
    {
      oldDependency = pkgs.networkmanager;
      newDependency = pkgs.runCommand "networkmanager-${pkgs.networkmanager.version}" { } "mkdir -p $out";
    }
  ];

  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlays.default
    inputs.nvim-treesitter-main.overlays.default
    (final: prev: {
      firefox = prev.firefox.override { cfg.speechSynthesisSupport = false; };

      ani-skip = prev.ani-skip.overrideAttrs (old: {
        passthru.scriptName = "skip";
      });

      rofi-systemd = prev.rofi-systemd.overrideAttrs (old: {
        installPhase = old.installPhase + "sed 's/sudo //g' -i $out/bin/rofi-systemd";
      });

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
        withPulse = false;
        withAlsa = false;
        withOss = false;
        withFlite = false;
        withEspeak = false;
        withPico = false;
        libsOnly = true;
      };
    })
  ];

  programs = {
    adb.enable = true;
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
          command = "${lib.getExe pkgs.tuigreet} --time --user-menu";
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
    enableEmergencyMode = false;
    suppressedSystemUnits = [ "systemd-backlight@.service" ];
    services = {
      audit.enable = false;

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

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [
        "hyprland"
        "gtk"
      ];
    };
  };

  security = {
    polkit.enable = true;
    pam.services.hyprlock = { };
    loginDefs.settings.UMASK = "022";

    wrappers.btop = {
      owner = "root";
      group = "root";
      source = "${pkgs.btop}/bin/btop";
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
