{ pkgs, ... }:
{
  home.packages = with pkgs; [ rofi-systemd ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = with pkgs; [ rofi-power-menu ];

    cycle = true;
    font = "monospace 12";
    theme = ./theme.rasi;
    extraConfig = {
      modes = "drun,window";
      fixed-num-lines = false;
      show-icons = true;
      terminal = "kitty";
      run-shell-command = "{terminal} -e bash -c {cmd}";
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
