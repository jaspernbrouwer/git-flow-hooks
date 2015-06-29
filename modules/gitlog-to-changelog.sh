#!/usr/bin/env bash

function __print_usage {
    echo "Usage: $(basename $0) [<version>] [<changelog_file>]"
    echo "    <version>:          The current version."
    echo "    <changelog_file>:    File that contains the changes."
    exit 1
}

# parse arguments

if [ $# -gt 2 ]; then
    __print_usage
fi

ROOT_DIR=$(git rev-parse --show-toplevel 2> /dev/null)
VERSION="$1"
CHANGELOG_FILE="$2"

if [ -f "$CHANGELOG_FILE" ]; then
    TEMP_FILE="$ROOT_DIR/tmpfile"
    echo "Version $VERSION:" > $TEMP_FILE
    git log --no-merges --pretty=format:" * %s (%an)" "v$VERSION"...HEAD >> $TEMP_FILE
    echo "" >> $TEMP_FILE
    echo "" >> $TEMP_FILE
    cat $CHANGELOG_FILE >> $TEMP_FILE
    mv $TEMP_FILE $CHANGELOG_FILE
    git add $CHANGELOG_FILE
    git commit -m "Wrote changes $CHANGELOG_FILE"
else
    echo "Version $VERSION:" > $CHANGELOG_FILE
    git log --pretty=format:" * %s (%an)" >> $CHANGELOG_FILE
    echo "" >> $CHANGELOG_FILE
    echo "" >> $CHANGELOG_FILE
    git add $CHANGELOG_FILE
    git commit -m "Added CHANGELOG file"
fi
