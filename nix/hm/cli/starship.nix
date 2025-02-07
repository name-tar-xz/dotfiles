{ ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$os$directory$git_commit$git_branch$git_metrics$git_status$character";
      right_format = "$cmd_duration";
      continuation_prompt = "[▸▹ ](bright-black)";

      os = {
        disabled = false;
        symbols.NixOS = " ";
      };

      directory = {
        fish_style_pwd_dir_length = 1;
        format = " [ $path]($style)[$read_only]($read_only_style) ";
        style = "blue";
        read_only = " 󰌾";
      };

      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        symbol = " ";
      };
      git_metrics.disabled = true;
      git_status = {
        style = "yellow";

        ahead = " ⇡\${count}";
        behind = " ⇣\${count}";
        conflicted = " [=\${count}](red)";
        deleted = " [✘\${count}](red)";
        diverged = " ⇕⇡\${ahead_count}⇣\${behind_count}";
        modified = " [!\${count}](bright-yellow)";
        renamed = " [»\${count}](blue)";
        staged = " [+\${count}](green)";
        stashed = " [*\${count}](purple)";
        untracked = " [?\${count}](blue)";
      };

      cmd_duration = {
        format = "[ $duration]($style) ";
        style = "bright-white";
        min_time = 0;
        show_milliseconds = true;
      };

      status.disabled = false;
    };
  };
}
