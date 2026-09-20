{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./waybar
    ./hyprlock.nix
    ./dunst.nix
    ./hypridle.nix
  ];

  catppuccin.hyprland.enable = true;

  home.packages = with pkgs; [
    hyprpicker
    grimblast # Screenshot
    wl-clipboard # Clipboard
    brightnessctl # Brightness
    rofi-power-menu
  ];

  xdg.configFile = {
    "systemd/user/xdg-desktop-portal-gtk.service.d/overrides.conf".source = # workaround for https://github.com/nix-community/home-manager/issues/5401
      (pkgs.formats.ini { }).generate "" { Service.Slice = "session.slice"; };

    "nixos/hm/hyprland/.luarc.json".text = builtins.toJSON {
      workspace.library = [ "${config.wayland.windowManager.hyprland.finalPackage}/share/hypr/stubs" ];
      diagnostics.globals = [ "colors" ];
    };
  };

  systemd.user.services = {
    cliphist.Service.Slice = "background.slice";
    cliphist-images.Service.Slice = "background.slice";

    hyprpaper.Service.Slice = "background.slice";

    lxqt-policykit-agent = {
      Install.WantedBy = [ "graphical-session.target" ];
      Unit = {
        After = [ "graphical-session.target" ];
        Description = "LXQT Polkit Agent";
      };
      Service = {
        Type = "simple";
        ExecStart = pkgs.lib.getExe pkgs.lxqt.lxqt-policykit;
        Restart = "on-failure";
        RestartSec = 1;
        Slice = "session.slice";
        TimeoutStopSec = 10;
      };
    };
  };

  services = {
    cliphist.enable = true;

    hyprpaper = {
      enable = true;
      settings = {
        wallpaper = [
          {
            monitor = "";
            path = "${.walls/the_neon_shallows_by_leikoi.jxl}";
            fit_mode = "fill";
          }
        ];
      };
    };
  };

  xdg.portal = {
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    xdph.settings.screencopy.max_fps = 30;
    configType = "lua";
    extraConfig = builtins.readFile ./hyprland.lua;
    settings.permission = [
      {
        _args = [
          {
            binary = "${config.wayland.windowManager.hyprland.finalPortalPackage}/libexec/xdg-desktop-portal-hyprland";
            type = "screencopy";
            mode = "allow";
          }
        ];
      }
    ]
    ++ (with pkgs; [
      {
        _args = [
          {
            binary = lib.getExe grimblast;
            type = "screencopy";
            mode = "allow";
          }
        ];
      }
      {
        _args = [
          {
            binary = lib.getExe grim;
            type = "screencopy";
            mode = "allow";
          }
        ];
      }
      {
        _args = [
          {
            binary = lib.getExe hyprpicker;
            type = "screencopy";
            mode = "allow";
          }
        ];
      }
      {
        _args = [
          {
            binary = lib.getExe hyprlock;
            type = "screencopy";
            mode = "allow";
          }
        ];
      }
    ]);
  };
}
