# Path to your oh-my-zsh installation.
if [[ "$OSTYPE" = darwin* ]]; then
  ZSH=$HOME/.oh-my-zsh/
elif [[  $('uname') == 'Linux' ]]; then
  ZSH=/usr/share/oh-my-zsh/
fi


# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

if [[ "$OSTYPE" = darwin* ]]; then
  DEFAULT_USER="f22z"
elif [[  $('uname') == 'Linux' ]]; then
  DEFAULT_USER="f"
fi

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
if [[ "$OSTYPE" = darwin* ]]; then
  plugins=(autojump docker extract git gulp history-substring-search node npm osx pip python sudo svn tmux vi-mode vscode xcode yarn)
elif [[  $('uname') == 'Linux' ]]; then
  plugins=(autojump docker extract fbterm git gulp history-substring-search node npm pip python sudo svn systemd tmux vi-mode yarn)
fi

source $ZSH/oh-my-zsh.sh

# User configuration

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Customize to your needs...

# 命令渐进提示
## auto-fu.zsh stuff.
# source $HOME/codes/auto-fu.zsh/auto-fu.zsh
{ . $HOME/.zsh/auto-fu; auto-fu-install; }
zstyle ':auto-fu:highlight' input bold
zstyle ':auto-fu:highlight' completion fg=black,bold
zstyle ':auto-fu:highlight' completion/one fg=white,bold,underline
zstyle ':auto-fu:var' postdisplay $'\n-azfu-'
zstyle ':auto-fu:var' track-keymap-skip opp
zle-line-init () {auto-fu-init;}; zle -N zle-line-init
zle -N zle-keymap-select auto-fu-zle-keymap-select

# 引入环境变量及命令别名
source /etc/myenvvar
source /etc/myaliases

if [[ "$OSTYPE" = darwin* ]]; then
  # 拼音补全
  # source /usr/share/pinyin-completion/shell/pinyin-comp.zsh

  # Powerline
  . /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
elif [[  $('uname') == 'Linux' ]]; then
  # 拼音补全
  source /usr/share/pinyin-completion/shell/pinyin-comp.zsh

  # Powerline
  . /usr/share/zsh/site-contrib/powerline.zsh
fi

# 在没有输入任何内容的情况下按 TAB ，自动填入 "cd [TAB]"
user-complete(){
  if [[ -n $BUFFER ]] ; then  # 如果该行有内容
    zle expand-or-complete    # 执行 TAB 原来的功能
  else                        # 如果没有
    BUFFER="cd "              # 填入 cd（空格）
    zle end-of-line           # 这时光标在行首，移动到行末
    zle expand-or-complete    # 执行 TAB 原来的功能
  fi
}
zle -N user-complete
bindkey "\t" user-complete    # 将上面的功能绑定到 TAB 键

# Enhanced History Search
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# Emulate 256 color mode only when fbterm is active
[ -n "$FBTERM" ] && export TERM=fbterm

# 不保留重复的历史记录项
setopt hist_ignore_all_dups

# 在命令前添加空格，不将此命令添加到记录文件中
setopt hist_ignore_space

# zsh 4.3.6 doesn't have this option
setopt hist_fcntl_lock 2>/dev/null
setopt hist_reduce_blanks

# FIXME 警告 "grep: warning: GREP_OPTIONS is deprecated; please use an alias or script" 的临时解决方法
# 取自 https://bbs.archlinux.org/viewtopic.php?pid=1478573
# alias grep="/usr/bin/grep $GREP_OPTIONS"
# unset GREP_OPTIONS

# 补充 /usr/share/oh-my-zsh/plugins/git/git.plugin.zsh
alias grfe='git reflog expire --expire=now --all'
compdef _git grfe=git-reflog
alias ggc='git gc --prune=now'
compdef _git ggc=git-gc
alias ggca='git gc --prune=now --aggressive'
compdef _git ggca=git-gc

# Set Zsh completion for osc
export ZSH_OSC_PROJECTS_EXTRA="home:firef0x home:firef0x:testing"

if [[ "$OSTYPE" = darwin* ]]; then
  # Opt out Homebrew analytics
  export HOMEBREW_NO_ANALYTICS=1
  # 替换 homebrew bottles 为中科大源
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
fi

# vim:filetype=zsh:foldmethod=marker:autoindent:expandtab:shiftwidth=2:tabstop=2:softtabstop=2
