#!/usr/bin/env bash

function __print_usage {
    echo "Usage: $(basename $0) [<command>] [<version>] [<action>]"
    echo "    <command>:     release/hotfix"
    echo "    <version>:     version"
    echo "    <action>:      started/finished"
    exit 1
}

if [ $# -gt 3 ]; then
    __print_usage
fi

COMMAND=$1
CURRENT_VERSION=$2
ACTION=$3

USER=`git config user.name`

if [[ $ACTION == "finished" ]]; then
  PREV_VERSION=$(git describe --abbrev=0 --tags $(git rev-list --tags --max-count=2) | $VERSION_SORT -V | head -1)
  CHANGES=$(git log --no-merges --pretty=format:"%s (%an)\n" "$CURRENT_VERSION"..."$PREV_VERSION")
fi

if [[ $ACTION == "started" ]]; then
  PREV_VERSION=$(git describe --abbrev=0 --tags $(git rev-list --tags --max-count=1))
  CHANGES=$(git log --no-merges --pretty=format:"%s (%an)\n" "$COMMAND/$CURRENT_VERSION"..."$PREV_VERSION")
fi

. "$HOOKS_DIR/modules/notify-slack.sh" $COMMAND $CURRENT_VERSION $ACTION "$USER" "$CHANGES"
. "$HOOKS_DIR/modules/notify-hipchat.sh" $COMMAND $CURRENT_VERSION $ACTION "$USER" "$CHANGES"
