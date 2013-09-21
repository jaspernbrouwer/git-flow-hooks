#!/usr/bin/env bash

CURRENT_BRANCH=$(git symbolic-ref HEAD)

if [ "$CURRENT_BRANCH" == "refs/heads/master" ]; then
    __print_fail "Direct commits to the master branch are not allowed."
    return 1
else
    return 0
fi
