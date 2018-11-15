git-flow-hooks
==============

Some useful hooks for [git-flow (AVH Edition)][1].

What does it do?
================

- Prevent direct commits to the master branch.
- Prevent merge marker commits.
- Automatically bump versions when starting a release or hotfix. Versions are generated, written to file and committed.
- Automatically specify tag messages.

Usage
=====

Install
-------

Clone this repository somewhere on your disk.

```sh
git clone git@github.com:jaspernbrouwer/git-flow-hooks.git
```

Whenever you read `/path/to/git-flow-hooks`, replace it with the actual path to your clone/working copy.

### OS X

OS X doesn't support `sort -V`, which is used to sort git tags by version number, which in turn is needed to correctly bump versions.

On OS X you can install [coreutils][6] (using [MacPorts][7] or [Homebrew][8]), after which `gsort -V` can be used.
If it's located at `/opt/local/bin/gsort` or `/usr/local/bin/gsort` we will pick it up automatically.
Otherwise we fall back to `/usr/bin/sort`.

Optionally you can use the configuration option `VERSION_SORT` to point to a different command.

Activate
--------

Initialize git-flow.

```sh
git flow init
```

It will ask you some questions, the last will be `Hooks and filters directory?`, which you can answer with `/path/to/git-flow-hooks`.

If you've already initialized git-flow, you can still set/change the path manually.

```sh
git config gitflow.path.hooks /path/to/git-flow-hooks
```

### Prevention hooks

The hooks that prevent direct commits to the master branch, and prevent merge marker commits, are `pre-commit` hooks.

These only function if they're located in the `.git/hooks` directory of your working copy.
In other words, after activating like described above, these hooks still won't kick in.

I see 2 options:

1. In stead of activating like described above, remove the `.git/hooks` directory and make it a symbolic link (`ln -s /path/to/git-flow-hooks .git/hooks`).
2. Create a symbolic link to the `pre-commit` file (`ln -s /path/to/git-flow-hooks/pre-commit .git/hooks/pre-commit`).

If you know a better way to use the `pre-commit` hooks, please let me know by opening an issue!

Update
------

Simply pull any updates from origin.

```sh
cd /path/to/git-flow-hooks
git pull
```

That's it, all your repositories that have git-flow initialized and use `/path/to/git-flow-hooks` as hooks and filters directory will be up-to-date.

Configuration
-------------

This is completely optional!

#### Global

Copy the file `/path/to/git-flow-hooks/modules/git-flow-hooks-config.sh.dist` to `/path/to/git-flow-hooks/git-flow-hooks-config.sh` (hooks directory) and change whatever you like.

#### Local

Copy the file `/path/to/git-flow-hooks/modules/git-flow-hooks-config.sh.dist` to `.git/git-flow-hooks-config.sh` (repository root) and change whatever you like.

Any settings in the local configuration file will override settings in the global one. So remove settings you _don't_ want to override.

#### git-flow

[git-flow (AVH Edition)][1] has some useful configuration options too.
See its [wiki][5] for a complete list.
Or you can type `git flow <command> [<subcommand>] --help`.

Starting releases and hotfixes
------------------------------

If `git flow release start` and `git flow hotfix start` are run without a version, the version will be bumped automatically.
Releases will be bumped at the minor level (`1.2.3` becomes `1.3.0`), hotfixes at the patch level (`1.2.3` becomes `1.2.4`).
The hooks will look at the git tags to find the version to bump.
If no tags are found, it looks for the version-file.
If that isn't found, it assumes the current version is `0.0.0`.

Alternatively you may use `patch`, `minor` and `major` as version.
A bump of that level will take place.

If the commands are run with version, that version will be used (no bumping).

Bump messages
-------------

git-flow-hooks bumps the version in a commit with the message "Bump version to %version%".

If you want to use a different message, you can change it in the git-flow-hooks configuration.

Automatic tag messages
----------------------

If you want tag messages to be automated (you won't be bothered with your editor to specify it), use the following configuration options:

```sh
git config gitflow.hotfix.finish.message "Hotfix %tag%"
git config gitflow.release.finish.message "Release %tag%"
```

If you like, you can change the tag-placeholder (`%tag%` in the example above) in the git-flow-hooks configuration.

Plugins
-------

We want to create a plugin-like structure where users can add functionality in a more uniform way.
Unfortunately, that would take some time and testing to implement.

While it's in progress, you can try to use the following forks:

* [Send notifications with changelog to Slack and HipChat](https://github.com/exAspArk/git-flow-hooks/tree/notify#sending-notifications) ([diff](https://github.com/jaspernbrouwer/git-flow-hooks/compare/master...exAspArk:notify))

License
=======

git-flow-hooks is published under The MIT License, see the [LICENSE][2] file.

Note that these hooks are built for [git-flow (AVH Edition)][1] by Peter van der Does, which has its own [licenses][3].

The scripts for preventing master and merge marker commits are based on [git-hooks][4] by Sitebase.

[1]: https://github.com/petervanderdoes/gitflow
[2]: https://github.com/jaspernbrouwer/git-flow-hooks/blob/master/LICENSE
[3]: https://github.com/petervanderdoes/gitflow/blob/master/LICENSE
[4]: https://github.com/Sitebase/git-hooks
[5]: https://github.com/petervanderdoes/gitflow/wiki/Reference:-Configuration
[6]: http://www.gnu.org/software/coreutils
[7]: http://www.macports.org/
[8]: http://brew.sh/
