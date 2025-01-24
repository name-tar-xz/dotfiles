{
  config,
  pkgs,
  inputs,
  ...
}:
{
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
      "net.core.netdev_max_backlog" = 4096;
      "net.ipv4.tcp_ecn" = 1;
      "net.ipv4.tcp_slow_start_after_idle" = 0;
      "net.ipv4.tcp_rfc1337" = 1;
      "fs.file-max" = 2097152;
      "kernel.core_pattern" = "/dev/null";
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
      # Gaming
      "vm.compaction_proactiveness" = 0;
      "vm.page_lock_unfairness" = 1;

      "net.core.default_qdisc" = "cake";
    };

    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "systemd.show_status=auto"
      "udev.log_level=3"

      "zswap.enabled=0"

      "tsc=reliable"
      "clocksource=tsc"

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
            publicKey = "jDrSMRMm6XJgYGcSd01QqJbYiW13dyaOKp8GWDs0rTQ=";
            endpoint = "185.177.125.173:51820";
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
      shell = pkgs.zsh;
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
    gc = {
      automatic = false;
      options = "--delete-older-than 7d";
    };
  };

  environment = {
    systemPackages = with pkgs; [ git ];
    binsh = "${pkgs.lib.getExe pkgs.dash}";
  };

  programs = {
    zsh = {
      enable = true;
      enableLsColors = false;
      enableGlobalCompInit = false;
      promptInit = "";
    };
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

    syncthing = {
      enable = true;
      openDefaultPorts = true;
      overrideDevices = true;
      overrideFolders = true;
      relay.enable = false;
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

    resolved = {
      enable = true;
      dnssec = "true";
      dnsovertls = "true";
    };
    journald.extraConfig = "SystemMaxUse=100M";

    thermald.enable = true;
    bpftune.enable = true;

    auto-cpufreq = {
      enable = true;
      settings = {
        charger = {
          governor = "performance";
          energy_performance_preference = "performance";
          energy_perf_bias = "balance_performance";
          platform_profile = "balanced"; # Setting to performance ramps fans
          turbo = "always";
        };
        battery = {
          governor = "powersave";
          energy_performance_preference = "power";
          energy_perf_bias = "balance_power";
          platform_profile = "quiet";
          turbo = "never";
        };
      };
    };

    udev.extraRules = # udev
      ''
        # CachyOS
        # PCI runtime power management
        ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"

        # USB autosuspend
        ACTION=="add", SUBSYSTEM=="usb", ATTR{power/control}="auto"
        ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend", ATTR{power/autosuspend}="60"

        # HDD
        ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

        # SSD
        ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"

        # NVMe SSD
        ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"

        # Audio Latency
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"

        # Nvidia
        # Enable runtime PM for NVIDIA VGA/3D controller devices on driver bind
        ACTION=="add|bind", SUBSYSTEM=="pci", DRIVERS=="nvidia", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", TEST=="power/control", ATTR{power/control}="auto"

        # Disable runtime PM for NVIDIA VGA/3D controller devices on driver unbind
        ACTION=="remove|unbind", SUBSYSTEM=="pci", DRIVERS=="nvidia", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", TEST=="power/control", ATTR{power/control}="on"

        # Clear Linux
        ACTION=="add|change", SUBSYSTEM=="block", ATTR{queue/rotational}=="0", KERNEL=="nvme?n?", ATTR{queue/nr_requests}="2048"
      '';
  };

  powerManagement.scsiLinkPolicy = "med_power_with_dipm";

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

    network = {
      wait-online.enable = false;
      links."30-mtu" = {
        matchConfig.Type = "wlan";
        linkConfig = {
          MTUBytes = 1492;
          TransmitQueueLength = 2000;
        };
      };
    };

    tmpfiles.rules = [
      "w! /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
      "w! /sys/kernel/mm/transparent_hugepage/shmem_enabled - - - - advise"
      "w! /sys/kernel/mm/lru_gen/enabled - - - - 5"
      "w! /sys/kernel/mm/transparent_hugepage/khugepaged/scan_sleep_millisecs - - - - 30000"
      "w! /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none - - - - 409"
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
