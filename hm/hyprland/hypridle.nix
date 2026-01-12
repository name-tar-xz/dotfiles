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
    settings = {
      general.before_sleep_cmd = "${lib.getExe' pkgs.procps "pidof"} ${lib.getExe pkgs.hyprlock} || ${lib.getExe pkgs.hyprlock}";
      listener = [
        {
          timeout = 65;
          on-timeout = "${lib.getExe' pkgs.procps "pidof"} ${lib.getExe pkgs.hyprlock} || ${lib.getExe pkgs.hyprlock}";
        }
        {
          timeout = 60;
          on-timeout = "${lib.getExe pkgs.brightnessctl} -s set 10";
          on-resume = "${lib.getExe pkgs.brightnessctl} -r";
        }
        {
          timeout = 300;
          on-timeout = "${lib.getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} dispatch dpms off";
          on-resume = "${lib.getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} dispatch dpms on";
        }
      ];
    };
  };
}
