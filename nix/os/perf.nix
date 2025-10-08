{ pkgs, ... }:
{
  boot = {
    kernelParams = [
      "zswap.enabled=0"

      "tsc=reliable"
      "clocksource=tsc"
    ];

    kernel = {
      sysctl."vm.swappiness" = 180;
      sysfs.kernel.mm = {
        transparent_hugepage = {
          enabled = "always";
          defrag = "defer+madvise";
          shmem_enabled = "advise";

          khugepaged = {
            scan_sleep_millisecs = 30000;
            max_ptes_none = 409;
          };
        };

        ksm = {
          pages_to_scan = 1000;
          sleep_millisecs = 4000;
        };

        lru_gen.enabled = 5;
      };
    };

    kernelModules = [ "ntsync" ];
  };

  services = {
    udev.extraRules = ''KERNEL=="ntsync", MODE="0660", TAG+="uaccess"'';

    bpftune.enable = true;

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
        cgroup_realtime_workaround = pkgs.lib.mkForce false;
      };
    };
  };

  systemd.tmpfiles.rules = [
    "w! /sys/class/rtc/rtc0/max_user_freq - - - - 3072"
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
}
