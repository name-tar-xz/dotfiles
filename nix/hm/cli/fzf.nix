{ config, pkgs, ... }:
{
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
      defaultCommand = "fd --type file -LH --color=always --max-depth=3";

      defaultOptions = [
        "--inline-info"
        "--ansi"
        "--cycle"
        "--multi"
        "--height ~100%"
        "--border"
        "--preview 'pistol {}'"
        "--bind='alt-/:toggle-preview'"
        "--bind='ctrl-u:preview-page-up'"
        "--bind='ctrl-d:preview-page-down'"
        "--preview-window 'right,border-left,<60(down,border)'"
        "--bind 'ctrl-r:reload(${defaultCommand})'"
      ];

      colors = {
        "bg+" = "#313244";
        "fg+" = "#cdd6f4";
        "hl+" = "#f38ba8";
        fg = "#cdd6f4";
        header = "#f38ba8";
        hl = "#f38ba8";
        info = "#cba6f7";
        marker = "#f5e0dc";
        pointer = "#f5e0dc";
        prompt = "#cba6f7";
        spinner = "#f5e0dc";
      };

      changeDirWidgetCommand = "fd --type d -LH --color=always --max-depth=3";
      fileWidgetCommand = "fd --type f -LH --color=always --max-depth=3";
      historyWidgetOptions = [
        "--sort"
        "--exact"
      ];

      enableZshIntegration = true;
    };
  };
}
