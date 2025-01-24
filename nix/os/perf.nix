{ pkgs, ... }:
{
  boot = {
    kernelParams = [
      "zswap.enabled=0"

      "tsc=reliable"
      "clocksource=tsc"
    ];

    kernel.sysctl."vm.swappiness" = 180;

    kernelModules = [ "ntsync" ];
  };

  services = {
    bpftune.enable = true;

    scx = {
      enable = true;
      scheduler = "scx_bpfland";
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
    "w! /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
    "w! /sys/kernel/mm/transparent_hugepage/shmem_enabled - - - - advise"
    "w! /sys/kernel/mm/lru_gen/enabled - - - - 5"
    "w! /sys/kernel/mm/transparent_hugepage/khugepaged/scan_sleep_millisecs - - - - 30000"
    "w! /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none - - - - 409"
    "w! /sys/kernel/mm/ksm/pages_to_scan - - - - 1000"
    "w! /sys/kernel/mm/ksm/sleep_millisecs - - - - 4000"
    "w! /sys/class/rtc/rtc0/max_user_freq - - - - 3072"
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
}
