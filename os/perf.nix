{ pkgs, ... }:
{
  boot = {
    kernelParams = [
      "zswap.enabled=0"
      "noresume" # zram makes hibernation impossible anyway

      "tsc=reliable"
      "clocksource=tsc"

      "nowatchdog"
      "rcutree.enable_rcu_lazy=1"
      "rcu_nocbs=all"
      "mem_sleep_default=deep"
      "cpuidle.governor=teo"
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
        "kernel.nmi_watchdog" = 0;
        "kernel.split_lock_mitigate" = 0;
        "kernel.unprivileged_userns_clone" = 1;
        "net.core.busy_poll" = 50;
        "net.core.busy_read" = 50;
        "net.core.default_qdisc" = "cake";
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_ecn" = 1; # ?
        "net.ipv4.tcp_fin_timeout" = 5;
        "net.ipv4.tcp_slow_start_after_idle" = 0; # ?
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
              max_ptes_none = 512 * 80 / 100;
            };
          };

          ksm = {
            run = 1;
            pages_to_scan = 1000;
            sleep_millisecs = 4000;
          };

          lru_gen.enabled = 7;
        };
        class.rtc.rtc0.max_user_freq = 3072;
      };
    };

    kernelModules = [ "ntsync" ];
  };

  services = {
    udev.extraRules = /* udev */ ''
      SUBSYSTEM=="block", ACTION=="add|change", TEST=="queue/nr_requests", KERNEL=="nvme[0-9]*", ATTR{queue/nr_requests}="2048"

      # Disk power management
      ACTION=="add", SUBSYSTEM=="block", TEST=="power/control", ATTR{power/control}="auto"

      # CachyOS
      # PCI runtime power management
      ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"

      # USB autosuspend
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend", ATTR{power/autosuspend}="60"
    '';

    bpftune.enable = true;
    irqbalance.enable = true;
    thermald.enable = true;

    scx-loader = {
      enable = true;
      schedsPackages = [ pkgs.scx.rustscheds ];
      config = {
        default_sched = "scx_lavd";
        scheds = {
          scx_lavd.auto_mode = [ "--autopower" ];
          scx_cosmos.auto_mode = [
            "--mm-affinity"
            "--flat-idle-scan"
          ];
        };
      };
    };

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

    tuned = {
      enable = true;
      settings.dynamic_tuning = true;

      ppdSettings = {
        profiles = {
          balanced = "default";
          performance = "perf";
          power-saver = "bat";
        };
        main.default = "balanced";
        battery.balanced = "default";
      };

      profiles = {
        default = {
          cpu = {
            governor = "schedutil|ondemand|powersave";
            energy_perf_bias = "normal";
            energy_performance_preference = "balance_power";
            boost = 1;
          };
          sysfs = {
            "/sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost" = 1;
            "/sys/module/pcie_aspm/parameters/policy" = "default";
          };
          audio.timeout = 1;
          disk.readahead = ">4096";
          acpi.platform_profile = "balanced";
          scsi_host.alpm = "med_power_with_dipm";
        };

        perf = {
          main.include = "default";
          cpu = {
            governor = "performance";
            energy_perf_bias = "performance";
            energy_performance_preference = "performance";
          };
          sysfs."/sys/module/pcie_aspm/parameters/policy" = "performance";
          scsi_host.alpm = "max_performance";
        };

        bat = {
          main.include = "default";
          cpu = {
            energy_perf_bias = "powersave|power";
            energy_performance_preference = "power";
            boost = 0;
          };
          sysfs = {
            "/sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost" = 0;
            "/sys/module/pcie_aspm/parameters/policy" = "powersupersave";
          };
          acpi.platform_profile = "low-power|quiet";
        };
      };
    };

    upower.noPollBatteries = true;
  };

  systemd = {
    settings.Manager.DefaultLimitNOFILE = "2048:2097152";
    services = {
      greetd.serviceConfig.MemoryKSM = true;
      "getty@".serviceConfig.MemoryKSM = true;
      "user@".serviceConfig.MemoryKSM = true;

      pci-latency = {
        enable = true;
        description = "PCI Latency";
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "oneshot";
        script = with pkgs; ''
          ${lib.getExe' pciutils "setpci"} -v -s '*:*' latency_timer=20
          ${lib.getExe' pciutils "setpci"} -v -s '0:0' latency_timer=0
          ${lib.getExe' pciutils "setpci"} -v -d "*:*:04xx" latency_timer=80
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
    {
      domain = "@wheel";
      type = "soft";
      item = "nofile";
      value = 524288;
    }
    {
      domain = "@wheel";
      type = "hard";
      item = "nofile";
      value = 1048576;
    }
  ];

  hardware.block = {
    defaultScheduler = "adios";
    defaultSchedulerRotational = "adios";
    scheduler."nvme[0-9]*" = "adios";
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
}
