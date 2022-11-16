#########################################
# /etc/bash.bashrc
#
# Customized bashrc for VScode Devcontaner
#########################################

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ $DISPLAY ]] && shopt -s checkwinsize

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

# VI editing mode
set -o vi

# Enable tabs 2
tabs 2

# Enable directory expansion for variable
shopt -s direxpand

##############################################
# Solarize PS1
##############################################

# Colorize terminal code
normal=$(tput rmul)$(tput dim)
reset=$(tput sgr0)
underline=$(tput smul)
normalline=$(tput rmul)
blink=$(tput blink)
bold=$(tput bold)
dim=$(tput dim)
rev=$(tput rev)
fg_black=$(tput setaf 0)
fg_red=$(tput setaf 1)
fg_green=$(tput setaf 2)
fg_yellow=$(tput setaf 3)
fg_blue=$(tput setaf 4)
fg_magenta=$(tput setaf 5)
fg_cyan=$(tput setaf 6)
fg_white=$(tput setaf 7)

bg_black=$(tput setab 0)
bg_red=$(tput setab 1)
bg_green=$(tput setab 2)
bg_yellow=$(tput setab 3)
bg_blue=$(tput setab 4)
bg_magenta=$(tput setab 5)
bg_cyan=$(tput setab 6)
bg_white=$(tput setab 7)


function git_branch() {

  # Reset variables
  g_ahead_icon=""
  g_behind_icon=""
  g_group_open=""
  g_group_close=""
  g_branch_icon=""
  g_branch=""
  g_upstream=""
  g_ahead=""
  g_behind=""
  g_change=""
  g_untrack=""

  g_status=$(git status -s -b 2> /dev/null | tr '\n' '|' |  sed -E "s/\|$//")

  if [[ -n ${g_status} ]]; then
    g_group_open="("
    g_group_close=") "

    g_branch_icon=""
    g_branch=" $(echo $g_status |sed 's/ No commits yet on//' | cut -d ' ' -f2 | sed -E "s/[\.]{3}[^[:space:]]+//" | sed "s/[\|].*//" )"
    g_upstream="$(echo $g_status | grep -E "[\.]{3}" > /dev/null && echo "")"
    if [[ -n ${g_upstream} ]]; then
      g_upstream=" ${g_upstream} "
    fi

    g_ahead=$(echo $g_status | grep ahead  | awk -F "ahead " '{print $2}' | awk -F '[[:space:]]|,|]' '{print $1}')
    if [[ -n ${g_ahead} ]]; then
      g_ahead_icon="  "
    fi

    g_behind=$(echo $g_status | grep behind  | awk -F "behind " '{print $2}' | awk -F '[[:space:]]|,|]' '{print $1}')
    if [[ -n ${g_behind} ]]; then
      g_behind_icon="  "
    fi

    g_change=$(echo $g_status | sed -E "s/[\|][\?]+[^\|]*//g" | grep -E "\|" > /dev/null && echo "")
    if [[ -n ${g_change} ]]; then
      g_change=" ${g_change} "
    fi

    g_untrack=$(echo $g_status | grep -E "\|[\?]{2}" > /dev/null && echo "")
    if [[ -n ${g_untrack} && -z ${g_change} ]]; then
      g_untrack=" ${g_untrack} "
    elif [[ -n ${g_untrack} ]]; then
      g_untrack="${g_untrack} "
    fi
  fi
}


# Ignore history duplicated
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# Defined color
# Reference https://askubuntu.com/questions/24358/how-do-i-get-long-command-lines-to-wrap-to-the-next-line
# Reference https://wiki.bash-hackers.org/scripting/terminalcodes
bracketcolor=$(tput bold; tput setaf 1) # Bold red
cwdcolor=$(tput bold; tput setaf 4) # Bold blue
resetcolor=$(tput sgr0)	#reset
gitcolor=${bold}${fg_cyan}

p_user=${USER}

## PS1
case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*|screen*)
    # Original
    PROMPT_COMMAND="__vte_prompt_command 2> /dev/null; git_branch > /dev/null;"
    PS1='\n\[$bracketcolor\][\[$cwdcolor\]\W\[$bracketcolor\]] \[${fg_cyan}\]${g_group_open}\[${fg_green}\]${g_branch_icon}\[${fg_cyan}\]${g_branch}\[${fg_green}\]${g_upstream}\[${fg_yellow}\]${g_ahead_icon}\[${fg_cyan}\]${g_ahead}\[${fg_yellow}\]${g_behind_icon}\[${fg_cyan}\]${g_behind}\[${fg_red}\]${g_change}\[${fg_yellow}\]${g_untrack}\[${fg_cyan}\]${g_group_close}\[${reset}\]\[$fg_white\]\$\[$resetcolor\] '

    ;;
  *)
    PROMPT_COMMAND="git_branch > /dev/null; "
    setterm -cursor on
    cursor_styles="\e[?${cursor_style_full_block};"
    PS1='\n\[$bracketcolor\][\[$cwdcolor\]\W\[$bracketcolor\]] \[${fg_cyan}\]${g_group_open}\[${fg_cyan}\]${g_branch}\[${fg_cyan}\]${g_group_close}\[${reset}\]\[$fg_white\]\$\[$resetcolor\] '

    ;;
esac

export PS1

# Aliases
alias grep='grep --color'
alias ls='ls --color=auto'
alias ddu='du -sch .[!.]* * |sort -h'