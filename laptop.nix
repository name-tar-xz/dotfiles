{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  boot = {
    kernelParams = [ "intel_iommu=igfx_off" ]; # fix DMAR and DRHD errors in log causing full load on 1 core by kworker/acpi_notfy
    supportedFilesystems = [ "bcachefs" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest; # lqx xanmod xanmod_latest xanmod_stable zen

    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
  networking.hostName = "laptop";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.tarxz = import ./home.nix;
    extraSpecialArgs = {
      inherit inputs;
    };
    sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
  };

  nixpkgs = {
    overlays = [
      (final: prev: { librewolf = prev.librewolf.override { cfg.speechSynthesisSupport = false; }; })
      (final: prev: {
        retroarch = prev.retroarch.override {
          cores = with pkgs.libretro; [
            gambatte
            mgba
            melonds
            picodrive
            pcsx-rearmed
            pcsx2
            ppsspp
          ];
        };
      })
    ];
    config.permittedInsecurePackages = [ "openssl-1.1.1w" ];
  };

  environment = {
    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.local/cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
  };

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      withPython3 = false;
      withRuby = false;
    };

    dconf.enable = true;

    steam = {
      enable = true;
      extraPackages = with pkgs; [ openssl_1_1 ];
      # extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
    gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          renice = 20;
          ioprio = 0;
          softrealtime = "on";
        };
      };
    };
    gamescope = {
      enable = true;
      capSysNice = false;
    };
  };

  services = {
    syncthing = {
      user = "tarxz";
      configDir = "/home/tarxz/.config/syncthing";
      dataDir = "/home/tarxz";
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --user-menu --cmd Hyprland";
          user = "greeter";
        };
      };
    };
    fprintd.enable = false; # Disable until https://gitlab.freedesktop.org/libfprint/libfprint/-/issues/401 gets fixed
    fwupd.enable = true;

    xserver.videoDrivers = [ "nvidia" ];
    flatpak.enable = true;
    dbus.enable = true;

    udisks2.enable = true;

    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };

  systemd.user.services.lxqt-policykit-agent = {
    enable = true;
    description = "LXQT Polkit Agent";
    wantedBy = [ "xdg-desktop-portal.service" ];
    wants = [ "xdg-desktop-portal.service" ];
    after = [ "xdg-desktop-portal.service" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = false;
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

    rtkit.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  hardware = {
    enableAllFirmware = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        (intel-vaapi-driver.override { enableHybridCodec = true; }) # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
      enable32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      dynamicBoost.enable = true;
      nvidiaPersistenced = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      open = true;
      nvidiaSettings = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        # Make sure to use the correct Bus ID values for your system!
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    bluetooth = {
      enable = true;
      settings.General = {
        ControllerMode = "bredr";
        Experimental = true;
      };
    };

    openrazer = {
      enable = true;
      users = [
        "tarxz"
        "@wheel"
      ];
    };
  };

  fonts = {
    enableDefaultPackages = false;
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Sans" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "Iosevka Term" ];
        emoji = [ "Segoe UI Emoji" ];
      };
      includeUserConf = true;
      antialias = true;
      subpixel.rgba = "rgb";
      hinting = {
        enable = false;
        style = "none";
      };
    };
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "NerdFontsSymbolsOnly"
        ];
      })
      (iosevka-bin.override { variant = "SGr-IosevkaTerm"; })
      cascadia-code
      dejavu_fonts
      gyre-fonts # TrueType substitutes for standard PostScript fonts
      liberation_ttf
      noto-fonts
      noto-fonts-cjk
      roboto
    ];
  };
}
