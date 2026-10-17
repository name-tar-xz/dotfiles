{ config, pkgs, ... }:
{
  catppuccin.delta.enable = true;

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      ignores = [
        ".Trash-*"
        "node_modules"
        "result*"
        "nohup.out"
      ];

      signing = {
        format = "ssh";
        key = "${config.home.homeDirectory}/.ssh/id_ed25519";
        signByDefault = true;
      };

      settings = {
        user = {
          name = "tarzst";
          email = "git" + "." + "3myp3" + "@" + "slmail" + "." + "me";
        };

        advice.statusHints = false;
        help.autocorrect = 1;
        init.defaultBranch = "master";
        receive.fsckObjects = true;
        status.showStash = true;
        transfer.fsckObjects = true;
        commit.verbose = true;

        alias = {
          lg = "log --graph";
          hist = "log -p";
        };

        core = {
          whitespace = "fix,trailing-space";
          pager = "delta";
        };
        push = {
          autoSetupRemote = true;
          default = "current";
        };
        fetch = {
          prune = true;
          fsckObjects = true;
        };
        log = {
          decorate = true;
          initialDecorationSet = "all";
          date = "human";
        };
        branch = {
          autoSetupMerge = true;
          sort = "committerdate";
        };
        merge = {
          conflictstyle = "zdiff3";
          autoStash = true;
          stat = true;
        };
        rebase = {
          autoStash = true;
          updateRefs = true;
          abbreviateCommands = true;
        };
        diff = {
          algorithm = "histogram";
          tool = "vimdiff";
          colorMoved = "plain";
          renames = true;
          mnemonicPrefix = true;
        };
        difftool.prompt = false;
        rerere = {
          enabled = true;
          autoUpdate = true;
        };
        url =
          let
            alias = domain: alias: { "ssh://git@${domain}/".InsteadOf = "${alias}:"; };
          in
          pkgs.lib.mkMerge [
            (alias "github.com" "github")
            (alias "gitlab.com" "gitlab")
            (alias "codeberg.org" "codeberg")
          ];
      };
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
