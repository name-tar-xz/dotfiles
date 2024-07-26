{ config, pkgs, ... }:
{
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
      "vm.vfs_cache_pressure" = 50;
      "vm.page-cluster" = 0;
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
      "vm.dirty_background_ratio" = 20;
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
      # Gaming
      "vm.compaction_proactiveness" = 0;
      "vm.page_lock_unfairness" = 1;
    };

    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "systemd.show_status=auto"
      "udev.log_level=3"
      "nowatchdog"
      "rcutree.enable_rcu_lazy=1"
    ];

    blacklistedKernelModules = [
      "iTCO_wdt"
      "sp5100_tco"
    ];
    extraModprobeConfig = ''
      # Audio powersaving
      options snd_ac97_codec power_save=1
      options snd_hda_intel power_save=1
      options iwlwifi power_save=1

      options nvidia NVreg_UsePageAttributeTable=1 NVreg_InitializeSystemMemoryAllocations=0
      options nvidia_drm modeset=1
    '';
  };

  networking = {
    firewall = {
      enable = false;
      allowedTCPPorts = [
        80
        443
      ];
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
      wg0 = {
        autostart = false;
        address = [ "10.2.0.2/32" ];
        privateKeyFile = config.sops.secrets.wg.path;
        peers = [
          {
            allowedIPs = [ "0.0.0.0/0" ];
            publicKey = "nsQBMSreq3f0B/BvRRL2aZtuvFAahf7TECaKpbooZVw=";
            endpoint = "149.34.244.134:51820";
          }
        ];
      };
    };
  };

  # Set your time zone.
  time = {
    timeZone = "Asia/Kolkata";
    hardwareClockInLocalTime = true;
  };

  # Select internationalisation properties.
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
    settings = {
      use-xdg-base-directories = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "cgroups"
      ];
      auto-optimise-store = true;
      trusted-users = [ "@wheel" ];
      use-cgroups = true;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  environment = {
    systemPackages = with pkgs; [ git ];
    binsh = "${pkgs.dash}/bin/dash";
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
  };

  services = {
    tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tailscale.path;
    };

    syncthing = {
      enable = true;
      openDefaultPorts = true;
      overrideDevices = true;
      overrideFolders = true;
      relay.enable = true;
      settings = {
        gui = {
          theme = "black";
        };
        options = {
          relaysEnabled = true;
          urAccepted = -1;
        };
        devices = {
          F13.id = "PZ5ZLDN-JGGKAXL-2YRWHGA-Q5KZT6U-2IMCA2E-V5GCFWX-76PXM5B-3HTEBQD";
          laptop.id = "Z2NATQ7-GOXCMGJ-EJD6VEJ-GLDAZRD-VJU2RMX-AVGB72V-AJZOFUI-WVJUXAM";
        };
        folders = {
          ROMS = {
            path = "~/Games/ROMS";
            devices = [
              "F13"
              "laptop"
            ];
            versioning.type = "simple";
          };
          Saves = {
            path = "~/.config/retroarch/saves";
            devices = [
              "F13"
              "laptop"
            ];
            versioning.type = "simple";
          };
          States = {
            path = "~/.config/retroarch/states";
            devices = [
              "F13"
              "laptop"
            ];
            versioning.type = "simple";
          };
          Previews = {
            path = "~/.config/retroarch/state-previews";
            devices = [
              "F13"
              "laptop"
            ];
            versioning.type = "simple";
          };
        };
      };
    };

    fstrim.enable = true;

    tlp = {
      enable = true;
      settings = {
        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth wifi wwan";
        NMI_WATCHDOG = 0;
        DISK_IOSCHED = "keep keep";

        # CHECK AGAIN
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        # CHECK AGAIN
        MEM_SLEEP_ON_AC = "deep";
        MEM_SLEEP_ON_BAT = "deep";

        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";
        AHCI_RUNTIME_PM_ON_AC = "auto";
        AHCI_RUNTIME_PM_ON_BAT = "auto";

        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        # CHECK AGAIN
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;

        # CHECK AGAIN
        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersupersave";

        # CHECK AGAIN
        SATA_LINKPWR_ON_AC = "max_performance";
        SATA_LINKPWR_ON_BAT = "min_power";

        MAX_LOST_WORK_SECS_ON_BAT = 15;
        MAX_LOST_WORK_SECS_ON_AC = 15;

        # CHECK AGAIN
        WIFI_PWR_ON_AC = "on";
        WIFI_PWR_ON_BAT = "on";

        USB_AUTOSUSPEND = 1;
      };
    };

    resolved = {
      enable = true;
      dnssec = "true";
      dnsovertls = "true";
    };
    journald.extraConfig = "SystemMaxUse=100M";

    udev.extraRules = # udev
      ''
        # CachyOS
        # PCI runtime power management
        ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"

        # USB autosuspend
        ACTION=="add", SUBSYSTEM=="usb", ATTR{power/control}="auto"
        ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend" ATTR{power/autosuspend}="60"

        # HDD
        ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

        # SSD
        ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*|nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"

        # Audio Latency
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"

        # Clear Linux
        ACTION=="add|change", SUBSYSTEM=="block", ATTR{queue/rotational}=="0", KERNEL=="nvme?n?", ATTR{queue/nr_requests}="2048"

        # Custom
        # Set MTU and Transmit Queue Length
        ACTION=="add", SUBSYSTEM=="net", KERNEL=="wl*", ATTR{mtu}="1500", ATTR{tx_queue_len}="2000"
      '';
  };

  systemd = {
    enableCgroupAccounting = true;
    enableUnifiedCgroupHierarchy = true;
    extraConfig = ''
      DefaultTimeoutStopSec=10s
      DefaultTimeoutStartSec=15s
      DefaultLimitNOFILE=2048:2097152
    '';

    network.wait-online.enable = false;

    tmpfiles.rules = [
      "w! /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
      "w! /sys/kernel/mm/transparent_hugepage/shmem_enabled - - - - advise"
      "w! /sys/kernel/mm/lru_gen/enabled - - - - 5"
      "w! /sys/kernel/mm/transparent_hugepage/khugepaged/scan_sleep_millisecs - - - - 30000"
      "w! /sys/kernel/mm/ksm/pages_to_scan - - - - 1000"
      "w! /sys/kernel/mm/ksm/sleep_millisecs - - - - 4000"
      "w! /sys/class/rtc/rtc0/max_user_freq - - - - 3072"
    ];
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
          users = [ "tarxz" ];
          cmd = "nixos-rebuild";
          noPass = true;
          setEnv = [ "LOCALE_ARCHIVE=/run/current-system/sw/lib/locale/locale-archive" ];
        }
      ];
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/var/lib/age.txt";

    templates.resolved = {
      content = ''
        [Resolve]
        DNS=45.90.28.0#${config.networking.hostName}-${config.sops.placeholder.nextdns}.dns.nextdns.io
        FallbackDNS=2a07:a8c0::#${config.networking.hostName}-${config.sops.placeholder.nextdns}.dns.nextdns.io
        DNS=45.90.30.0#${config.networking.hostName}-${config.sops.placeholder.nextdns}.dns.nextdns.io
        FallbackDNS=2a07:a8c1::#${config.networking.hostName}-${config.sops.placeholder.nextdns}.dns.nextdns.io
      '';
      path = "/etc/systemd/resolved.conf.d/dns.conf";
      mode = "0444";
    };

    secrets = {
      wg = { };
      tailscale = { };
      nextdns.mode = "0444";
    };
  };
}
