{ pkgs, ... }:
{
  boot = {
    kernelParams = [
      "i915.force_probe=!9a49"
      "xe.force_probe=9a49"
    ];
    initrd.kernelModules = [ "xe" ];
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-compute-runtime
        vpl-gpu-rt
      ];
      extraPackages32 = with pkgs.driversi686Linux; [ intel-media-driver ];
    };
  };
}
