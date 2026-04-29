_: {
  catppuccin.delta.enable = true;

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
        true-color = "always";
        file-style = "omit";
        line-numbers = true;
      };
    };
  };
}
