{ pkgs, lib, ... }:
{
  services.hypridle = {
    enable = true;
    settings = {
      general.before_sleep_cmd = "${lib.getExe' pkgs.procps "pidof"} hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
      listener = [
        {
          timeout = 65;
          on-timeout = "${lib.getExe' pkgs.procps "pidof"} hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        }
        {
          timeout = 60;
          on-timeout = "${lib.getExe pkgs.brightnessctl} -s set 10";
          on-resume = "${lib.getExe pkgs.brightnessctl} -r";
        }
      ];
    };
  };
}
