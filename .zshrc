source ~/.alias
eval "$(/opt/homebrew/bin/brew shellenv)"

# ============================================================================
# HISTORY CONFIGURATION
# ============================================================================
export HISTSIZE=1000000   # the number of items for the internal history list
export SAVEHIST=1000000   # maximum number of items for the history file
export HISTFILE="$HOME/.zsh_history"

# History options
setopt HIST_IGNORE_SPACE        # don't save commands starting with space
setopt SHARE_HISTORY            # share history across multiple zsh sessions
setopt INC_APPEND_HISTORY       # adds commands as they are typed, not at shell exit
setopt HIST_EXPIRE_DUPS_FIRST   # expire duplicates first
setopt HIST_IGNORE_ALL_DUPS     # ignore all duplicates
setopt HIST_SAVE_NO_DUPS        # don't save duplicates
setopt HIST_IGNORE_DUPS         # ignore duplicates
setopt HIST_FIND_NO_DUPS        # ignore duplicates when searching
setopt HIST_REDUCE_BLANKS       # removes blank lines from history
setopt HIST_VERIFY              # verify history before executing

# ============================================================================
# DIRECTORY NAVIGATION
# ============================================================================
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS    # don't store duplicates in the stack
setopt PUSHD_SILENT         # don't print directory stack after pushd/popd
setopt AUTO_CD              # push current directory onto stack

# ============================================================================
# ZSH NATIVE COMPLETION SYSTEM
# ============================================================================
autoload -Uz compinit
compinit

# Completion options
setopt COMPLETE_ALIASES
setopt LIST_PACKED
setopt AUTO_LIST
setopt AUTO_MENU
setopt ALWAYS_TO_END

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'

# ============================================================================
# PROMPT CONFIGURATION
# ============================================================================
setopt PROMPT_SUBST         # enable command substitution in the prompt

# Timer for long-running commands
function preexec() {
  timer=${timer:-$SECONDS}
}

function precmd() {
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    if [ $timer_show -gt 5 ]; then
      export RPROMPT="%F{242}${timer_show}s%f"
    else
      export RPROMPT=""
    fi
    unset timer
  fi
}

function git_prompt_info() {
  # Check if we're in a git repository first
  git rev-parse --is-inside-work-tree &>/dev/null || return
  
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
  local git_status=""
  local color="%F{green}"

  # Check for modifications (working directory)
  if ! git diff-index --quiet HEAD 2>/dev/null; then
    git_status+="●"
    color="%F{yellow}"
  fi

  # Check for staged changes
  if ! git diff-index --quiet --cached HEAD 2>/dev/null; then
    git_status+="✚"
    color="%F{yellow}"
  fi

  # Check for untracked files
  if [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
    git_status+="?"
    color="%F{red}"
  fi

  # Remote status
  local remote=$(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
  if [[ -n $remote ]]; then
    local behind=$(echo $remote | cut -f1)
    local ahead=$(echo $remote | cut -f2)
    [[ $behind -gt 0 ]] && git_status+="%F{red}↓%f"
    [[ $ahead -gt 0 ]] && git_status+="%F{green}↑%f"
  fi

  echo " ${color}${branch}%f${git_status:+ $git_status}"
}

PROMPT='%F{blue}%2~%f$(git_prompt_info) %(?.%F{green}.%F{red})%(!.#.❯)%f '

# ============================================================================
# KEY BINDINGS
# ============================================================================

bindkey "^[[1;3C" forward-word           # Alt + Right
bindkey "^[[1;3D" backward-word          # Alt + Left
bindkey "^[[A" history-search-backward   # Up arrow - search history
bindkey "^[[B" history-search-forward    # Down arrow - search history
bindkey "^A" beginning-of-line           # Ctrl + A
bindkey "^E" end-of-line                 # Ctrl + E
bindkey "^K" kill-line                   # Ctrl + K
bindkey "^U" kill-whole-line             # Ctrl + U
bindkey "^W" backward-kill-word          # Ctrl + W

# ============================================================================
# PATH CONFIGURATION
# ============================================================================
path=(
  /opt/homebrew/opt/libpq/bin
  ~/.local/bin
  $path
)
export PATH

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
export GPG_TTY=$(tty)
export PAGER="less"
export LESS="-R"

# Colors for ls and completion
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# ============================================================================
# ZSH NATIVE FEATURES
# ============================================================================
# Enable glob patterns
setopt EXTENDED_GLOB
setopt NULL_GLOB

# Better error handling
setopt CORRECT

# ============================================================================
# TOOL INITIALIZATIONS
# ============================================================================
# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Other tools
eval "$(atuin init zsh)"
eval "$(direnv hook zsh)"
