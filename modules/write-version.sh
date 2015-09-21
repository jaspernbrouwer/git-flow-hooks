#!/usr/bin/env bash

VERSION_FILE=$(__get_version_file)
VERSION_PREFIX=$(git config --get gitflow.prefix.versiontag)

if [ ! -z "$VERSION_PREFIX" ]; then
    VERSION=${VERSION#$VERSION_PREFIX}
fi

if [ -z "$VERSION_BUMP_MESSAGE" ]; then
    VERSION_BUMP_MESSAGE="Bump version to %version%"
fi

echo -n "$VERSION" > $VERSION_FILE && \
    git add $VERSION_FILE && \
    git commit -m "$(echo "$VERSION_BUMP_MESSAGE" | sed s/%version%/$VERSION/g)"

if [ $? -ne 0 ]; then
    __print_fail "Unable to write version to $VERSION_FILE."
    return 1
else
    return 0
fi
