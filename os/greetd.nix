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

  systemd.tmpfiles.rules = [
    "w /var/cache/tuigreet/lastsession-path - greeter greeter - ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions/hyprland-uwsm.desktop"
  ]; # HACK Prevents having to reselect UWSM whenever path to desktops in /nix/store changes
}
