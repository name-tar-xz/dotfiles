{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = with inputs; [
    chaotic.nixosModules.default
    sops-nix.nixosModules.sops
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
    kernelParams = [
      "quiet"
      "systemd.show_status=auto"
      "udev.log_level=3"
      "nowatchdog"
    ];
    kernelPackages = pkgs.linuxPackages_cachyos;

    extraModprobeConfig = ''
      # Audio powersaving
      # For AC97 cards:
      options snd_ac97_codec power_save=1
      # For HD audio cards:
      options snd_hda_intel power_save=1

      # Blacklist the Intel TCO Watchdog/Timer module
      blacklist iTCO_wdt

      # Blacklist the AMD SP5100 TCO Watchdog/Timer module (Required for Ryzen cpus)
      blacklist sp5100_tco
    '';
  };

  networking = {
    hostFiles = [ inputs.hblock ];

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
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF8";

  users.users.tarxz = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "video"
    ];
    shell = pkgs.dash;
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
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

    btrfs.autoScrub.enable = true;
    fstrim.enable = true;

    auto-cpufreq = {
      enable = true;
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
    irqbalance.enable = true;
    bpftune.enable = true;
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-cpp-rules;
    };

    udev.extraRules = # udev
      ''
        # CachyOS
        # PCI runtime power management
        ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"

        # USB autosuspend
        ACTION=="add", SUBSYSTEM=="usb", ATTR{power/control}="auto"
        ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend" ATTR{power/autosuspend}="60"

        # SATA active link power management
        ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="med_power_with_dipm"

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
        ACTION=="add", SUBSYSTEM=="net", KERNEL=="wl*", ATTR{mtu}="1500", ATTR{tx_queue_len}="2000"

        ACTION=="add", SUBSYSTEM=="hwmon", KERNEL=="hwmon[0-9]", TEST=="pwm1_enable", ATTR{pwm1_enable}="0"
        ACTION=="add", SUBSYSTEM=="hwmon", KERNEL=="hwmon[0-9]", TEST=="pwm2_enable", ATTR{pwm2_enable}="0"
      '';
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
}
