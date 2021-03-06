#!/bin/bash
#set -e

#  Define variable {{{1
ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
ABSOLUTE_ETC_PATH=${ABSOLUTE_PATH}/etc
ETC_PATH=/etc
# }}}

#  Define function {{{1
fail() {
  echo $1
  exit 1
}

update() {
  local src=$1
  local dest=$2
  [ !  -e "$src" ] && echo "Copy source does not exist: $src" && return 1

  #if the source is a symlink, make sure its up-to-date
  if [ -h "$dest" ]; then
    rm $dest
  fi
  #make sure the parent directory exists
  local parent=$(dirname $dest)
  [ ! -d "$parent" ] && mkdir -p $parent
  #Finally copy
  echo "Updating $src -> $dest"
  cp $src $dest
}
# }}}

#  Operation {{{1
#  Ensure cwd is the root of the dotfile checkout {{{2
pushd $ABSOLUTE_PATH >/dev/null
# }}}

#  Update /etc config {{{2
for f in adobe/mms.cfg \
         asd.conf \
         bash.bashrc \
         burg.d/40_custom \
         ca-certificates/conf.d/goagent.conf \
         default/burg \
         default/cpupower \
         default/phc-intel \
         default/ufw \
         default/useradd \
         dhcpcd.conf \
         dnsmasq.conf \
         e4rat-lite.conf \
         environment \
         fstab \
         group \
         gimp/2.0/fonts.conf \
         inputrc \
         lightdm/lightdm.conf.d/60-my-unity-greeter.conf \
         lightdm/lightdm-gtk-greeter.conf \
         locale.conf \
         makepkg.conf \
         mkinitcpio.d/linux-ck.preset \
         mkinitcpio.conf \
         mkinitcpio.fallback.conf \
         modprobe.d/modprobe.conf \
         modules-load.d/acpi-cpufreq.conf \
         modules-load.d/cpufreq_ondemand.conf \
         modules-load.d/cpufreq_powersave.conf \
         modules-load.d/overlay.conf \
         myaliases \
         myenvvar \
         mysql/my.cnf \
         nginx/nginx.conf \
         pacman.conf \
         passwd \
         pam.d/login \
         pam.d/passwd \
         php/php.ini \
         profile \
         psd.conf \
         slim.conf \
         ssh/sshd_config \
         systemd/system/goagent.service.d/nostdout.conf \
         timezone \
         tsocks.conf \
         vconsole.conf \
         xdg/menus/arch-applications.menu \
         yaourtrc; do
  update ${ETC_PATH}/$f ${ABSOLUTE_ETC_PATH}/$f
done
# }}}

#  Back to the original directory {{{2
popd >/dev/null
# }}}

echo "Done"
# }}}

# vim:fdm=marker:et:sw=2:
