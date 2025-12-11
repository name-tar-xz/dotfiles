{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = with inputs; [
    home-manager.nixosModules.home-manager
    catppuccin.nixosModules.catppuccin
    sops-nix.nixosModules.sops

    ../audio.nix
    ../intel.nix
    ../nvidia.nix
    ../games.nix
    ../perf.nix
    ../fonts.nix
  ];

  boot = {
    initrd = {
      systemd.enable = true;
      includeDefaultModules = false;
    };
    kernelParams = [
      "nvme.noacpi=1"
      "plymouth.use-simpledrm"
    ];
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto; # lqx xanmod xanmod_latest xanmod_stable zen
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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.tarxz = import ../../hm;
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

    inputs.nix-cachyos-kernel.overlays.default

    (_: prev: {
      firefox = prev.firefox.override {
        cfg = {
          speechSynthesisSupport = false;
          pipewireSupport = true;
        };
      };

      ani-skip = prev.ani-skip.overrideAttrs { passthru.scriptName = "skip"; };

      rofi-systemd = prev.rofi-systemd.overrideAttrs (old: {
        installPhase = old.installPhase + "sed 's/sudo //g' -i $out/bin/rofi-systemd";
      });

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
    fstrim.enable = true;
  };

  systemd = {
    enableEmergencyMode = false;
    suppressedSystemUnits = [ "systemd-backlight@.service" ];
    services.audit.enable = false;
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
