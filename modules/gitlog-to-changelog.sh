#!/usr/bin/env bash

function __print_usage {
    echo "Usage: $(basename $0) [<version_current>] [<new_version>] [<changelog_file>]"
    echo "    <version_current>:          The current version (before bump)."
    echo "    <new_version>:              The bumped version."
    echo "    <changelog_file>:           File that contains the changes."
    exit 1
}

# parse arguments

if [ $# -gt 3 ]; then
    __print_usage
fi

ROOT_DIR=$(git rev-parse --show-toplevel 2> /dev/null)
VERSION_PREFIX=$(git config --get gitflow.prefix.versiontag)
VERSION_CURRENT="$1"
VERSION="$VERSION_PREFIX$VERSION_CURRENT"
NEW_VERSION="$2"
CHANGELOG_FILE_NAME="$3"
CHANGELOG_FILE="$ROOT_DIR/$CHANGELOG_FILE_NAME"

if [ -f "$CHANGELOG_FILE" ]; then
    TEMP_FILE="$ROOT_DIR/tmpfile"
    echo "Version $NEW_VERSION:" > $TEMP_FILE
    git log --no-merges --pretty=format:" * %s (%an)" "$VERSION"...HEAD >> $TEMP_FILE
    echo "" >> $TEMP_FILE
    echo "" >> $TEMP_FILE
    cat $CHANGELOG_FILE >> $TEMP_FILE
    mv $TEMP_FILE $CHANGELOG_FILE
    git add $CHANGELOG_FILE
    git commit -m "Wrote changes $CHANGELOG_FILE_NAME"
else
    echo "Version $NEW_VERSION:" > $CHANGELOG_FILE
    git log --pretty=format:" * %s (%an)" >> $CHANGELOG_FILE
    echo "" >> $CHANGELOG_FILE
    echo "" >> $CHANGELOG_FILE
    git add $CHANGELOG_FILE
    git commit -m "Added $CHANGELOG_FILE_NAME file"
fi
