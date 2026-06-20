{
  config,
  pkgs,
  lib,
  ...
}:
{
  catppuccin.zsh-syntax-highlighting.enable = true;
  imports = [ ./options.nix ];

  home = {
    packages = [ pkgs.zsh-completions ];
    shell.enableZshIntegration = true;

    sessionVariables.ZDOTDIR = config.programs.zsh.dotDir;
    file =
      let
        zcompileDotZ = x: "${lib.getExe config.programs.zsh.package} -c 'zcompile -M ${config.programs.zsh.dotDir}/.z${x}'";
      in
      {
        ".zshenv".enable = false;
        ".config/zsh/.zshrc".onChange = zcompileDotZ "shrc";
        ".config/zsh/.zshenv".onChange = zcompileDotZ "shenv";
        ".config/zsh/.zprofile".onChange = zcompileDotZ "profile";
      };
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    completionInit = /* sh */ "autoload -Uz compinit && compinit -u -d ${config.xdg.cacheHome}/zsh/zcompdump";
    defaultKeymap = "emacs";
    autocd = true;

    history = {
      path = "${config.xdg.stateHome}/zsh/history";
      append = true;
      size = 100000;
      save = 100000;
      ignoreAllDups = true;
    };

    syntaxHighlighting = {
      enable = true;
      highlighters = [ "brackets" ];
    };

    historySubstringSearch.enable = true;

    setOptions = [
      "correct" # Auto correct mistakes
      "extendedglob" # Extended globbing. Allows using regular expressions with *
      "nocaseglob" # Case insensitive globbing
      "rcexpandparam" # Array expansion with parameters
      "nocheckjobs" # Don't warn about running processes when exiting
      "numericglobsort" # Sort filenames numerically when it makes sense
      "nobeep" # No beep
      "appendhistory" # Immediately append history instead of overwriting
      "auto_pushd"
      "pushd_ignore_dups"
      "pushdminus"
      "globdots"
      "interactive_comments"
    ];

    # man 1 zshcompsys
    zstyle.":completion:*" = {
      auto-description = "'+%d'";
      completer = "_oldlist _expand _expand_alias _complete _ignored _correct _approximate _prefix";
      file-sort = "name";
      # group-name = "";
      ignore-parents = "parent pwd";
      list-colors = "\${(s.:.)LS_COLORS}";
      matcher-list = "'m:{[:lower:][:upper:]-}={[:upper:][:lower:]_} r:|[._-]=** r:|=** l:|=* r:|=*'";
      menu = "select";
      original = true;
      format = "' %d'";

      rehash = true; # automatically find new executables in path

      # Speed up completions
      accept-exact = "'*(N)'";
      use-cache = true;
      cache-path = "${config.xdg.cacheHome}/zsh";
    };

    shellSuffixAliases = rec {
      json = "jaq .";
      lock = json;
      toml = json + " --to toml";
      yaml = json + " --to yaml";
      yml = yaml;
    };

    shellGlobalAliases = {
      "--help" = "--help 2>&1 | bat --plain --language=help --color=always";

      C = "| wl-copy";
      L = "| less";
      G = "| rg";
      T = "| sudo tee";

      RB = "&& reboot";

      NE = "2>/dev/null";
      NO = ">/dev/null";
      NUL = ">/dev/null 2>&1";
    };

    functions = {
      rg = /* sh */ ''command rg --json "$@" | delta --paging never'';
      arduino_run = /* sh */ ''
        arduino-cli compile -b "$1" -p "$2" "$3"
        arduino-cli upload -b "$1" -p "$2" "$3"
        arduino-cli monitor -b "$1" -p "$2 -c baudrate=$4"
      '';
      respawn = /* sh */ ''
        pkill "$1"
        $1 &
        disown
      '';
    };

    zleFunctions = {
      lfcd = /* sh */ ''cd "$(command lf -print-last-dir "$@")" || return'';
      alts = /* sh */ ''
        BUFFER="sudo $(fc -ln -1)"
        zle accept-line
      '';
      ctrlz = /* sh */ ''
        if [[ $#BUFFER -eq 0 ]]; then
          BUFFER="fg"
          zle accept-line
        else
          zle push-input
          zle clear-screen
        fi
      '';
      clear-screen-and-scrollback = /* sh */ ''
        printf "\e[H\e[3J"
        zle clear-screen
      '';
    };

    bindkey = {
      "^L" = "clear-screen-and-scrollback";
      "^Z" = "ctrlz";
      "^O" = "lfcd";
      "^[s" = "alts";
      "^[[H" = "beginning-of-line";
      "^[[F" = "end-of-line";
      "^[[3~" = "delete-char";
    };

    dirHashes = with config; {
      nix = "${xdg.configHome}/nixos";
      git = "${home.homeDirectory}/git";
      moz = "${xdg.configHome}/mozilla/firefox/main";
    };

    sessionVariables = {
      MANROFFOPT = "-c";
      MANPAGER = "/bin/sh -c 'col -bx | ${pkgs.lib.getExe pkgs.bat} --language=man --color=always -p'";
      SYSTEMD_TINT_BACKGROUND = 0; # for run0
    };

    initContent = lib.mkMerge [
      (lib.mkBefore (lib.getExe config.programs.fastfetch.package))
      (lib.mkOrder 520
        /* sh */ "fpath+=(/run/current-system/sw/share/zsh/site-functions /etc/profiles/per-user/${config.home.username}/share/zsh/site-functions)"
      )
    ];
  };
}
