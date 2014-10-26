#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

#设置slim管理器启动时的fcitx环境变量
export XMODIFIERS="@im=fcitx"
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export LANG="zh_CN.UTF-8"
export LC_ALL="zh_CN.UTF-8"

# GNOME Keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)

# 手动读取 .Xresources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# 启动会话
exec $1
