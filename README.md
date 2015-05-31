README for Gitspread
====================

A project is often stored on several hosting services like 
[Gitorious](http://gitorious.org/), [GitHub](http://github.com/), 
[repo.or.cz](http://repo.or.cz/) or similar for backup purposes. 
Ideally, all these repositories should be updated at the same time when 
pushing. If you’re using a slow Internet connection, like a mobile 
connection from a laptop, this process tends to be rather slow because 
the commits have to be pushed several times over a slow connection. 
Gitspread aims to solve this by pushing the commits once to a server 
with a fast connection, and pushing the commits to all the remotes from 
that server.

Setup
-----

### Server setup

- Create a directory called `$HOME/Git-spread/`.
- Create a bare repository for each project under that directory:
  - `git init --bare $HOME/Git-spread/project.git`
- Copy the `post-receive` hook script to the `hooks/` directory in the 
  repository:
  - `cp -p post-receive $HOME/Git-spread/project.git/hooks/`
  - or manually insert the code if `hooks/post-receive` already exists.
- Define all necessary remotes using SSH push URLs, for example:
  - `cd ~/Git-spread/project.git`
  - `git remote add gitorious git@gitorious.org:foo/project.git`
  - `git remote add github git@github.com:user/project.git`
- Start a [screen](http://www.gnu.org/software/screen/) or 
  [tmux](http://tmux.sourceforge.net/) session.
- Start the `gitspreadd` daemon inside the screen/tmux session in a 
  shell where `ssh-agent` is activated:
  - `ssh-agent bash`
  - `ssh-add ~/.ssh/id_dsa`
  - `gitspreadd`
- Detach the screen/tmux session. `gitspreadd` is now running there even 
  when the current shell is terminated.

### Local computer

- Set up a git remote on the local computer which has a slow connection:
  - `git remote add spread 
    user@example.org:/home/user/Git-spread/project.git`

That’s all there is. From now on, you can push to the "spread" remote 
and let the remote server with a faster connection take care of 
spreading the commits around.

To stop the daemon, create a file named `stop` in the top directory. 
When the file is gone, the process is terminated. The PID of the current 
process is stored in a file named `pid`. This file is also deleted when 
the process terminates properly.

### Directory location

If you don’t want to use `$HOME/Git-spread` as the location for the 
repositories, either set the `$GITSPREAD_REPODIR` environment variable 
to the preferred directory, or change the value of `$repodir` in 
`post-receive` and run `gitspreadd` with the `-r`/`--repodir` option. 
The gitspreadd daemon chooses the directory this way:

Use the location specified by the `-r`/`--repodir` command line option, 
otherwise use `$GITSPREAD_REPODIR` if defined, otherwise use hardcoded 
value `$HOME/Git-spread`.

### Configuration

The following option can be used in the bare repositories:

- gitspread.forcepush
  - If "true", use `-f` (`--force`) option when pushing to the remote 
    repositories. This allows gitspreadd to push non-fast-forward 
    branches. Use with care. Valid values: "", "false" or "true".

Source code
-----------

Gitspread can be cloned from the following repositories:

- `git://github.com/sunny256/gitspread.git`
- `git://gitorious.org/sunny256/gitspread.git`
- `https://bitbucket.org/sunny256/gitspread.git`
- `git://repo.or.cz/gitspread.git`

Git branches
------------

The `master` branch is considered stable and will never be rebased. 
Every new functionality or bug fix is created on topic branches which 
may be rebased now and then. All tests on `master` (executed with "make 
test") should succeed. If any test fails, it’s considered a bug and 
should be reported in the issue tracker.

Bugs and suggestions
--------------------

Bugs and suggestions can be filed in the issue tracker at 
<https://github.com/sunny256/gitspread/issues> .

License
-------

Author: Øyvind A. Holm <sunny@sunbase.org>

License: GNU General Public License version 2 or later

This program is free software: you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published by the 
Free Software Foundation, either version 2 of the License, or (at your 
option) any later version.

This program is distributed in the hope that it will be useful, but 
WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General 
Public License for more details.

You should have received a copy of the GNU General Public License along 
with this program. If not, see 
<http://www.gnu.org/licenses/gpl-2.0.txt>.

    vim: set ft=markdown tw=72 fenc=utf8 et ts=2 sw=2 sts=2 fo=tcqw :
