unsetopt  beep
setopt    extended_glob
# directories
setopt    auto_cd
setopt    auto_pushd
setopt    pushd_ignore_dups
setopt    pushd_minus
# completion
unsetopt  menu_complete   # do not autoselect the first completion entry
unsetopt  flowcontrol
setopt    auto_menu         # show completion menu on successive tab press
setopt    complete_in_word
setopt    always_to_end
setopt    hash_list_all      # Whenever a command completion is attempted,
setopt    complete_aliases
setopt    list_types
setopt    list_packed
setopt    auto_list
setopt    auto_param_slash
setopt    glob_complete
setopt    glob_dots
setopt    correct_all        # Correct the spelling of all arguments in a line.
#history
setopt    bang_hist
setopt    extended_history       # record timestamp of command in HISTFILE
setopt    hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt    hist_ignore_dups       # ignore duplicated commands history list
setopt    hist_ignore_space      # ignore commands that start with space
setopt    inc_append_history     # Write to the history file immediately, not when the shell exits.
setopt    hist_ignore_all_dups   # Delete old recorded entry if new entry is a duplicate.
setopt    hist_save_no_dups      # Don't write duplicate entries in the history file.
setopt    hist_find_no_dups      # Do not display a line previously found.
setopt    hist_reduce_blanks     # Remove superfluous blanks before recording entry.
setopt    hist_verify            # Don't execute immediately upon history expansion.
setopt    share_history          # share command history data
# misc
setopt    multios              # enable redirect to multiple streams: echo >file1 >file2
setopt    long_list_jobs       # show long list format job notifications
setopt    interactivecomments  # recognize comments
#setopt rc_quotes


autoload -U compaudit compinit zrecompile
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.
zmodload -i zsh/complist
