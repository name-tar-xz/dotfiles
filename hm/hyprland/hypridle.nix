{
  config,
  pkgs,
  lib,
  ...
}:
{
  systemd.user.services.hypridle.Service.Slice = "background.slice";

  services.hypridle = {
    enable = true;
    settings = rec {
      general = {
        before_sleep_cmd = "${lib.getExe' pkgs.procps "pidof"} ${lib.getExe pkgs.hyprlock} || ${lib.getExe pkgs.hyprlock}";
        lock_cmd = "${lib.getExe' pkgs.procps "pidof"} ${lib.getExe pkgs.hyprlock} || ${lib.getExe pkgs.hyprlock}";
        unlock_cmd = "${lib.getExe' pkgs.procps "pidof"} ${lib.getExe pkgs.hyprlock} | ${lib.getExe' pkgs.findutils "xargs"} kill -USR1";
        inhibit_sleep = 1;
      };
      listener = [
        {
          timeout = 90;
          on-timeout = general.lock_cmd;
        }
        {
          timeout = 60;
          on-timeout = "${lib.getExe pkgs.brightnessctl} -s set 10";
          on-resume = "${lib.getExe pkgs.brightnessctl} -r";
        }
        {
          timeout = 300;
          on-timeout = "${lib.getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} dispatch 'hl.dsp.dpms{action=\"off\"}'";
          on-resume = "${lib.getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} dispatch 'hl.dsp.dpms{action=\"on\"}'";
        }
      ];
    };
  };
}
