{ config, pkgs, ... }:
{
  boot.extraModprobeConfig = ''
    options nvidia NVreg_UsePageAttributeTable=1 NVreg_InitializeSystemMemoryAllocations=0 NVreg_DynamicPowerManagement=0x02
    options nvidia_drm modeset=1
  '';

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ];

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
  };
}
