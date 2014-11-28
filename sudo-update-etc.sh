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
  [ !  -e "$src" ] && fail "Copy source does not exist: $src"

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
  chown f:users $dest
  chmod 0644 $dest
}
# }}}

#  Operation {{{1
#  Ensure cwd is the root of the dotfile checkout {{{2
pushd $ABSOLUTE_PATH >/dev/null
# }}}

#  Update /etc config {{{2
for f in sudoers; do
  update ${ETC_PATH}/$f ${ABSOLUTE_ETC_PATH}/$f
done
# }}}

#  Back to the original directory {{{2
popd >/dev/null
# }}}

echo "Done"
# }}}

# vim:fdm=marker:et:sw=2:

