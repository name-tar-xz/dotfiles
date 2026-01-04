_: {
  programs.oh-my-posh = {
    enable = true;
    settings = {
      final_space = true;
      shell_integration = true;
      enable_cursor_positioning = true;
      async = true;
      version = 3;

      blocks = [
        {
          type = "prompt";
          alignment = "left";
          segments = [
            {
              type = "os";
              template = "{{.Icon}}  ";
            }
            {
              type = "path";
              foreground = "blue";
              template = " {{.Path}}{{if not .Writable}}<red> 󰌾</>{{end}}";
              properties = {
                style = "fish";
                display_root = true;
                dir_length = 1;
                full_length_dirs = 3;
              };
            }
            {
              type = "git";
              foreground = "darkGray";
              template = " <magenta><b>{{.HEAD}}</b></>{{if or .Staging.Changed .Working.Changed .Ahead .Behind .StashCount}} [{{if .StashCount}}<cyan> *{{.StashCount}}</>{{end}}{{if or .Working.Deleted .Staging.Deleted}}<red> -{{add .Working.Deleted .Staging.Deleted}}</>{{end}}{{if .Working.Modified}}<lightYellow> !{{.Working.Modified}}</>{{end}}{{if or .Staging.Modified .Staging.Added}}<green> +{{add .Staging.Modified .Staging.Added}}</>{{end}}{{if .Working.Untracked}}<blue> ?{{.Working.Untracked}}</>{{end}}<yellow>{{if .Ahead}} ⇡{{.Ahead}}{{end}}{{if .Behind }} ⇣{{.Behind}}{{end}}</> ]{{end}}";
              properties = {
                branch_icon = " ";
                fetch_status = true;
                fetch_upstream_icon = true;
              };
            }
            {
              type = "text";
              template = " ❯";
              foreground = "green";
              foreground_templates = [ "{{if gt .Code 0}}red{{end}}" ];
            }
          ];
        }
        {
          type = "rprompt";
          alignment = "right";
          segments = [
            {
              type = "status";
              template = "{{if .Error}}✘{{.String}} {{end}}";
              foreground = "red";
            }
            {
              type = "executiontime";
              foreground = "lightWhite";
              template = " {{.FormattedMs}}";
              properties.threshold = 1;
            }
          ];
        }
      ];

      transient_prompt = {
        template = "❯ ";
        foreground = "green";
        background = "transparent";
        foreground_templates = [ "{{if gt .Code 0}}red{{end}}" ];
      };

      secondary_prompt = {
        foreground = "darkGray";
        template = "▸▹";
      };
    };
  };
}
