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

VERSION="$1"
CHANGELOG_FILE="$2"

if [ -f $CHANGELOG_FILE ]; then
    echo "Version $VERSION:" > tmpfile
    git log --no-merges --pretty=format:" * %s (%an)" "v$VERSION"...HEAD >> tmpfile
    echo "" >> tmpfile
    echo "" >> tmpfile
    cat $CHANGELOG_FILE >> tmpfile
    mv tmpfile $CHANGELOG_FILE
    git add $CHANGELOG_FILE
    git commit -m "Wrote changes $CHANGELOG_FILE"
else
    echo "Version 0.1.0" > $CHANGELOG_FILE
    git log --pretty=format:" - %s (%an)" >> $CHANGELOG_FILE
    echo "" >> $CHANGELOG_FILE
    echo "" >> $CHANGELOG_FILE
    git add $CHANGELOG_FILE
    git commit -m "Added CHANGELOG file"
fi
