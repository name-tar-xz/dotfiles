{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (rofi-systemd.overrideAttrs (old: {
      installPhase = old.installPhase + "sed 's/sudo //g' -i $out/bin/rofi-systemd";
    }))
  ];

  programs.rofi = {
    enable = true;
    plugins = with pkgs; [ rofi-power-menu ];

    theme = ./theme.rasi;

    settings = {
      cycle = true;
      font = "monospace 12";
      modes = "drun,window";
      fixed-num-lines = false;
      show-icons = true;
      terminal = "kitty";
      run-command = "uwsm-app -s app.slice -- {cmd}";
      run-shell-command = "uwsm-app -s app.slice -- {terminal} -1e sh -c {cmd}";
      drun-url-launcher = "xdg-open";
      disable-history = false;
      case-sensitive = false;
      sidebar-mode = true;
      matching = "normal";
      sort = true;
      sorting-method = "fzf";
      scroll-method = 1;
      window-format = "{w} {c} : {t}";
      display-drun = " 󰣆  Apps ";
      display-run = "   Run ";
      display-window = " 󰕰  Window";
      display-filebrowser = "   Files";
      display-calc = " 󰪚  Calc";
      steal-focus = true;
    };
  };
}
