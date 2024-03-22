{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
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
    config.allowUnfree = true;
    overlays = with inputs; [
      neovim-nightly-overlay.overlay
      (final: prev: { librewolf = prev.librewolf.override { cfg.speechSynthesisSupport = false; }; })
    ];
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
    nix-ld.enable = true;
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
      gamescopeSession.enable = true;
    };
  };

  services = {
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
    btrfs.autoScrub.enable = true;

    psd.enable = true;

    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      # jack.enable = true;
    };
    udev.extraRules = # udev
      ''
        ACTION=="add", SUBSYSTEM=="hwmon", KERNEL=="hwmon[0-9]", TEST=="pwm1_enable", ATTR{pwm1_enable}="0"
        ACTION=="add", SUBSYSTEM=="hwmon", KERNEL=="hwmon[0-9]", TEST=="pwm2_enable", ATTR{pwm2_enable}="0"
      '';
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

    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        (intel-vaapi-driver.override { enableHybridCodec = true; }) # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
      driSupport = true;
      driSupport32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      dynamicBoost.enable = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      open = false;
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
