{ config, pkgs, lib, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    inputs.chaotic.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];

  boot = {
    tmp.useTmpfs = true;
    plymouth.enable = true;
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
    kernel.sysctl = {
      # CachyOS
      # "vm.swappiness" = 20;
      "vm.vfs_cache_pressure" = 50;
      # "vm.dirty_bytes" = 268435456;
      "vm.page-cluster" = 0;
      # "vm.dirty_background_bytes" = 134217728;
      "vm.dirty_writeback_centisecs" = 1500;
      "vm.max_map_count" = 2147483642;
      "kernel.nmi_watchdog" = 0;
      "kernel.unprivileged_userns_clone" = 1;
      "kernel.printk" = "3 3 3 3";
      "kernel.kptr_restrict" = 2;
      "kernel.kexec_load_disabled" = 1;
      "net.core.somaxconn" = 8192;
      "net.core.netdev_max_backlog" = 16384;
      "net.ipv4.tcp_ecn" = 1;
      "net.ipv4.tcp_slow_start_after_idle" = 0;
      "net.ipv4.tcp_timestamps" = 0;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.tcp_rfc1337" = 1;
      "fs.inotify.max_user_watches" = 524288;
      "fs.file-max" = 2097152;
      "fs.xfs.xfssyncd_centisecs" = 10000;
      "kernel.core_pattern" = "/dev/null";
      "kernel.sched_rt_runtime_us" = 980000;
      "kernel.split_lock_mitigate" = 0;
      "dev.hpet.max-user-freq" = 3072;
      # Clear Linux
      "vm.dirty_ratio" = 50;
      "vm.dirty_background_ratio" = 5;
      "vm.extfrag_threshold" = 100;
      "kernel.unprivileged_bpf_disabled" = 1;
      "net.core.busy_poll" = 50;
      "net.core.busy_read" = 50;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      # Zram
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
    };
    consoleLogLevel = 3;
    kernelParams = [ "quiet" "systemd.show_status=auto" "udev.log_level=3" "nowatchdog" ];
    kernelPackages = pkgs.linuxPackages_cachyos;

    extraModprobeConfig = ''
      # Audio powersaving
      # For AC97 cards:
      options snd_ac97_codec power_save=1
      # For HD audio cards:
      options snd_hda_intel power_save=1

      # Nvidia
      # options nvidia NVreg_UsePageAttributeTable=1 NVreg_InitializeSystemMemoryAllocations=0 NVreg_DynamicPowerManagement=0x02
      # options nvidia_drm modeset=1 fbdev=1

      # Blacklist the Intel TCO Watchdog/Timer module
      blacklist iTCO_wdt

      # Blacklist the AMD SP5100 TCO Watchdog/Timer module (Required for Ryzen cpus)
      blacklist sp5100_tco
    '';
  };

  networking = {
    hostName = "nixos"; # Define your hostname.
    hostFiles = [ inputs.hblock ];

    useNetworkd = true;
    wireless.iwd = {
      enable = true;
      settings = {
        General = { AddressRandomization = "network"; };
        Settings = {
          AutoConnect = true;
          AlwaysRandomizeAddress = true;
        };
      };
    };
    firewall = {
      enable = false;
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPortRanges = [
        {
          from = 4000;
          to = 4007;
        }
        {
          from = 8000;
          to = 8010;
        }
      ];
      # extraCommands = "iptables -A INPUT -p icmp -j ACCEPT";
    };

    wg-quick.interfaces = {
      /* wg0 = {
        address = [ "10.2.0.2/32" ];
        privateKey = "***REMOVED***";
        peers = [{
          allowedIPs = [ "0.0.0.0/0" ];
          publicKey = "jDrSMRMm6XJgYGcSd01QqJbYiW13dyaOKp8GWDs0rTQ=";
          endpoint = "185.177.125.172:51820";
        }];
      }; */
      wg0 = {
        address = [ "10.2.0.2/32" ];
        privateKey = "***REMOVED***";
        peers = [{
          allowedIPs = [ "0.0.0.0/0" ];
          publicKey = "nsQBMSreq3f0B/BvRRL2aZtuvFAahf7TECaKpbooZVw=";
          endpoint = "149.34.244.134:51820";
        }];
      };
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LANGUAGE = "en_US.UTF-8";
      LC_ADDRESS = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  users.users.***REMOVED*** = {
    isNormalUser = true;
    description = "***REMOVED***";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" ];
    shell = pkgs.dash;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.***REMOVED*** = import ./home.nix;
    extraSpecialArgs = { inherit inputs; };
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ inputs.neovim-nightly-overlay.overlay ];
  };

  environment = {
    systemPackages = with pkgs;[
      git
    ];

    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.local/cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };

    etc = {
      "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = /* lua */ ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '';
    };

    binsh = "${pkgs.dash}/bin/dash";
  };

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      withRuby = false;
      withNodeJs = false;
    };

    zsh = {
      enable = true;
      enableLsColors = false;
      enableCompletion = false;
      promptInit = "";
    };

    ssh.package = pkgs.openssh_hpn;
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
      dirmngr.enable = true;
    };
    dconf.enable = true;

    steam = {
      enable = false;
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
    fstrim.enable = true;

    psd.enable = true;
    auto-cpufreq = {
      enable = false;
      settings = {
        charger = {
          governor = "powersave";
          turbo = "auto";
        };
        battery = {
          governor = "powersave";
          turbo = "auto";
        };
      };
    };
    thermald.enable = true;
    irqbalance.enable = false;
    bpftune.enable = true;
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-cpp-rules;
    };
    undervolt = {
      enable = true;
      temp = 88;
      useTimer = true;
    };

    resolved = {
      enable = true;
      extraConfig = ''
        DNS=45.90.28.0#VivobookPro14-***REMOVED***.dns.nextdns.io
        FallbackDNS=2a07:a8c0::#VivobookPro14-***REMOVED***.dns.nextdns.io
        DNS=45.90.30.0#VivobookPro14-***REMOVED***.dns.nextdns.io
        FallbackDNS=2a07:a8c1::#VivobookPro14-***REMOVED***.dns.nextdns.io
        DNSOverTLS=yes
        DNSSEC=yes
        MulticastDNS=yes
        Cache=yes
        ReadEtcHosts=yes
      '';
    };

    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      # jack.enable = true;
    };

    udev.extraRules = /* udev */ ''
      # CachyOS
      # PCI runtime power management
      ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"

      # USB autosuspend
      ACTION=="add", SUBSYSTEM=="usb", ATTR{power/control}="auto"
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend" ATTR{power/autosuspend}="60"

      # SATA active link power management
      ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="min_power"
      # ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="max_performance"

      # Wlan power save
      ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan*" RUN+="${pkgs.iw}/bin/iw dev %k set power_save on"

      # Disable bluetooth
      # SUBSYSTEM=="rfkill", ATTR{type}=="bluetooth", ATTR{state}="0" #Destroys CPU

      # Disable wake-on-LAN
      ACTION=="add", SUBSYSTEM=="net", KERNEL=="eth*" RUN+="${pkgs.ethtool}/bin/ethtool -s %k wol d"

      # HDD
      ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
      
      # SSD
      ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"
      
      # NVMe SSD
      ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"

      # Audio Latency
      KERNEL=="rtc0", GROUP="audio"
      KERNEL=="hpet", GROUP="audio"

      # Clear Linux
      ACTION=="add|change", SUBSYSTEM=="block", ATTR{queue/rotational}=="0", KERNEL=="nvme?n?", ATTR{queue/add_random}="1"
      ACTION=="add|change", SUBSYSTEM=="block", ATTR{queue/rotational}=="0", KERNEL=="nvme?n?", ATTR{queue/nr_requests}="2048"

      # Custom
      # Set MTU and Transmit Queue Length
      # MTU set to 1492 as wifi is PPPoE
      ACTION=="add", SUBSYSTEM=="net", KERNEL=="wl*", ATTR{mtu}="1492", ATTR{tx_queue_len}="2000"

      ACTION=="add", SUBSYSTEM=="hwmon", KERNEL=="hwmon[0-9]", TEST=="pwm1_enable", ATTR{pwm1_enable}="0"
      ACTION=="add", SUBSYSTEM=="hwmon", KERNEL=="hwmon[0-9]", TEST=="pwm2_enable", ATTR{pwm2_enable}="0"
    '';

    terraria = {
      enable = false;
      openFirewall = true;
      maxPlayers = 8;
      autoCreatedWorldSize = "small";
    };
  };

  systemd = {
    oomd.enable = lib.mkForce true;
    extraConfig = "DefaultTimeoutStopSec=10s";

    network.wait-online.enable = false;

    tmpfiles.rules = [
      "w! /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
      "w! /sys/kernel/mm/transparent_hugepage/khugepaged/scan_sleep_millisecs - - - - 30000"
      "w! /sys/kernel/mm/ksm/pages_to_scan - - - - 1000"
      "w! /sys/kernel/mm/ksm/sleep_millisecs - - - - 4000"
      "w! /sys/class/rtc/rtc0/max_user_freq - - - - 3072"
    ];

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
    xdgOpenUsePortal = true;
    extraPortals = with pkgs;[ xdg-desktop-portal-hyprland xdg-desktop-portal-gtk ];
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [ "hyprland" "gtk" ];
    };
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
        {
          users = [ "***REMOVED***" ];
          cmd = "nixos-rebuild";
          noPass = true;
          setEnv = [ "LOCALE_ARCHIVE=/run/current-system/sw/lib/locale/locale-archive" ];
        }
      ];
    };
    polkit.enable = true;
    pam.services.swaylock = { text = "auth include login"; };

    rtkit.enable = true;
  };

  system.autoUpgrade = { enable = true; };

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
      settings = { General = { ControllerMode = "bredr"; }; };
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  fonts = {
    enableDefaultPackages = false;
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Sans" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "Cascadia Code" ];
        emoji = [ "Segoe UI Emoji" ];
      };
      includeUserConf = true;
      antialias = true;
      subpixel.rgba = "none";
      hinting = {
        enable = false;
        style = "none";
      };
    };
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "NerdFontsSymbolsOnly" ]; })
      (iosevka-bin.override { variant = "sgr-iosevka-term"; })
      cascadia-code
      dejavu_fonts
      gyre-fonts # TrueType substitutes for standard PostScript fonts
      jetbrains-mono
      liberation_ttf
      noto-fonts
      noto-fonts-cjk
      roboto
    ];
  };

  virtualisation = {
    docker.enable = false;
    waydroid.enable = false;
  };

  chaotic.steam.extraCompatPackages = with pkgs; [ proton-ge-custom ];
}
