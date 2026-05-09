{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    comma
    hyperfine
    just
    lix-diff
    nix-output-monitor
    onefetch

    ## File Management
    rmtrash
    trash-cli
  ];

  imports = [
    ./fastfetch.nix
    ./fzf.nix
    ./git.nix
    ./lf.nix
    ./omp.nix
    ./zsh.nix
  ];

  catppuccin = {
    bat.enable = true;
    btop.enable = true;
    eza.enable = true;
    lazygit.enable = true;
  };

  programs = {
    vivid = {
      enable = true;
      activeTheme = "catppuccin-mocha";
    };

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
        no-vbell = true;
        quiet = true;
        quit-if-one-screen = true;
        quit-on-intr = true;
        tabs = 4;
        tilde = true;
      };
      config = ''
        #env
        LESSUTFCHARDEF = E000-F8FF:p,F0000-FFFFD:p
        LESSHISTFILE = ${config.xdg.stateHome}/less/history
      '';
    };

    fd = {
      enable = true;
      extraOptions = [
        "--prune"
        "--require-git"
      ];
      ignores = [
        "Games"
        ".steam"
        "*Cache*"
        "*cache*"
        "nix/store"
        ".git"
      ];
    };

    ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--follow"
        "--pretty"
        "--ignore-file=${config.xdg.configHome}/fd/ignore"
        "--max-columns=240" # No of cols -20
        "--max-columns-preview"
      ];
    };

    jq = {
      enable = true;
      package = pkgs.jaq;
      colors = {
        null = "0;33";
        false = "0;33";
        true = "0;33";
        numbers = "0;33";
        strings = "0;32";
        arrays = "0;39";
        objects = "0;39";
        objectKeys = "1;34";
      };
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
            italic = true;
          };
          description.italic = true;
        };
        updates.auto_update = true;
      };
    };

    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
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

    npm = {
      enable = true;
      package = null;
      settings = with config.xdg; {
        prefix = "${dataHome}/npm";
        cache = "${cacheHome}/npm";
        tmp = "\${XDG_RUNTIME_DIR}/npm";
      };
    };
  };
}
