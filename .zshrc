[[ -r ~/.alias ]] && source ~/.alias

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ============================================================================
# ZSH OPTIONS AND PERFORMANCE
# ============================================================================
# Disable checking mail
unsetopt MAIL_WARNING

# GLOB_DOTS deliberately left off: it makes a bare * match .git and .env, so
# rm * or mv * dst reaches things you never meant to touch. Use *(D) when you
# actually want dotfiles in a glob.
# EXTENDED_GLOB and NULL_GLOB also left off: together they turned HEAD^ into a
# pattern that matched nothing and vanished, so git show HEAD^ showed HEAD.
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
setopt HIST_IGNORE_ALL_DUPS     # ignore all duplicates
setopt HIST_SAVE_NO_DUPS        # don't save duplicates
setopt HIST_FIND_NO_DUPS        # ignore duplicates when searching
setopt HIST_REDUCE_BLANKS       # removes blank lines from history
setopt HIST_VERIFY              # verify history before executing

# ============================================================================
# DIRECTORY NAVIGATION
# ============================================================================
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS    # don't store duplicates in the stack
setopt PUSHD_SILENT         # don't print directory stack after pushd/popd
setopt AUTO_CD              # typing a directory name cds into it

# ============================================================================
# ZSH NATIVE COMPLETION SYSTEM
# ============================================================================
autoload -Uz compinit

# Full check only when the dump is a day old. (#q) needs extendedglob, scoped
# here so it stays off at the prompt. compinit leaves an unchanged dump alone,
# hence the touch, or the full check would run on every shell after day one.
() {
  setopt localoptions extendedglob
  if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit && touch ~/.zcompdump
  else
    compinit -C
  fi
}

# Completion options
# COMPLETE_ALIASES deliberately left off: it stops aliases expanding before
# completion runs, which is what killed git subcommand completion behind gs.
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

function preexec() {
  timer=${timer:-$SECONDS}
}

function precmd() {
  # Plain assignment, not export: RPROMPT is a zsh shell parameter and exporting
  # it only leaks the prompt string into every child process.
  RPROMPT=""

  # Timer display
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    if [ $timer_show -gt 3 ]; then
      RPROMPT="%F{242}⏱ ${timer_show}s%f"
    fi
    unset timer
  fi
}

# One git process per prompt: porcelain v2 reports branch, ahead/behind and
# file states together. --no-optional-locks keeps the prompt from taking
# index.lock while an agent runs git in the same repo.
function git_prompt_info() {
  local out line branch oid modified staged untracked
  local -a ab
  local -i ahead=0 behind=0
  out=$(git --no-optional-locks status --porcelain=v2 --branch 2>/dev/null) || return

  for line in "${(@f)out}"; do
    case $line in
      '# branch.oid '*)  oid=${line#'# branch.oid '} ;;
      '# branch.head '*) branch=${line#'# branch.head '} ;;
      '# branch.ab '*)
        ab=(${=line#'# branch.ab '})
        ahead=${ab[1]#+}
        behind=${ab[2]#-}
        ;;
      [12u]' '*)
        [[ ${line[3]} != . ]] && staged=S
        [[ ${line[4]} != . ]] && modified=M
        ;;
      '? '*) untracked=U ;;
    esac
  done
  [[ $branch == '(detached)' ]] && branch=${oid[1,7]}

  local flags=$modified$staged$untracked color="%F{green}" remote=""
  [[ -n $modified$staged ]] && color="%F{yellow}"
  [[ -n $untracked ]] && color="%F{red}"
  (( behind )) && remote+="%F{red}↓%f"
  (( ahead )) && remote+="%F{green}↑%f"

  echo " ${color}${branch//\%/%%}%f${flags:+ [${flags}]}${remote}"
}

# More informative prompt with better visual hierarchy
PROMPT='%F{cyan}%n%f@%F{blue}%m%f:%F{yellow}%2~%f$(git_prompt_info) %(?.%F{green}.%F{red})%(!.#.❯)%f '

# ============================================================================
# KEY BINDINGS
# ============================================================================

# Explicit, because zsh picks vi mode when it starts with EDITOR=nvim already
# exported, which is every shell inside tmux or nvim. Ctrl-A/E/K/U/W/F/B/T/Y
# come with the emacs keymap. Up/Down and Ctrl-R are bound by atuin.
bindkey -e
bindkey "^[[1;3C" forward-word           # Alt + Right
bindkey "^[[1;3D" backward-word          # Alt + Left

# ============================================================================
# PATH CONFIGURATION
# ============================================================================

# -U drops duplicates, keeping the first occurrence. Ruby gem dirs come from a
# glob so no ruby process is spawned on every shell start.
typeset -U path
path=(
  ~/.gem/ruby/*/bin(NOn)
  /opt/homebrew/lib/ruby/gems/*/bin(NOn)
  /opt/homebrew/opt/ruby/bin
  ~/.cargo/bin
  ~/.local/bin
  /opt/homebrew/opt/libpq/bin
  $path
)

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
export GPG_TTY=$TTY
export PAGER="less"
export LESS="-R -F"  # -R: raw color codes, -F: exit if output fits one screen
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Colors for ls and completion
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

export LANG=en_US.UTF-8

# ============================================================================
# ZSH NATIVE FEATURES
# ============================================================================
setopt GLOB_STAR_SHORT    # ** for recursive globbing

# Additional useful options
setopt INTERACTIVECOMMENTS  # allow comments in interactive shells
setopt MULTIOS             # perform implicit tees or cats when multiple redirections are attempted
setopt NO_BEEP             # don't beep on error

# TOOL INITIALIZATIONS
# ============================================================================
# Create cache directory if it doesn't exist
[[ -d ~/.zsh/cache ]] || mkdir -p ~/.zsh/cache

# Other tools
command -v atuin >/dev/null && eval "$(atuin init zsh)"
command -v direnv >/dev/null && eval "$(direnv hook zsh)"
# fzf shell integration: Ctrl-T file picker, Alt-C cd, fuzzy completion (Ctrl-R owned by atuin)
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git' --glob '!node_modules'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="find . -type d -not -path '*/.git/*' -not -path '*/node_modules/*'"
# Empty FZF_CTRL_R_COMMAND skips fzf's Ctrl-R, which would otherwise replace
# atuin's since fzf is sourced after it
command -v fzf >/dev/null && FZF_CTRL_R_COMMAND= source <(fzf --zsh)
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
