#!/usr/bin/env bash

CURRENT_BRANCH=$(git symbolic-ref HEAD)
MASTER_BRANCH=$(git config --get gitflow.branch.master)

if [ "$CURRENT_BRANCH" == "refs/heads/$MASTER_BRANCH" ]; then
    __print_fail "Direct commits to the $MASTER_BRANCH branch are not allowed."
    return 1
else
    return 0
fi
