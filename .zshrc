# Export environment variables
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export HOMEBREW_GITHUB_API_TOKEN=***REMOVED-GITHUB-TOKEN***
export GPG_TTY=$(tty)

# Initialize Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
# zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::brew
zinit snippet OMZP::gh
zinit snippet OMZP::invoke
zinit snippet OMZP::pip
zinit snippet OMZP::python
zinit snippet OMZP::ssh
zinit snippet OMZP::terraform
zinit snippet OMZP::vscode
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Initialise oh-my-posh
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

# Only load oh-my-posh if not in Apple Terminal
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh)"
fi

# Key bindings
bindkey -e

# History search arrow keys
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEDHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias c='clear'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(test -x $HOME/bin/hermit && $HOME/bin/hermit shell-hooks --print --zsh)"
if [[ "$CLAUDECODE" != "1" ]]; then
eval "$(zoxide init --cmd cd zsh)"
fi
eval "${/opt/homebrew/bin/brew shellenv}"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
