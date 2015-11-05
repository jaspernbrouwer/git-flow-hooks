#!/usr/bin/env bash

COLOR_RED=$(printf '\e[0;31m')
COLOR_DEFAULT=$(printf '\e[m')
ICON_CROSS=$(printf $COLOR_RED'✘'$COLOR_DEFAULT)

ROOT_DIR=$(git rev-parse --show-toplevel 2> /dev/null)
HOOKS_DIR=$(dirname $SCRIPT_PATH)

if [ -f "$HOOKS_DIR/git-flow-hooks-config.sh" ]; then
    . "$HOOKS_DIR/git-flow-hooks-config.sh"
fi

if [ -f "$ROOT_DIR/.git/git-flow-hooks-config.sh" ]; then
    . "$ROOT_DIR/.git/git-flow-hooks-config.sh"
fi

function __print_fail {
    echo -e "  $ICON_CROSS $1"
}

function __get_commit_files {
    echo $(git diff-index --name-only --diff-filter=ACM --cached HEAD --)
}

function __get_version_file {
    if [ -z "$VERSION_FILE" ]; then
        VERSION_FILE="VERSION"
    fi

    echo "$ROOT_DIR/$VERSION_FILE"
}

function __get_hotfix_version_bumplevel {
    if [ -z "$VERSION_BUMPLEVEL_HOTFIX" ]; then
        VERSION_BUMPLEVEL_HOTFIX="PATCH"
    fi

    echo $VERSION_BUMPLEVEL_HOTFIX
}

function __get_release_version_bumplevel {
    if [ -z "$VERSION_BUMPLEVEL_RELEASE" ]; then
        VERSION_BUMPLEVEL_RELEASE="MINOR"
    fi

    echo $VERSION_BUMPLEVEL_RELEASE
}

function __get_current_version {
    # read git tags
    VERSION_PREFIX=$(git config --get gitflow.prefix.versiontag)
    VERSION_TAG=$(git tag -l "$VERSION_PREFIX*" | $VERSION_SORT | tail -1)

    if [ ! -z "$VERSION_TAG" ]; then
        if [ ! -z "$VERSION_PREFIX" ]; then
            VERSION_CURRENT=${VERSION_TAG#$VERSION_PREFIX}
        else
            VERSION_CURRENT=$VERSION_TAG
        fi
    fi

    echo $VERSION_CURRENT
}

function __get_use_changelog {
    if [ -z "$USE_CHANGELOG" ]; then
        USE_CHANGELOG=false
    fi

    echo $USE_CHANGELOG
}

function __get_changelog_file_name {
    if [ -z "$CHANGELOG_FILE_NAME" ]; then
        CHANGELOG_FILE_NAME="CHANGELOG"
    fi

    echo $CHANGELOG_FILE_NAME
}
