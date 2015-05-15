#!/usr/bin/env bash

COLOR_RED=$(printf '\e[0;31m')
COLOR_DEFAULT=$(printf '\e[m')
ICON_CROSS=$(printf $COLOR_RED'✘'$COLOR_DEFAULT)

ROOT_DIR=$(git rev-parse --show-toplevel 2> /dev/null)
HOOKS_DIR=$(dirname $SCRIPT_PATH)

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


git_local_branch_exists() {
	[ -n "$1" ] || die "Missing branch name"
	[ -n "$(git for-each-ref --format='%(refname:short)' refs/heads/$1)" ]
}

# Function used to check if the repository is git-flow enabled.
gitflow_has_master_configured() {
	local master

	master=$(git config --get gitflow.branch.master)
	[ "$master" != "" ] && git_local_branch_exists "$master"
}

gitflow_has_develop_configured() {
	local develop

	develop=$(git config --get gitflow.branch.develop)
	[ "$develop" != "" ] && git_local_branch_exists "$develop"
}

gitflow_has_prefixes_configured() {
	git config --get gitflow.prefix.feature >/dev/null 2>&1     && \
	git config --get gitflow.prefix.release >/dev/null 2>&1     && \
	git config --get gitflow.prefix.hotfix >/dev/null 2>&1      && \
	git config --get gitflow.prefix.support >/dev/null 2>&1     && \
	git config --get gitflow.prefix.versiontag >/dev/null 2>&1
}

gitflow_is_initialized() {
	gitflow_has_master_configured                    && \
	gitflow_has_develop_configured                   && \
	[ "$(git config --get gitflow.branch.master)" != "$(git config --get gitflow.branch.develop)" ] && \
	gitflow_has_prefixes_configured
}
