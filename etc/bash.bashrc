# /etc/bash.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#  Customize Bash Prompt {{{1
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '

if [ -n "$DISPLAY" ]; then
  . /usr/lib/python3.4/site-packages/powerline/bindings/bash/powerline.sh
else
  bash_prompt_cmd() {
    local CY="\[\e[1;36m\]" # Each is 12 chars long
    local BL="\[\e[1;34m\]"
    local WH="\[\e[1;37m\]"
    local BR="\[\e[0;33m\]"
    local RE="\[\e[1;31m\]"
    local PROMPT="${CY}$"
    [ $UID -eq "0" ] && PROMPT="${RE}#"

    # Add the first part of the prompt: username,host, and time
    local PROMPT_PWD=""
    local PS1_T1="$BL[$CY`whoami`@`hostname` $BL:$RE\d \t$BL:$CY"
    local ps_len=$(( ${#PS1_T1} - 12 * 6 + 6 + 4 )) #Len adjust for colors, time and var
    local PS1_T2=" $BL]${PROMPT} \[\e[0m\]"
    local startpos=""

    PROMPT_PWD="${PWD/#$HOME/~}"
    local overflow_prefix="..."
    local pwdlen=${#PROMPT_PWD}
    local maxpwdlen=$(( COLUMNS - ps_len ))
    # Sometimes COLUMNS isn't initiliased, if it isn't, fall back on 80
    [ $maxpwdlen -lt 0 ] && maxpwdlen=$(( 80 - ps_len ))

    if [ $pwdlen -gt $maxpwdlen ] ; then
      startpos=$(( $pwdlen - maxpwdlen + ${#overflow_prefix} ))
      PROMPT_PWD="${overflow_prefix}${PROMPT_PWD:$startpos:$maxpwdlen}"
    fi
    export PS1="${PS1_T1}${PROMPT_PWD}${PS1_T2}"
    history -a
    echo -ne '\a'
  }
  PROMPT_COMMAND=bash_prompt_cmd
fi
PS2='> '
PS3='> '
PS4='+ '

case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

    ;;
  screen*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac
# }}}

#  Include Environment Variable {{{1
source /etc/myenvvar

xhost +local:root > /dev/null 2>&1
# }}}

#  Bash专有设置 {{{1
#    Bash历史设置 {{{2
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
HISTIGNORE="&:cd:df:du:exit:gvim:ls:mv:nano:pydf:reset:rm:shutdown:vim"
# }}}

#    Bash选项 {{{2
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s hostcomplete
shopt -s nocaseglob
# }}}

#    Make less more friendly for non-text input files {{{2
# see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
# }}}

#    [Disabled]Set variable identifying the chroot you work in (used in the prompt below) {{{2
#if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
#    debian_chroot=$(cat /etc/debian_chroot)
#fi
# }}}

#    Bash颜色设置 {{{2

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
  *)
    ;;
esac

#      enable color support of ls and also add handy aliases {{{3
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi
# }}}
# }}}

#    Set Vi Mode {{{2
set -o vi
# }}}
# }}}

#  Aliases {{{1

#    自己收集的 Aliases {{{2
source /etc/myaliases
# }}}

#    Extract alias{{{2
source /usr/share/oh-my-zsh/plugins/extract/extract.plugin.zsh
# }}}

#    Systemd aliases & short command compatible with initscripts{{{2
source /usr/share/oh-my-zsh/plugins/systemd/systemd.plugin.zsh
# }}}

#    Alias definitions. {{{2
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# }}}

#    [Disabled]ex - archive extractor (From Ubuntu's .bashrc){{{2
# usage: ex <file>
# ex ()
# {
#   if [ -f $1 ] ; then
#     case $1 in
#     *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz)))))
#                    bsdtar xvf $1;;
#       *.bz2)       bunzip2 $1   ;;
#       *.rar)       unrar x $1   ;;
#       *.gz)        gunzip $1    ;;
#       *.zip)       unzip $1     ;;
#       *.Z)         uncompress $1;;
#       *.7z)        7z x $1      ;;
#     *.xz)      unxz $1      ;;
#       *)           echo "'$1' cannot be extracted via ex()" ;;
#     esac
#   else
#     echo "'$1' is not a valid file"
#   fi
# }
# }}}

# }}}

#  Include Bash Completion {{{1

# use auto completion on these command prefixes (uncompatible with bash-completion, comment it)
#complete -cf sudo
#complete -cf man

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi

  # 拼音补全
  source /usr/share/pinyin-completion/shell/pinyin-comp.bash
fi

# }}}

# vim:foldmethod=marker:autoindent:expandtab:shiftwidth=2:tabstop=2:softtabstop=2
