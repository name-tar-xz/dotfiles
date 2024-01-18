## Run neofetch
fastfetch

# Activate Powerlevel10k Instant Prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"


# automatically load bash completion functions
HISTFILE="$XDG_STATE_HOME"/zsh/history
HISTSIZE=100000
SAVEHIST=100000
# typeset -g -A key

source "$HOME/.config/sh/functions.sh"
source "$ZDOTDIR/keys.sh"
source "$ZDOTDIR/opts.sh"

eval "$(mcfly init zsh)"
eval "$(npm completion)"

zinit light kazhala/dotbare
zinit light chisui/zsh-nix-shell
zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C;
  autoload -U +X bashcompinit && bashcompinit;
  autoload -Uz compinit;compinit -i -u -d $XDG_CACHE_HOME/zsh/zcompdump;
  eval $(zoxide init zsh);
  zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
    blockf \
    zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

[[ $XDG_CACHE_HOME/zsh/zcompdump.zwc -nt $XDG_CACHE_HOME/zsh/zcompdump ]] && zcompile $XDG_CACHE_HOME/zsh/zcompdump
