# ~/.zshrc
if [[ ! -d ~/.zplug ]]; then
  echo "zplug not found. Installing..."
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# Load fzf
[ -f ~/.fzf.zsh ] && source <(fzf --zsh)

# Load zoxide
eval "$(zoxide init zsh)"
# Load starship
eval "$(starship init zsh)"

# Load ssh-agent 
eval "$(ssh-agent -s)"
# add ssh keys
ssh-add ~/.ssh/azuredevops_rsa 
ssh-add ~/.ssh/github_ed25519 
ssh-add ~/.ssh/id_ed25519_do_amackerel

# set home dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}

# make cargo binaries executable
export PATH=~/.cargo/bin:$PATH
export PATH=~/.local/bin:$PATH
export EDITOR='helix'
# export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock
export BROWSER=brave
export GCM_CREDENTIAL_STORE=plaintext

# Aliases
alias shouldi='curl https://naas.isalman.dev/no -s | jq .reason'
alias ls='eza -l'
alias cat='bat'
alias cd='z'
alias flameshot="QT_QPA_PLATFORM=wayland flameshot gui"
## disable GPU for anki
alias anki="QTWEBENGINE_CHROMIUM_FLAGS="--disable-gpu" anki"
# alias docker="podman"
alias nod="nordlayer disconnect"
alias noc="nordlayer connect V8zIwbpQ8z0l"


# Two seperate nvim configs (one for dev and one for writing)
# Development Neovim (default)
alias nvim-dev='NVIM_APPNAME=nvim nvim'
alias nv='nvim'
alias vi='nvim'
alias vim='nvim'

# Writing Neovim
alias nvim-writer='NVIM_APPNAME=nvim-writer nvim'
alias nvw='NVIM_APPNAME=nvim-writer nvim'

# Zsh options
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
HISTSIZE=5000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE
HISTDUPE=erase
setopt appendhistory 
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


# Zsh plugins using zplug
if [ -f ~/.zplug/init.zsh ]; then
    source ~/.zplug/init.zsh

    zplug 'zplug/zplug', hook-build:'zplug --self-manage'

    zplug zsh-users/zsh-autosuggestions
    zplug zsh-users/zsh-syntax-highlighting
    zplug zsh-users/zsh-completions
    zplug MichaelAquilina/zsh-autoswitch-virtualenv
    zplug MichaelAquilina/zsh-auto-notify
    zplug jeffreytse/zsh-vi-mode

    # Install plugins if there are plugins that have not been installed
    if ! zplug check --verbose; then
        zplug install
    fi

    zplug load
fi

# Zsh completion style
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'


. "$HOME/.cargo/env"
# Added by qerent installer
export PATH="/home/utsar/go/bin:/home/utsar/qli/bin:$PATH"
