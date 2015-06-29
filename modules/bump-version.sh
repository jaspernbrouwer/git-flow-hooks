#!/usr/bin/env bash

if [ -z "$VERSION" ]; then
    if [ "$1" == "hotfix" ]; then
        VERSION=$(__get_hotfix_version_bumplevel)
    elif [ "$1" == "release" ]; then
        VERSION=$(__get_release_version_bumplevel)
    else
        VERSION="PATCH"
    fi
fi

VERSION_FILE=$(__get_version_file)
VERSION=$($HOOKS_DIR/modules/semverbump.sh $VERSION $VERSION_FILE)

USE_CHANGELOG=$(__get_use_changelog)
if [ "$USE_CHANGELOG" = true ]; then
    CHANGELOG_FILE=$(__get_changelog_file)
    $($HOOKS_DIR/modules/gitlog-to-changelog.sh $VERSION $CHANGELOG_FILE)
fi

if [ $? -ne 0 ]; then
    __print_fail "Unable to bump version."
    return 1
else
    return 0
fi
