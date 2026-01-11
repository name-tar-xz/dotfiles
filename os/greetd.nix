{
  pkgs,
  config,
  ...
}:
{
  programs.uwsm.enable = true;

  services = {
    greetd = {
      enable = true;
      useTextGreeter = true;
      greeterManagesPlymouth = true;
      settings.default_session.command = with pkgs; "${lib.getExe tuigreet} --time --user-menu --remember --remember-session";
    };

    displayManager.sessionPackages = [
      config.home-manager.users.tarxz.wayland.windowManager.hyprland.finalPackage
    ];
  };
}
