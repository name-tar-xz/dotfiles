{
  config,
  pkgs,
  inputs,
  ...
}:
{
  boot = {
    kernelParams = [
      "nvme.noacpi=1"
      "gather_data_sampling=off"
    ];
    supportedFilesystems = [ "bacachefs" ];
    kernelPackages = pkgs.linuxPackages_cachyos-lto; # lqx xanmod xanmod_latest xanmod_stable zen

    loader.systemd-boot.enable = pkgs.lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    extraModprobeConfig = ''
      options nvidia NVreg_UsePageAttributeTable=1 NVreg_InitializeSystemMemoryAllocations=0
      options nvidia_drm modeset=1 fbdev=1
    '';
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
    extraSpecialArgs = {
      inherit inputs;
    };
    sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
  };

  nixpkgs = {
    overlays = [
      (final: prev: {
        librewolf = prev.librewolf.override { cfg.speechSynthesisSupport = false; };
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
        lutris = prev.lutris.override {
          extraPkgs = pkgs: with pkgs; [ wineWowPackages.waylandFull ];
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

    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
    gamemode = {
      enable = true;
      enableRenice = false;
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
    psd.enable = true;
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
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --user-menu";
          user = "greeter";
        };
      };
    };
    fprintd.enable = false; # Disable until https://gitlab.freedesktop.org/libfprint/libfprint/-/issues/401 gets fixed
    fwupd.enable = true;

    thermald.enable = true;
    bpftune.enable = true;
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
      settings = {
        apply_latnice = true;
        check_freq = 15;
        cgroup_realtime_workaround = pkgs.lib.mkForce false;
      };
    };

    xserver.videoDrivers = [ "nvidia" ];
    dbus = {
      enable = true;
      implementation = "broker";
    };

    udisks2.enable = true;
    btrfs.autoScrub.enable = false;
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
    services = {
      "systemd-backlight@".enable = false;
      pci-latency = {
        enable = true;
        description = "PCI Latency";
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "oneshot";
        script = ''
          ${pkgs.pciutils}/bin/setpci -v -s '*:*' latency_timer=20
          ${pkgs.pciutils}/bin/setpci -v -s '0:0' latency_timer=0
          ${pkgs.pciutils}/bin/setpci -v -d "*:*:04xx" latency_timer=80
        '';
      };
    };

    user.services.lxqt-policykit-agent = {
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

  system.stateVersion = "23.05";

  hardware = {
    firmware = with pkgs; [ linux-firmware ];
    enableRedistributableFirmware = false;
    cpu.intel.updateMicrocode = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vpl-gpu-rt
        nvidia-vaapi-driver
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
      users = [ "@wheel" ];
    };
  };

  fonts = {
    enableDefaultPackages = false;
    fontconfig = {
      defaultFonts = {
        serif = [ "Inter" ];
        sansSerif = [ "Inter" ];
        monospace = [ "Iosevka Term" ];
      };
      includeUserConf = false;
      antialias = true;
      subpixel.rgba = "none";
      hinting = {
        enable = true;
        autohint = false;
        style = "slight";
      };
      localConf = # xml
        ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
          <fontconfig>
            <match target="font">
              <test name="fontformat" compare="not_eq">
                <string />
              </test>
              <test name="family">
                <string>Inter</string>
              </test>
              <edit name="fontfeatures" mode="assign_replace">
                <string>tnum</string>
              </edit>
              <edit name="fontfeatures" mode="append">
                <string>ss04</string>
              </edit>
            </match>
          </fontconfig>
        '';
    };
    packages = with pkgs; [
      nerd-fonts.symbols-only
      (iosevka-bin.override { variant = "SGr-IosevkaTerm"; })
      cascadia-code
      gyre-fonts # TrueType substitutes for standard PostScript fonts
      inter
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
    ];
  };
}
