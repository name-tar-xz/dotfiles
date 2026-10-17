{
  pkgs,
  lib,
  config,
  osConfig,
  inputs,
  ...
}:
{
  home.packages =
    ((inputs.nixpak.lib.nixpak { inherit (pkgs) pkgs lib; }) {
      config = { ... }: {
        imports = (import ./nixPakBrowser.nix) { inherit osConfig config; } |> lib.singleton;

        app.package = config.programs.brave-origin.finalPackage;
        flatpak.appId = "com.brave.Browser";
        dbus.policies = {
          "org.bluez" = "talk";
          "org.freedesktop.Avahi" = "talk";
          "org.freedesktop.UPower" = "talk";

          "com.canonical.AppMenu.Registrar" = "talk";
          "org.freedesktop.FileManager1" = "talk";
          "org.freedesktop.Notifications" = "talk";
          "org.freedesktop.ScreenSaver" = "talk";
          "org.freedesktop.secrets" = "talk";
          "org.mpris.MediaPlayer2.brave.*" = "own";
        };

        bubblewrap.env.DISPLAY = ":0";

        bubblewrap.bind = {
          rw = lib.singleton "${config.xdg.configHome}/BraveSoftware/Brave-Origin";
          ro = [ "/run/dbus/system_bus_socket" ];
        };
      };
    }).config.env.override
      { meta.priority = -1; }
    |> lib.singleton;
  programs.brave-origin = {
    enable = true;
    commandLineArgs = [ "--ozone-platform=wayland" ];
  };
}
