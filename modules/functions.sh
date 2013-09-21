#!/usr/bin/env bash

COLOR_RED=$(printf '\e[0;31m')
COLOR_DEFAULT=$(printf '\e[m')
ICON_CROSS=$(printf $COLOR_RED'✘'$COLOR_DEFAULT)

function __print_fail {
    echo -e "  $ICON_CROSS $1"
}

function __get_commit_files {
    echo $(git diff-index --name-only --diff-filter=ACM --cached HEAD --)
}

function __get_version_file {
    if [ -z $VERSION_FILE ]; then
        VERSION_FILE="VERSION"
    fi

    echo $VERSION_FILE
}

function __get_hotfix_version_bumplevel {
    if [ -z $VERSION_BUMPLEVEL_HOTFIX ]; then
        VERSION_BUMPLEVEL_HOTFIX="PATCH"
    fi

    echo $VERSION_BUMPLEVEL_HOTFIX
}

function __get_release_version_bumplevel {
    if [ -z $VERSION_BUMPLEVEL_RELEASE ]; then
        VERSION_BUMPLEVEL_RELEASE="PATCH"
    fi

    echo $VERSION_BUMPLEVEL_RELEASE
}
