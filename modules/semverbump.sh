#!/usr/bin/env bash

function __print_usage {
    echo "Usage: $(basename $0) [major|minor|patch|<semver>] [<version_file>] [<version_sort>]"
    echo "    major|minor|patch: Version will be bumped accordingly."
    echo "    <semver>:          Exact version to use (it won't be bumped)."
    echo "    <version_file>:    File that contains the current version."
    echo "    <version_sort>:    Absolute path to sort binary with optional parameters."
    exit 1
}

function __print_version {
    echo $VERSION_BUMPED
    exit 0
}

# parse arguments

if [ $# -gt 3 ]; then
    __print_usage
fi

VERSION_ARG="$(echo "$1" | tr '[:lower:]' '[:upper:]')"
VERSION_FILE="$2"
VERSION_SORT="$3"

# determine sort command

if [ -z "$VERSION_SORT" ]; then
    if [ -x "/opt/local/bin/gsort" ]; then
        VERSION_SORT="/opt/local/bin/gsort -V"
    elif [ -x "/usr/local/bin/gsort" ]; then
        VERSION_SORT="/usr/local/bin/gsort -V"
    else
        VERSION_SORT="/usr/bin/sort -V"
    fi
fi

# determine bump mode

if [ -z "$VERSION_ARG" ] || [ "$VERSION_ARG" == "PATCH" ]; then
    VERSION_UPDATE_MODE="PATCH"
elif [ "$VERSION_ARG" == "MINOR" ]; then
    VERSION_UPDATE_MODE=$VERSION_ARG
elif [ "$VERSION_ARG" == "MAJOR" ]; then
    VERSION_UPDATE_MODE=$VERSION_ARG
elif [ $(echo "$VERSION_ARG" | grep -E '^[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+$') ]; then
    # semantic version passed as argument
    VERSION_BUMPED=$VERSION_ARG
    __print_version
else
    __print_usage
fi

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

# read version file (if version not found by tags)

if [ -z "$VERSION_CURRENT" ]; then
    if [ -z "$VERSION_FILE" ]; then
        ROOT_DIR=$(git rev-parse --show-toplevel 2> /dev/null)
        VERSION_FILE="$ROOT_DIR/VERSION"
    fi

    if [ -f "$VERSION_FILE" ]; then
        VERSION_CURRENT=$(cat $VERSION_FILE)
    fi
fi

# use 0.0.0 (if version not found by file)

if [ -z "$VERSION_CURRENT" ]; then
    VERSION_CURRENT="0.0.0"
fi

# bump version

VERSION_LIST=($(echo $VERSION_CURRENT | tr '.' ' '))
VERSION_MAJOR=${VERSION_LIST[0]}
VERSION_MINOR=${VERSION_LIST[1]}
VERSION_PATCH=${VERSION_LIST[2]}

if [ "$VERSION_UPDATE_MODE" == "PATCH" ]; then
    VERSION_PATCH=$((VERSION_PATCH + 1))
elif [ "$VERSION_UPDATE_MODE" == "MINOR" ]; then
    VERSION_MINOR=$((VERSION_MINOR + 1))
    VERSION_PATCH=0
else
    VERSION_MAJOR=$((VERSION_MAJOR + 1))
    VERSION_MINOR=0
    VERSION_PATCH=0
fi

VERSION_BUMPED="$VERSION_MAJOR.$VERSION_MINOR.$VERSION_PATCH"

__print_version
