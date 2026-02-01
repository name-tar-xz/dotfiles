{ config, ... }:
{
  programs = {
    git = {
      enable = true;

      ignores = [
        ".Trash-*"
        "node_modules"
        "result*"
        "nohup.out"
      ];

      settings = {
        user = {
          name = "tarzst";
          email = "git.3myp3@slmail.me";
          signingKey = "DA1AE234F1953A10F6078E9B9E604C53FBEFE1D9";
        };

        commit.gpgSign = true;
        tag.gpgSign = true;
        advice.statusHints = false;
        help.autocorrect = 1;
        push.autoSetupRemote = true;
        fetch.prune = true;

        alias = {
          lg = "log --graph";
          hist = "log -p";
        };

        log = {
          decorate = true;
          initialDecorationSet = "all";
          date = "human";
        };

        init.defaultBranch = "master";
        merge.conflictstyle = "diff3";
        status.showStash = true;

        rebase = {
          autoStash = true;
          abbreviateCommands = true;
        };

        diff = {
          tool = "vimdiff";
          colorMoved = "default";
          renames = true;
        };

        difftool.prompt = false;
      };

      lfs.enable = true;
    };
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        features = "decorations";
        true-color = "always";
        decorations = {
          file-style = "omit";
          hunk-header-style = "file line-number syntax";
          hunk-header-line-number-style = "yellow";
          syntax-theme = config.programs.bat.config.theme;
          blame-palette = "#1e1e2e #181825 #11111b #313244 #45475a";
          dark = true;
          file-decoration-style = "#cdd6f4";
          # hunk-header-file-style = "bold";
          line-numbers = true;
          line-numbers-left-style = "#6c7086";
          line-numbers-minus-style = "bold #f38ba8";
          line-numbers-plus-style = "bold #a6e3a1";
          line-numbers-right-style = "#6c7086";
          line-numbers-zero-style = "#6c7086";
          # 40% red 60% base
          minus-emph-style = "syntax #613743";
          # 20% red 80% base
          minus-style = "syntax #301b21";
          # 40% green 60% base
          plus-emph-style = "syntax #425a40";
          # 20% green 80% base
          plus-style = "syntax #212d20";
        };
      };
    };
  };
}
