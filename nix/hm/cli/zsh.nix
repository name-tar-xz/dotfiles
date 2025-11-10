{
  config,
  pkgs,
  lib,
  ...
}:
{
  catppuccin.zsh-syntax-highlighting.enable = true;

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    completionInit = "autoload -Uz compinit && compinit -i -u -C -d $XDG_CACHE_HOME/zsh/zcompdump";
    defaultKeymap = "emacs";
    autocd = true;

    history = {
      path = "${config.xdg.stateHome}/zsh/history";
      append = true;
      size = 100000;
      save = 100000;
      ignoreAllDups = true;
    };

    syntaxHighlighting.enable = true; # overwriting highlighters in initContent to work around catppuccin

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

    envExtra = # sh
      ''
        export MANROFFOPT="-c"
        export MANPAGER="/bin/sh -c 'col -bx | ${pkgs.lib.getExe pkgs.bat} --language=man --color=always -p'"
      '';

    initContent = lib.mkMerge [
      (lib.mkBefore "${pkgs.lib.getExe config.programs.fastfetch.package}")

      (lib.mkOrder 550 # sh
        ''
          zstyle ':completion:*' auto-description '+%d'
          zstyle ':completion:*' completer _oldlist _expand _expand_alias _complete _ignored _correct _approximate _prefix
          zstyle ':completion:*' file-sort name
          # zstyle ':completion:*' group-name ""
          zstyle ':completion:*' ignore-parents parent pwd
          zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
          zstyle ':completion:*' matcher-list "" 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**' '+l:|=* r:|=*'
          zstyle ':completion:*' menu select
          zstyle ':completion:*' original true
          zstyle ':completion:*' format ' %d'

          zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
          zstyle ':completion:*' rehash true                              # automatically find new executables in path

          # Speed up completions
          zstyle ':completion:*' accept-exact '*(N)'
          zstyle ':completion:*' use-cache on
          zstyle ':completion:*' cache-path ${config.xdg.cacheHome}/zsh
        ''
      )

      # sh
      ''
        source ${./functions.sh}
        zle -N lfcd

        ctrlz() {
          if [[ $#BUFFER -eq 0 ]]; then
            BUFFER="fg"
            zle accept-line
          else
            zle push-input
            zle clear-screen
          fi
        }
        zle -N ctrlz

        bindkey '^Z' ctrlz
        bindkey '^O' lfcd
        bindkey "^[[H" beginning-of-line
        bindkey "^[[F" end-of-line
        bindkey "^[[3~" delete-char

        autoload -U colors && colors # Load colors
      ''

      (lib.mkAfter "ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)")
    ];
  };
}
