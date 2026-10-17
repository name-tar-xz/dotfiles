{
  osConfig,
  config,
  ...
}:
{
  lib,
  sloth,
  ...
}:
{
  gpu.enable = true;
  pasta.enable = true; # ?

  dbus = {
    enable = true;
    policies = {
      # Flatpak Defaults
      "org.freedesktop.DBus" = "talk";
      "org.freedesktop.portal.*" = "talk";
    };
  };

  bubblewrap = {
    network = true;
    shareIpc = true;
    tmpfs = [ "/tmp" ];

    bindEntireStore = false;
    extraStorePaths =
      (lib.singleton osConfig.hardware.graphics.package)
      ++ osConfig.hardware.graphics.extraPackages
      ++ osConfig.fonts.packages
      ++ osConfig.fonts.fontconfig.confPackages;

    clearEnv = true;
    env = {
      HOME = config.home.homeDirectory;
      WAYLAND_DISPLAY = sloth.env "WAYLAND_DISPLAY";
      XDG_RUNTIME_DIR = sloth.runtimeDir;
    };

    bind = {
      rw = lib.singleton (sloth.concat' sloth.runtimeDir "/doc"); # required to open files from the file chooser portal and downloads
      ro = lib.singleton "/etc/fonts";
    };

    sockets = {
      wayland = true;
      pipewire = true;
      pulse = true;
    };
  };
}
