unsetopt  beep

# Changing directories
setopt "AUTO_CD"
setopt "AUTO_PUSHD"
setopt "CDABLE_VARS"
setopt "CD_SILENT"
setopt "PUSHD_IGNORE_DUPS"
setopt "PUSHD_MINUS"

# Completion
setopt "ALWAYS_TO_END"
setopt "AUTO_LIST"
setopt "AUTO_MENU"
setopt "AUTO_PARAM_SLASH"
setopt "COMPLETE_ALIASES"
setopt "COMPLETE_IN_WORD"
setopt "GLOB_COMPLETE"
setopt "HASH_LIST_ALL"
setopt "LIST_PACKED"
setopt "LIST_TYPES"
# unsetopt  MENU_COMPLETE   # do not autoselect the first completion entry
# unsetopt  FLOW_CONTROL


# Expansion and Globbing
setopt "GLOB_DOTS"
setopt "EXTENDED_GLOB"

# History
setopt "BANG_HIST"
setopt "EXTENDED_HISTORY"
setopt "HIST_EXPIRE_DUPS_FIRST"
setopt "HIST_FIND_NO_DUPS"
setopt "HIST_IGNORE_ALL_DUPS"
setopt "HIST_IGNORE_DUPS"
setopt "HIST_IGNORE_SPACE"
setopt "HIST_REDUCE_BLANKS"
setopt "HIST_SAVE_NO_DUPS"
setopt "HIST_VERIFY"
setopt "INC_APPEND_HISTORY"
setopt "SHARE_HISTORY"

# Input/Output
setopt "CORRECT_ALL"
setopt "INTERACTIVECOMMENTS"

# Job Control
setopt "LONG_LIST_JOBS"

# Scripting
setopt "MULTIOS"


autoload -U compaudit compinit zrecompile
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.
zmodload -i zsh/complist
