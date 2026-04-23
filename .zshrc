source ~/.alias
eval "$(/opt/homebrew/bin/brew shellenv)"

# ============================================================================
# ZSH OPTIONS AND PERFORMANCE
# ============================================================================
# Disable checking mail
unsetopt MAIL_WARNING

setopt GLOB_DOTS          # include dotfiles in globbing
setopt NUMERIC_GLOB_SORT  # sort filenames numerically when it makes sense
setopt NO_CASE_GLOB       # case insensitive globbing

setopt LONG_LIST_JOBS     # display PID when suspending processes as well
setopt AUTO_RESUME        # attempt to resume existing job before creating a new process
setopt NOTIFY             # report job status immediately

# ============================================================================
# HISTORY CONFIGURATION
# ============================================================================
export HISTSIZE=1000000   # the number of items for the internal history list
export SAVEHIST=1000000   # maximum number of items for the history file
export HISTFILE="$HOME/.zsh_history"

# History options
setopt HIST_IGNORE_SPACE        # don't save commands starting with space
setopt SHARE_HISTORY            # share history across multiple zsh sessions (implies INC_APPEND_HISTORY)
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

# Only check compinit cache once per day for performance
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion options
setopt COMPLETE_ALIASES   # complete aliases
setopt LIST_PACKED
setopt AUTO_LIST
setopt AUTO_MENU
setopt ALWAYS_TO_END
setopt COMPLETE_IN_WORD   # allow completion in the middle of a word
setopt HASH_LIST_ALL      # hash everything before completion

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm -w -w"

# Cache completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# ============================================================================
# PROMPT CONFIGURATION
# ============================================================================
setopt PROMPT_SUBST         # enable command substitution in the prompt

# Timer for long-running commands
# Performance optimization: cache git status and remote info
typeset -g __git_prompt_cache=""
typeset -g __git_prompt_cache_dir=""
typeset -gA __git_remote_cache

function preexec() {
  timer=${timer:-$SECONDS}
  # Clear git cache on command execution
  __git_prompt_cache=""
  __git_prompt_cache_dir=""
  # Invalidate remote cache only for commands that can move refs
  case "$1" in
    git*push*|git*pull*|git*fetch*|git*commit*|git*reset*|git*rebase*|git*merge*|git*checkout*|git*switch*)
      __git_remote_cache=()
      ;;
  esac
}

function precmd() {
  # Initialize RPROMPT
  export RPROMPT=""

  # Timer display
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    if [ $timer_show -gt 3 ]; then
      export RPROMPT="%F{242}⏱ ${timer_show}s%f"
    fi
    unset timer
  fi
}

function git_prompt_info() {
  # Check if we're in a git repository first
  git rev-parse --is-inside-work-tree &>/dev/null || return

  local current_dir="$PWD"

  # Use cached result if we're in the same directory
  if [[ "$__git_prompt_cache_dir" == "$current_dir" && -n "$__git_prompt_cache" ]]; then
    echo "$__git_prompt_cache"
    return
  fi

  local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  [[ -z "$branch" ]] && return

  local git_status=""
  local color="%F{green}"

  # Use git status porcelain for better performance
  local status_output=$(git status --porcelain 2>/dev/null)

  if [[ -n "$status_output" ]]; then
    local haystack=$'\n'"$status_output"
    if [[ $haystack == *$'\n'?[MTD]* ]]; then
      git_status+="M"
      color="%F{yellow}"
    fi
    if [[ $haystack == *$'\n'[MADRC]* ]]; then
      git_status+="S"
      color="%F{yellow}"
    fi
    if [[ $haystack == *$'\n'\?\?* ]]; then
      git_status+="U"
      color="%F{red}"
    fi
  fi

  local remote_status=""
  if (( ${+__git_remote_cache[$current_dir]} )); then
    remote_status="${__git_remote_cache[$current_dir]}"
  else
    local remote=$(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
    if [[ -n $remote ]]; then
      local behind=${remote%%$'\t'*}
      local ahead=${remote##*$'\t'}
      [[ $behind -gt 0 ]] && remote_status+="%F{red}↓%f"
      [[ $ahead -gt 0 ]] && remote_status+="%F{green}↑%f"
    fi
    __git_remote_cache[$current_dir]="$remote_status"
  fi

  local result=" ${color}${branch}%f${git_status:+ [${git_status}]}${remote_status}"

  # Cache the result for current directory
  __git_prompt_cache="$result"
  __git_prompt_cache_dir="$current_dir"

  echo "$result"
}

# More informative prompt with better visual hierarchy
PROMPT='%F{cyan}%n%f@%F{blue}MBP%f:%F{yellow}%2~%f$(git_prompt_info) %(?.%F{green}.%F{red})%(!.#.❯)%f '

# ============================================================================
# KEY BINDINGS
# ============================================================================

bindkey "^[[1;3C" forward-word           # Alt + Right
bindkey "^[[1;3D" backward-word          # Alt + Left
# Up/Down arrows are bound by atuin
bindkey "^A" beginning-of-line           # Ctrl + A
bindkey "^E" end-of-line                 # Ctrl + E
bindkey "^K" kill-line                   # Ctrl + K
bindkey "^U" kill-whole-line             # Ctrl + U
bindkey "^W" backward-kill-word          # Ctrl + W
# Ctrl+R is handled by atuin
bindkey "^F" forward-char                # Ctrl + F
bindkey "^B" backward-char               # Ctrl + B
bindkey "^D" delete-char                 # Ctrl + D
bindkey "^H" backward-delete-char        # Ctrl + H
bindkey "^T" transpose-chars             # Ctrl + T
bindkey "^Y" yank                        # Ctrl + Y

# ============================================================================
# PATH CONFIGURATION
# ============================================================================

# Helper function to add a directory to PATH if not already present
add_to_path() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

add_to_path /opt/homebrew/opt/libpq/bin
add_to_path ~/.local/bin
add_to_path /usr/local/bin
add_to_path ~/.cargo/bin

export PATH

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
export GPG_TTY=$(tty)
export PAGER="less"
export LESS="-R -F -X"  # -F: exit if less than one screen, -X: don't clear screen
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Colors for ls and completion
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Locale settings
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# ============================================================================
# ZSH NATIVE FEATURES
# ============================================================================
# Enable glob patterns
setopt EXTENDED_GLOB
setopt NULL_GLOB
setopt GLOB_STAR_SHORT    # ** for recursive globbing

# Additional useful options
setopt INTERACTIVECOMMENTS  # allow comments in interactive shells
setopt MULTIOS             # perform implicit tees or cats when multiple redirections are attempted
setopt NO_BEEP             # don't beep on error

# TOOL INITIALIZATIONS
# ============================================================================
# Create cache directory if it doesn't exist
[[ -d ~/.zsh/cache ]] || mkdir -p ~/.zsh/cache

# NVM (lazy loading for better shell startup time)
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

# Other tools
command -v atuin >/dev/null && eval "$(atuin init zsh)"
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# Ruby paths (glob avoids spawning ruby on every shell start)
add_to_path /opt/homebrew/opt/ruby/bin
for d in /opt/homebrew/lib/ruby/gems/*/bin(N) ~/.gem/ruby/*/bin(N); do
  add_to_path "$d"
done
