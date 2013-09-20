git-flow-hooks
==============

Some useful hooks for [git-flow (AVH Edition)][1].

What does it do?
================

- Prevent direct commits to the master branch.
- Prevent merge marker commits.
- Automatically bump versions when starting a release or hotfix.

Installation
============

- Clone this repository somewhere on your disk.
- Remove the `.git/hooks` directory in your repository.
- Symlink the git-flow-hooks repository to `.git/hooks` in your repository.
- Enjoy!

Update
======

Just do a `git pull` in the git-flow-hooks repository.

License
=======

git-flow-hooks is published under The MIT License, see [LICENSE][2] file

Note that these hooks are built for [git-flow (AVH Edition)][1] by Peter van der Does, which has its own [licences][3].

[1]: https://github.com/petervanderdoes/gitflow
[2]: https://github.com/jaspernbrouwer/git-flow-hooks/blob/master/LICENSE
[3]: https://github.com/petervanderdoes/gitflow/blob/master/LICENSE

