{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    comma
    hyperfine
    just
    jq
    onefetch

    ## File Management
    rmtrash
    trash-cli

    bash-completion
    zsh-completions
  ];

  imports = [
    ./fastfetch.nix
    ./fzf.nix
    ./git.nix
    ./lf.nix
    ./starship.nix
    ./zsh.nix
  ];

  catppuccin.bat.enable = true;

  programs = {
    eza = {
      enable = true;
      extraOptions = [
        "-a"
        "--color-scale"
        "--color-scale-mode=fixed"
        "--follow-symlinks"
        "--git"
        "--group-directories-first"
        "--icons=auto"
        "--smart-group"
      ];
    };

    bat = {
      enable = true;
      config = {
        style = "changes,header-filename,rule,numbers,snip";
        pager = config.home.sessionVariables.PAGER;

        map-syntax = [
          "*.ino:C++"
          "*.ignore:Git Ignore"
          "*.rasi:CSS"
          "*.jsonc:JSON"
          "*.norg:orgmode"
          "justfile:make"
        ];
      };
    };

    less = {
      enable = true;
      options = {
        LONG-PROMPT = true;
        RAW-CONTROL-CHARS = true;
        ignore-case = true;
        mouse = true;
        quiet = true;
        quit-if-one-screen = true;
        quit-on-intr = true;
        tilde = true;
      };
      config = ''
        #env
        LESSUTFCHARDEF = E000-F8FF:p,F0000-FFFFD:p
        LESSHISTFILE = ${config.xdg.cacheHome}/less/history
      '';
    };

    fd = {
      enable = true;
      ignores = [
        "Games"
        "Public/cfg"
        "*Cache*"
        "*cache*"
        "Templates"
        "node_modules"
        "nix/store"
      ];
    };

    ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--follow"
        "--pretty"
      ];
    };

    tealdeer = {
      enable = true;
      settings = {
        display.compact = true;
        style = {
          command_name.foreground = "green";
          example_text.foreground = "yellow";
          example_code.foreground = "cyan";
          example_variable = {
            foreground = "magenta";
            underline = true;
          };
        };
        updates.auto_update = true;
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    lazygit = {
      enable = true;
      settings = {
        notARepository = "skip";
        update.method = "never";
        git = {
          pagers = [ { pager = "delta --dark --paging=never"; } ];
          autoFetch = false;
          autoRefresh = false;
          overrideGpg = true;
        };
        gui = {
          showDivergenceFromBaseBranch = "arrowAndNumber";
          showNumstatInFilesView = true;
          statusPanelView = "allBranchesLog";
          showCommandLog = false;
          showBottomLine = false;
          scrollPastBottom = false;
          showIcons = true;
          nerdFontsVersion = "3";
          theme = {
            activeBorderColor = [
              "#cba6f7"
              "bold"
            ];
            inactiveBorderColor = [ "#a6adc8" ];
            optionsTextColor = [ "#89b4fa" ];
            selectedLineBgColor = [ "#313244" ];
            cherryPickedCommitBgColor = [ "#45475a" ];
            cherryPickedCommitFgColor = [ "#cba6f7" ];
            unstagedChangesColor = [ "#f38ba8" ];
            defaultFgColor = [ "#cdd6f4" ];
            searchingActiveBorderColor = [ "#f9e2af" ];
          };
        };
      };
    };

    btop = {
      enable = true;
      settings = {
        theme_background = false;
        update_ms = 100;
        base_10_sizes = true;

        proc_gradient = false;
        proc_left = true;
        proc_per_core = true;
        proc_filter_kernel = true;

        net_sync = false;
        net_auto = false;
        net_download = 96;
        net_upload = 8;
      };
    };
  };
}
