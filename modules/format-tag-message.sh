#!/usr/bin/env bash

if [ -z "$VERSION_TAG_PLACEHOLDER" ]; then
    VERSION_TAG_PLACEHOLDER = "%tag%"
fi

MESSAGE=$(echo "$MESSAGE" | sed s/$VERSION_TAG_PLACEHOLDER/$VERSION/g)
