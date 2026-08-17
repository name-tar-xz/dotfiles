{ pkgs, ... }:
{
  boot.extraModprobeConfig = "options nvidia NVreg_EnableGpuFirmware=0 NVreg_EnableS0ixPowerManagement=1";

  services = {
    xserver.videoDrivers = [ "nvidia" ];

    udev.extraRules = /* udev */ ''
      # Enable runtime PM for NVIDIA VGA/3D controller devices on driver bind
      ACTION=="add|bind", SUBSYSTEM=="pci", DRIVERS=="nvidia", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", TEST=="power/control", ATTR{power/control}="auto"

      # Disable runtime PM for NVIDIA VGA/3D controller devices on driver unbind
      ACTION=="remove|unbind", SUBSYSTEM=="pci", DRIVERS=="nvidia", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", TEST=="power/control", ATTR{power/control}="on"
    '';
  };

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
      open = false;
      branch = "production";
      nvidiaSettings = false;
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
