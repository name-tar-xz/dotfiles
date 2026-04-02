{ pkgs, ... }:
{
  system.replaceDependencies.replacements = with pkgs; [
    {
      oldDependency = networkmanager;
      newDependency = runCommand "networkmanager-${networkmanager.version}" { } "mkdir -p $out";
    }
    {
      oldDependency = modemmanager;
      newDependency = runCommand "modemmanager-${modemmanager.version}" { } "mkdir -p $out";
    }
  ];

  programs = {
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          LD_PRELOAD = ""; # Disable Steam Overlay
          PROTON_USE_WAYLAND = 1;
          # GE Only Config shorthand see https://github.com/GloriousEggroll/proton-ge-custom/blob/4bf56d6422677c1fc716f07c9630cc1e5c00941b/proton#L1856C1-L1892C68
          # CachyOS Only
          PROTON_USE_NTSYNC = 1;
        };
        # Maybe add nvidia-offload with extraProfile ?
      };
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    gamemode = {
      enable = true;
      enableRenice = false;
      settings = {
        general = {
          renice = 20;
          ioprio = 0;
          softrealtime = "on";
        };
      };
    };
    gamescope = {
      enable = true;
      args = [
        "--expose-wayland"
        "--immediate-flips"
      ];
      capSysNice = false;
    };
  };
}
