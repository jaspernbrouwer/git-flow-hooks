git-flow-hooks
==============

Some useful hooks for [git-flow (AVH Edition)][1].

What does it do?
================

- Prevent direct commits to the master branch.
- Prevent merge marker commits.
- Automatically bump versions when starting a release or hotfix. Versions are generated, written to file and committed.

Usage
=====

Install
-------

- `git clone` this repository somewhere on your disk.
- Remove the `.git/hooks` directory in your repository.
- Symlink the git-flow-hooks directory to `.git/hooks` in your repository.
- Optionally copy `.git/hooks/modules/git-flow-hooks-config.sh.dist` to `.git/git-flow-hooks-config.sh` and set values according to your wishes.

Update
------

- Run `git pull` in the git-flow-hooks directory.

That's it, all your repositories that have symlinked git-flow-hooks will use the latest version.

Starting releases and hotfixes
------------------------------

If `git flow release start` and `git flow hotfix start` are run without a version, the version will be bumped based on the latest git tag. If no git tags are found, the version-file is used. If the version-file isn't found, 0.0.0 will be bumped.

Alternatively you may use `patch`, `minor` and `major` as version. A bump of that level will take place.

If the commands are run with version, that version will be used (no bumping).

License
=======

git-flow-hooks is published under The MIT License, see the [LICENSE][2] file.

Note that these hooks are built for [git-flow (AVH Edition)][1] by Peter van der Does, which has its own [licenses][3].

The scripts for preventing master and merge marker commits are based on [git-hooks][4] by Sitebase.

[1]: https://github.com/petervanderdoes/gitflow
[2]: https://github.com/jaspernbrouwer/git-flow-hooks/blob/master/LICENSE
[3]: https://github.com/petervanderdoes/gitflow/blob/master/LICENSE
[4]: https://github.com/Sitebase/git-hooks
