source .alias

HISTSIZE=1000000000
HISTFILESIZE=1000000

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

#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS

# removes blank lines from history
setopt HIST_REDUCE_BLANKS

# set prompt with last operation
PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# '

# trim space path like `Application Support/`
export PATH=$(echo $PATH | sed 's/\ /\\ /g')
