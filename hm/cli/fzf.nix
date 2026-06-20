{ config, pkgs, ... }:
{
  catppuccin.fzf.enable = true;

  programs = {
    pistol = {
      enable = true;
      associations = [
        {
          mime = "text/*";
          command = "${pkgs.lib.getExe pkgs.bat} --color=always %pistol-filename%";
        }
        {
          mime = "inode/directory";
          command = "${config.programs.zsh.shellAliases.lla} --color=always --icons=always %pistol-filename%"; # Uses alias made by eza
        }
      ];
    };

    fzf = rec {
      enable = true;
      defaultCommand = "fd --type file -LH --color=always";

      defaultOptions = [
        "--inline-info"
        "--ansi"
        "--cycle"
        "--multi"
        "--filepath-word"

        "--height ~75%"
        "--scroll-off 9999"
        "--style full"
        "--no-scrollbar"

        "--preview 'test -f {} && pistol {}'"
        "--preview-window 'right,border-none,<60(down,border)'"

        "--bind 'alt-/:toggle-preview'"
        "--bind 'ctrl-b:preview-half-page-up'"
        "--bind 'ctrl-f:preview-half-page-down'"
        "--bind 'ctrl-u:half-page-up'"
        "--bind 'ctrl-d:half-page-down'"
        "--bind 'ctrl-y:accept'"
        "--bind 'ctrl-r:reload(${defaultCommand})'"
      ];

      colors.bg = pkgs.lib.mkForce "";

      changeDirWidget.command = "fd --type dir -LH --color=always";
      fileWidget.command = defaultCommand;
      historyWidget.options = [
        "--sort"
        "--exact"
        "--height 10%"
        "--preview ''"
      ];
    };
  };
}
