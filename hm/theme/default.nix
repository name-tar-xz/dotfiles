{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.file = {
    ".icons/default/index.theme".enable = false;
    ".icons/${config.home.pointerCursor.name}".enable = false;
  };

  xdg.configFile = with config.gtk.theme; {
    "gtk-4.0/assets".source = "${package}/share/themes/${name}/gtk-4.0/assets";
    "gtk-3.0/assets".source = "${package}/share/themes/${name}/gtk-3.0/assets";
  };

  catppuccin = {
    flavor = "mocha";
    sources = inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.overrideScope (
      _final: prev: {
        whiskers = pkgs.symlinkJoin {
          name = "whiskers-wrapped";
          paths = [ prev.whiskers ];
          nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
          postBuild =
            let
              oled = builtins.toJSON {
                mocha = {
                  base = "000000";
                  mantle = "010101";
                  crust = "020202";
                };
              };
            in
            ''
              wrapProgram $out/bin/whiskers \
                --add-flag ${pkgs.lib.escapeShellArg "--color-overrides=${oled}"}
            '';
          meta.mainProgram = "whiskers";
        };
      }
    );
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
      ln -s "${
        pkgs.fetchFromGitLab {
          owner = "tarzst";
          repo = "Nero";
          rev = "7a51aa173c7069f113ca9dbe27a7600d41aa9a96";
          hash = "sha256-WhmZXPe/XQ1ZuVZHTRqB0+yvluUJRGAYWb5vhePFdn8=";
        }
      }" $out/share/icons/Nero
    '';
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.package = with pkgs; [
      darkly
      darkly-qt5
    ];
  };

  gtk = rec {
    enable = true;
    colorScheme = "dark";
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk3.extraCss = builtins.readFile "${theme.package}/share/themes/${theme.name}/gtk-3.0/gtk.css";
    gtk4.theme = theme;

    theme = {
      name = "catppuccin-mocha-mauve-compact+black";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "compact";
        tweaks = [ "black" ];
        variant = "mocha";
      };
    };
    font.name = "Sans Serif";
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
}
