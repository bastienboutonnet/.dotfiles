# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="fino-time"

# Plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

# =============================================================================
# User configuration
# =============================================================================

export EDITOR="nvim"

# -----------------------------------------------------------------------------
# NVM
# -----------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# -----------------------------------------------------------------------------
# Pyenv
# -----------------------------------------------------------------------------
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d "$PYENV_ROOT" ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)" 2>/dev/null
    eval "$(pyenv init -)" 2>/dev/null
fi

# -----------------------------------------------------------------------------
# Homebrew (Mac or Linux)
# -----------------------------------------------------------------------------
if [[ -f /opt/homebrew/bin/brew ]]; then
    # Mac (Apple Silicon)
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
    export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
    export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
    export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"
elif [[ -f /usr/local/bin/brew ]]; then
    # Mac (Intel)
    eval "$(/usr/local/bin/brew shellenv)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    # Linux
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# -----------------------------------------------------------------------------
# Conda (if installed via pyenv)
# -----------------------------------------------------------------------------
if [[ -d "$HOME/.pyenv/versions/miniforge3-4.9.2" ]]; then
    __conda_setup="$("$HOME/.pyenv/versions/miniforge3-4.9.2/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/.pyenv/versions/miniforge3-4.9.2/etc/profile.d/conda.sh" ]; then
            . "$HOME/.pyenv/versions/miniforge3-4.9.2/etc/profile.d/conda.sh"
        else
            export PATH="$HOME/.pyenv/versions/miniforge3-4.9.2/bin:$PATH"
        fi
    fi
    unset __conda_setup
fi

# -----------------------------------------------------------------------------
# FZF
# -----------------------------------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# -----------------------------------------------------------------------------
# Zoxide
# -----------------------------------------------------------------------------
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init --cmd cd zsh)"
fi

# -----------------------------------------------------------------------------
# Go
# -----------------------------------------------------------------------------
if command -v go &> /dev/null; then
    export PATH="$(go env GOPATH)/bin:$PATH"
fi

# -----------------------------------------------------------------------------
# Poetry & pipx
# -----------------------------------------------------------------------------
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# -----------------------------------------------------------------------------
# Personal bin
# -----------------------------------------------------------------------------
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.dopy"

# =============================================================================
# Aliases
# =============================================================================
alias vim="nvim"
alias vi="nvim"
alias oldvim="vim"
alias ci="code-insiders ."

# Mac-only aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias tbar-restart='sudo pkill TouchBarServer; sudo killall "ControlStrip"'
fi

# =============================================================================
# Functions
# =============================================================================

# Venv FZF activation
function a() {
    local selected_env
    selected_env=$(ls ~/venvs/ 2>/dev/null | fzf)
    if [ -n "$selected_env" ]; then
        source "$HOME/venvs/$selected_env/bin/activate"
    fi
}

# Venv FZF removal
function vr() {
    local selected_env
    selected_env=$(ls ~/venvs/ 2>/dev/null | fzf)
    if [ -n "$selected_env" ]; then
        rm -rf "$HOME/venvs/$selected_env/"
    fi
}

# Venv creation (uses python3)
mkvenv_p3() {
    local env_dir="$HOME/venvs/$1"
    if [ -d "$env_dir" ]; then
        echo "Error: Virtual environment $1 already exists in $HOME/venvs."
        return 1
    else
        python3 -m venv "$env_dir"
        echo "Virtual environment $1 created successfully in $HOME/venvs."
        source "$env_dir/bin/activate"
        pip install --upgrade pip
        echo "pip upgraded successfully in the virtual environment $1."
        deactivate
    fi
}

# Venv creation (uses python)
mkvenv() {
    local env_dir="$HOME/venvs/$1"
    if [ -d "$env_dir" ]; then
        echo "Error: Virtual environment $1 already exists in $HOME/venvs."
        return 1
    else
        python -m venv "$env_dir"
        echo "Virtual environment $1 created successfully in $HOME/venvs."
        source "$env_dir/bin/activate"
        pip install --upgrade pip
        echo "pip upgraded successfully in the virtual environment $1."
        deactivate
    fi
}

# Git branches delete with fzf
function delete-branches() {
    local branches_to_delete
    branches_to_delete=$(git branch | fzf --multi)
    if [ -n "$branches_to_delete" ]; then
        git branch --delete --force $branches_to_delete
    fi
}

# Claude agent worktree creator (Mac-specific path, adjust as needed)
claude-agent() {
    local name=$1
    if [ -z "$name" ]; then
        echo "Usage: claude-agent <worktree-name>"
        return 1
    fi
    local repo_dir="$HOME/repos/littlebooker"
    local worktree_path="${repo_dir}-${name}"
    git -C "$repo_dir" worktree add "$worktree_path" -b "feature/${name}"
    cd "$worktree_path"
    claude
}

# =============================================================================
# Fig post block. Keep at the bottom of this file.
# =============================================================================
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
[[ -f ~/.beets_env.sh ]] && source ~/.beets_env.sh
