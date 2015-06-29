#!/usr/bin/env bash

# Move to own file.
USE_CHANGELOG=$(__get_use_changelog)
if [ "$USE_CHANGELOG" = true ]; then
	VERSION_CURRENT=$(__get_current_version)
    CHANGELOG_FILE_NAME=$(__get_changelog_file_name)
    CHANGE=$($HOOKS_DIR/modules/gitlog-to-changelog.sh $VERSION_CURRENT "$CHANGELOG_FILE_NAME")
fi

if [ -z "$VERSION_TAG_PLACEHOLDER" ]; then
    VERSION_TAG_PLACEHOLDER = "%tag%"
fi

MESSAGE=$(echo "$MESSAGE" | sed s/$VERSION_TAG_PLACEHOLDER/$VERSION/g)
