{ pkgs, osConfig, ... }:
{
  # Look at https://github.com/Digger1955/dxvk-gplasync-lowlatency/wiki/dxvk.conf-Options-Guide
  programs = {
    lutris = rec {
      enable = true;

      steamPackage = osConfig.programs.steam.package;
      protonPackages = [ pkgs.proton-ge-bin ];
      defaultWinePackage = builtins.elemAt protonPackages 0;
      extraPackages = with pkgs; [
        winetricks
        umu-launcher
      ];

      runners.wine.settings.runner.system_winetricks = true;
    };

    retroarch = {
      enable = false;
      cores = {
        gambatte.enable = true;
        mgba.enable = true;
        melonds.enable = true;
        picodrive.enable = true;
        pcsx-rearmed.enable = true;
        pcsx2.enable = true;
        ppsspp.enable = true;
      };
    };

    mangohud.enable = true;
  };

  services.ludusavi = {
    enable = true;
    frequency = "weekly";
  };
}
