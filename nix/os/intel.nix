{ pkgs, ... }:
{
  boot.kernelParams = [
    "i915.force_probe=!9a49"
    "xe.force_probe=9a49"
  ];

  hardware = {
    cpu.intel.updateMicrocode = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vpl-gpu-rt
      ];
    };
  };
}
