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

    displayManager.sessionPackages = pkgs.lib.singleton config.home-manager.users.tarxz.wayland.windowManager.hyprland.finalPackage;
  };

  systemd.tmpfiles.rules = pkgs.lib.singleton "w /var/cache/tuigreet/lastsession-path - greeter greeter - 'uwsm start -e -D Hyprland -F hyprland.desktop'"; # HACK Prevents having to reselect UWSM whenever path to desktops in /nix/store changes

  security.wrappers.Hyprland = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_nice+ep";
    source = pkgs.lib.getExe config.home-manager.users.tarxz.wayland.windowManager.hyprland.finalPackage;
  };
}
