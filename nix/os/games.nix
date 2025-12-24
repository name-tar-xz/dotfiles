{ pkgs, ... }:
{
  system.replaceDependencies.replacements = [
    {
      oldDependency = pkgs.networkmanager;
      newDependency = pkgs.runCommand "networkmanager-${pkgs.networkmanager.version}" { } "mkdir -p $out";
    }
    {
      oldDependency = pkgs.modemmanager;
      newDependency = pkgs.runCommand "modemmanager-${pkgs.modemmanager.version}" { } "mkdir -p $out";
    }
  ];

  programs = {
    steam = {
      enable = true;
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
      capSysNice = false;
    };
  };
}
