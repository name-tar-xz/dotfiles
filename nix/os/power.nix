{ ... }:
{
  boot = {
    kernelParams = [
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

  services = {
    thermald.enable = true;

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
        ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
        ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend", ATTR{power/autosuspend}="60"
      '';
  };

  hardware.block = {
    defaultScheduler = "mq-deadline";
    defaultSchedulerRotational = "bfq";
    scheduler."nvme[0-9]*" = "none";
  };

  powerManagement.scsiLinkPolicy = "med_power_with_dipm";
}
