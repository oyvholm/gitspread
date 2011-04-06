README for gitspread
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

- Create a directory called `$HOME/Git-spread/`.
- Create a bare repository for each project under that directory:
  - `git init --bare $HOME/Git-spread/project.git`
- Copy the `post-receive` hook script to the `hooks/` directory in the 
  repository:
  - `cp -p post-receive $HOME/Git-spread/project.git/hooks/`
  - or manually insert the code into an existing hook script.
- Define all necessary remotes using SSH push URLs, for example:
  - `git remote add gitorious git@gitorious.org:foo/project.git`
  - `git remote add github git@github.com:user/project.git`
- Start the `gitspreadd` daemon in a shell where `ssh-agent` is 
  activated:
  - `ssh-agent bash`
  - `ssh-add .ssh/id_dsa`
  - `./gitspreadd`
- Set up a git remote on the local computer which has a slow connection:
  - `git remote add spread 
    user@example.org:/home/user/Git-spread/project.git`

That’s all there is. From now on, you can push to the "spread" remote 
and let the remote server with a faster connection take care of 
spreading the commits around.

If you don’t want to use `$HOME/Git-spread` as the location for the 
repositories, change the value of `$repodir` in `gitspreadd` and 
`post-receive`.

Source code
-----------

Gitspread can be cloned from the following repositories:

- `git://gitorious.org/sunny256/gitspread.git`
- `git://github.com/sunny256/gitspread.git`
- `git://repo.or.cz/gitspread.git`

License
-------

Author: Øyvind A. Holm <sunny@sunbase.org>
License: GNU General Public License version 3 or later

This program is free software: you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published by the 
Free Software Foundation, either version 3 of the License, or (at your 
option) any later version.

This program is distributed in the hope that it will be useful, but 
WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General 
Public License for more details.

You should have received a copy of the GNU General Public License along 
with this program. If not, see <http://www.gnu.org/licenses/>.
