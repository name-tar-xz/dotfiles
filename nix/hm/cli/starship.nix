{ config, lib, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings =
      lib.attrsets.recursiveUpdate
        (builtins.fromTOML (
          builtins.readFile "${config.programs.starship.package}/share/starship/presets/nerd-font-symbols.toml"
        ))
        {
          add_newline = false;
          format = "$os$directory$git_commit$git_branch$git_metrics$git_status$character";
          right_format = "$all";
          continuation_prompt = "[▸▹ ](bright-black)";

          os = {
            disabled = false;
            symbols.NixOS = "󱄅 ";
          };

          directory = {
            fish_style_pwd_dir_length = 1;
            format = "[ $path]($style)[$read_only]($read_only_style) ";
            style = "blue";
          };

          git_branch.format = "[$symbol$branch(:$remote_branch)]($style) ";
          git_metrics.disabled = true;
          git_status = {
            style = "yellow";

            ahead = " ⇡\${count}";
            behind = " ⇣\${count}";
            conflicted = " =\${count}";
            deleted = " ✘\${count}";
            diverged = " ⇕⇡\${ahead_count}⇣\${behind_count}";
            modified = " !\${count}";
            renamed = " »\${count}";
            staged = " +\${count}";
            stashed = " *\${count}";
            untracked = " ?\${count}";
          };

          cmd_duration = {
            format = "[ $duration]($style) ";
            min_time = 0;
            show_milliseconds = true;
          };

          status.disabled = false;
        };
  };
}
