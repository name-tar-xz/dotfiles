{ pkgs, ... }:
{
  programs = {
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-custom ];
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
      capSysNice = false;
    };
  };
}
