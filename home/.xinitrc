#设置slim管理器启动时的fcitx环境变量
export XMODIFIERS="@im=fcitx"
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export LANG="zh_CN.UTF-8"
export LC_ALL="zh_CN.UTF-8"

# GNOME Keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export GPG_AGENT_INFO SSH_AUTH_SOCK

# 手动读取 .Xresources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# 设置 slim 默认值
DEFAULT_SESSION=awesome
case $1 in
  awesome) exec awesome ;;
  *) exec $DEFAULT_SESSION ;;
esac
