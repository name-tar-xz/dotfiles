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
