source ~/.alias

export HISTSIZE=1000000   # the number of items for the internal history list
export SAVEHIST=1000000   # maximum number of items for the history file

# don't save commands starting with space
setopt HIST_IGNORE_SPACE

# share history across multiple zsh sessions
setopt SHARE_HISTORY

# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY

# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST

# Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_ALL_DUPS

# Don't write duplicate entries in the history file.
setopt HIST_SAVE_NO_DUPS

# do not store duplications
setopt HIST_IGNORE_DUPS

# ignore duplicates when searching
setopt HIST_FIND_NO_DUPS

# removes blank lines from history
setopt HIST_REDUCE_BLANKS

# Push the current directory visited onto the stack
setopt AUTO_PUSHD

# Do not store duplicates in the stack
setopt PUSHD_IGNORE_DUPS

# Do not print directory stack after pushd/popd
setopt PUSHD_SILENT

# Enable command substitution in the prompt
setopt PROMPT_SUBST

# Show execution time for commands that take longer than 5 seconds
function preexec() {
  timer=${timer:-$SECONDS}
}

function precmd() {
  # Handle timer for long-running commands
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    if [ $timer_show -gt 5 ]; then
      export RPROMPT="%F{yellow}${timer_show}s%f"
    else
      export RPROMPT=""
    fi
    unset timer
  fi
}

# Set prompt with improved styling and information
function prompt_git_info() {
  # Git information
  local git_branch=$(git symbolic-ref --short HEAD 2> /dev/null)
  local git_symbols=""

  if [[ -n $git_branch ]]; then
    # Modified/staged files
    git status --porcelain 2>/dev/null | grep -q . && git_symbols+="%F{yellow}✚%f"
    # Check for unpulled changes
    [[ $(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null | awk '{print $1}') -gt 0 ]] && git_symbols+="%F{red}⇣%f"
    # Check for unpushed changes
    [[ $(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null | awk '{print $2}') -gt 0 ]] && git_symbols+="%F{green}⇡%f"

    echo " %F{cyan}(${git_branch})%f ${git_symbols}"
  fi
}

# Set the prompt with all components
PROMPT='%F{yellow}%D{%H:%M:%S}%f %(?.%F{green}✓.%F{red}✗%?)%f %B%F{blue}%1~%f%b$(prompt_git_info) %(!.%F{red}#.%F{magenta}$)%f '

parse_git_branch() {
    local branch=$(git symbolic-ref --short HEAD 2> /dev/null)
    [[ -n $branch ]] && echo "%F{cyan}($branch)%f "
}

git_status() {
    local symbols=""
    # Modified/staged files
    git status --porcelain 2>/dev/null | grep -q . && symbols+="%F{yellow}✚%f"
    # Check for unpulled changes
    [[ $(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null | awk '{print $1}') -gt 0 ]] && symbols+="%F{red}⇣%f"
    # Check for unpushed changes
    [[ $(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null | awk '{print $2}') -gt 0 ]] && symbols+="%F{green}⇡%f"
    echo $symbols
}

# Set prompt with execution time for long-running commands
PROMPT='%F{yellow}%D{%H:%M:%S}%f %(?.%F{green}✓.%F{red}✗%?)%f %B%F{blue}%1~%f%b $(parse_git_branch)$(git_status)%(!.%F{red}#.%F{magenta}$)%f '

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# trim space path like `Application Support/`
export PATH=$(echo $PATH | sed 's/\ /\\ /g')
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

export PATH="/Users/guerra/.local/bin:$PATH"

export PATH="/Users/guerra/go/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export GPG_TTY=$(tty)
# to avoid this just hit one time ssh-add --apple-use-keychain ~/.ssh/your_private_key
# eval $(ssh-agent)
# ssh-add --apple-use-keychain

eval "$(atuin init zsh)"
eval "$(direnv hook zsh)"

source /Users/guerra/.config/op/plugins.sh
