export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
export LESS_TERMCAP_ue=$'\E[0m'           # end underline

export LS_COLORS="$(vivid generate catppuccin-mocha)" #Set lsd,fd colors

export MOAR='-wrap -statusbar plain -style native -no-linenumbers -quit-if-one-screen'

export MCFLY_RESULTS=75
export MCFLY_RESULTS_SORT=LAST_RUN
export MCFLY_FUZZY=1

export GPG_TTY=$(tty)

# export BUN_INSTALL="$HOME/.local/share/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"

## Path section
if [ -d "$HOME/.local/share/flatpak/exports/share" ]; then
	export XDG_DATA_DIRS=$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS
fi
if [ -d "$HOME/.local/share/cargo/bin" ]; then
	export PATH=$HOME/.local/share/cargo/bin:$PATH
fi
if [ -d "$HOME/.local/share/npm/bin" ]; then
	export PATH=$HOME/.local/share/npm/bin:$PATH
fi
if [ -d "$HOME/.emacs.d/bin" ]; then
	export PATH=$HOME/.emacs.d/bin:$PATH
fi
if [ -d "$HOME/.local/bin" ]; then
	export PATH=$HOME/.local/bin:$PATH
fi
if [ -d "$GOPATH/bin" ]; then
	export PATH=$PATH:$GOPATH/bin
fi

fpath=(~/.config/zsh/completion $fpath)

setopt rcs
export BROWSER=librewolf
export SUDO_EDITOR=nvim
export EDITOR=nvim
export VISUAL=nvim
export PAGER=moar

export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat --language=help --color=always --theme=default -p'"

export PF_INFO="ascii title os kernel uptime pkgs shell editor de palette"

export DOTBARE_DIR=$HOME/Public/cfg

export CC=$(which clang)
export CXX=$(which clang++)

export FZF_DEFAULT_COMMAND='fd --prune --type file -L --color=always'
export FZF_DEFAULT_OPTS=' --inline-info --ansi --cycle --multi --height ~100% --border
--bind "alt-/:preview:bat --style=numbers,header-filename,header-filesize,snip,rule --color=always --paging=always {}"
--preview-window "right,border-left,<60(down,border)"
--bind "ctrl-r:reload($FZF_DEFAULT_COMMAND)"
--color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8'
