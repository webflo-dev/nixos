unsetopt  BEEP

# Changing directories
setopt    AUTO_CD
setopt    AUTO_PUSHD
setopt    CDABLE_VARS
setopt    CD_SILENT
setopt    PUSHD_IGNORE_DUPS
setopt    PUSHD_MINUS

# Completion
setopt    ALWAYS_TO_END
setopt    AUTO_LIST
setopt    AUTO_MENU
setopt    AUTO_PARAM_SLASH
setopt    COMPLETE_ALIASES
setopt    COMPLETE_IN_WORD
setopt    GLOB_COMPLETE
setopt    HASH_LIST_ALL
setopt    LIST_PACKED
setopt    LIST_TYPES
unsetopt  MENU_COMPLETE
unsetopt  FLOW_CONTROL

# Expansion and Globbing
setopt    GLOB_DOTS
setopt    EXTENDED_GLOB
setopt    NOMATCH

# History
setopt    BANG_HIST
setopt    EXTENDED_HISTORY
setopt    HIST_EXPIRE_DUPS_FIRST
setopt    HIST_FIND_NO_DUPS
setopt    HIST_IGNORE_ALL_DUPS
setopt    HIST_IGNORE_DUPS
setopt    HIST_IGNORE_SPACE
setopt    HIST_REDUCE_BLANKS
setopt    HIST_SAVE_NO_DUPS
setopt    HIST_VERIFY
setopt    INC_APPEND_HISTORY
setopt    SHARE_HISTORY

# Input/Output
setopt    CORRECT_ALL
setopt    INTERACTIVECOMMENTS

# Job Control
setopt    LONG_LIST_JOBS

# Scripting
setopt    MULTIOS





zstyle ':completion:*' menu select

### Docker completion tips
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

### fzf-tab configuration
# disable sort when completing options of any command
zstyle ':completion:complete:*:options' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' 'fzf-preview [[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

# systemctl
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# env variables
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'

# git
# it is an example. you can change it
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview 'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
	esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
	esac'








###-begin-nps-completions-###
#
# yargs command completion script
#
# Installation: nps completion >> ~/.zshrc
#    or nps completion >> ~/.zsh_profile on OSX.
#
_nps_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" nps --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _nps_yargs_completions nps
###-end-nps-completions-###