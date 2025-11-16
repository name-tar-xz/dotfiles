{ pkgs, lib, ... }:
{
  boot = {
    kernelParams = [
      "zswap.enabled=0"

      "tsc=reliable"
      "clocksource=tsc"

      "nowatchdog"
      "rcutree.enable_rcu_lazy=1"
      "mem_sleep_default=deep"
    ];

    blacklistedKernelModules = [
      "iTCO_wdt"
      "sp5100_tco"
    ];

    kernel = {
      sysctl = {
        "dev.hpet.max-user-freq" = 3072;
        "fs.file-max" = 2097152;
        "fs.inotify.max_user_instances" = 8192;
        "fs.inotify.max_user_watches" = 524288;
        "kernel.core_pattern" = "/dev/null";
        "kernel.kexec_load_disabled" = 1;
        "kernel.nmi_watchdog" = 0;
        "kernel.printk" = "3 3 3 3";
        "kernel.split_lock_mitigate" = 0;
        "kernel.unprivileged_bpf_disabled" = 1;
        "kernel.unprivileged_userns_clone" = 1;
        "net.core.busy_poll" = 50;
        "net.core.busy_read" = 50;
        "net.core.default_qdisc" = "cake";
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_ecn" = 1;
        "net.ipv4.tcp_fin_timeout" = 5;
        "net.ipv4.tcp_slow_start_after_idle" = 0;
        "vm.compaction_proactiveness" = 0;
        "vm.dirty_background_bytes" = 67108864;
        "vm.dirty_bytes" = 268435456;
        "vm.dirty_writeback_centisecs" = 1500;
        "vm.extfrag_threshold" = 100;
        "vm.max_map_count" = 2147483642;
        "vm.overcommit_memory" = 1;
        "vm.page-cluster" = 0;
        "vm.page_lock_unfairness" = 1;
        "vm.swappiness" = 180;
        "vm.vfs_cache_pressure" = 50;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
      };

      sysfs = {
        kernel.mm = {
          transparent_hugepage = {
            enabled = "always";
            defrag = "defer+madvise";
            shmem_enabled = "advise";

            khugepaged = {
              scan_sleep_millisecs = 30000;
              max_ptes_none = 409;
            };
          };

          ksm.pages_to_scan = 1000;

          lru_gen.enabled = 5;
        };
        class.rtc.rtc0.max_user_freq = 3072;
      };
    };

    kernelModules = [ "ntsync" ];
  };

  services = {
    udev.extraRules = # udev
      ''
        SUBSYSTEM=="block", ACTION=="add|change", TEST=="queue/nr_requests", KERNEL=="nvme[0-9]*", ATTR{queue/nr_requests}="2048"

        # CachyOS
        # PCI runtime power management
        ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"

        # USB autosuspend
        ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
        ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend", ATTR{power/autosuspend}="60"
      '';

    bpftune.enable = true;

    thermald.enable = true;

    scx = {
      enable = true;
      scheduler = "scx_lavd";
      extraArgs = [ "--autopower" ];
      package = pkgs.scx.rustscheds;
    };

    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
      settings = {
        apply_latnice = true;
        check_freq = 15;
        cgroup_realtime_workaround = lib.mkForce false;
      };
    };

    tlp = {
      enable = true;
      settings = {
        NMI_WATCHDOG = 0;
        DISK_IOSCHED = "keep keep";

        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "low-power";

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

        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;

        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersupersave";

        SATA_LINKPWR_ON_AC = "max_performance";
        SATA_LINKPWR_ON_BAT = "min_power";

        USB_AUTOSUSPEND = 1;
      };
    };
  };

  systemd = {
    settings.Manager.DefaultLimitNOFILE = "2048:2097152";
    services = {
      "getty@".serviceConfig.MemoryKSM = true;
      "user@".serviceConfig.MemoryKSM = true;

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

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "hard";
      item = "memlock";
      value = 2147484;
    }
    {
      domain = "*";
      type = "soft";
      item = "memlock";
      value = 2147484;
    }
  ];

  hardware = {
    block = {
      defaultScheduler = "adios";
      defaultSchedulerRotational = "adios";
      scheduler."nvme[0-9]*" = "adios";
    };

    ksm = {
      enable = true;
      sleep = 4000;
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
}
