{ config, pkgs, ... }:
{
  home.file = {
    ".icons/default/index.theme".enable = false;
    ".icons/${config.home.pointerCursor.name}".enable = false;
  };

  xdg.configFile = {
    "qt5ct/colors/Catppuccin-Black.conf".source = ./qtct/Catppuccin-Black.conf;
    "qt6ct/colors/Catppuccin-Black.conf".source = ./qtct/Catppuccin-Black.conf;

    "gtk-4.0/assets".source =
      "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk-dark.css".source =
      "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = false;
    size = 24;
    name = "Nero";
    hyprcursor = {
      enable = true;
      size = 24;
    };
    package = pkgs.runCommand "Nero" { } ''
      mkdir -p $out/share/icons
      ln -s ${
        pkgs.fetchFromGitLab {
          owner = "tarzst";
          repo = "Nero";
          rev = "b609816350e3028246552572ab2d5251fc1127c5";
          hash = "sha256-n1gIhkzrfAFfLR603GfYZvI4C09pG4GgLfdm/Hs/H0A=";
        }
      } $out/share/icons/Nero'';
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.package = with pkgs; [
      libsForQt5.lightly
      kdePackages.breeze
    ];
  };

  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    theme = {
      name = "catppuccin-mocha-mauve-compact+black";
      package = (
        pkgs.catppuccin-gtk.override {
          accents = [ "mauve" ];
          size = "compact";
          tweaks = [ "black" ];
          variant = "mocha";
        }
      );
    };
    font.name = "Noto Sans";
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
}
