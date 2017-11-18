#!/bin/bash

# ---  Automatically generate a file with git branch and revision info
# ---
# --- Example:
# ---   [master]v2.0.0-beta-191(a830382)
# --- Install:
# ---  cp tools/git-create-revisioninfo-hook.sh .git/hooks/pre-push
# ---  cp tools/git-create-revisioninfo-hook.sh .git/hooks/post-checkout
# ---  cp tools/git-create-revisioninfo-hook.sh .git/hooks/post-merge
# ---  chmod +x .git/hooks/post-*
# ---  chmod +x .git/hooks/pre-*

FILENAME='gitrevision'

exec 1>&2
branch=`git rev-parse --abbrev-ref HEAD`
shorthash=`git log --pretty=format:'%h' -n 1`
revcount=`git log --oneline | wc -l`

latesttag=`git describe --tags --abbrev=0`
if [ $? -ne 0 ]; then
  latesttag="none"
fi

VERSION="[$branch]$latesttag-$revcount($shorthash)"
echo ${VERSION} > ${FILENAME}

git add ${FILENAME}
#git commit -m 'gitrevision' ${FILENAME}
