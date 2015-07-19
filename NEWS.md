Summary of changes in Gitspread
===============================

For a complete log of changes, please refer to the Git commit log in the 
repositories mentioned in `README.md`.

v0.1x.x - 20xx-xx-xx
--------------------

- Rename `NEWS` to `NEWS.md` and add proper CommonMark/Markdown syntax
- Add the `t/remove_perltestnumbers` script to make "`make test`" work 
  everywhere

v0.11.0 - 2015-07-11
--------------------

- Use Semantic Versioning as described at <http://semver.org>
- Add `$GITSPREAD_GIT` environment variable, allow alternative `git`(1)
- Add the scripts `t/Add_test` (create a new test file) and `t/Genlog` 
  (execute the tests, format output and save output to log/)
- Create `Makefile`s to run tests
- `gitspreadd`, `gitspreadd.t`: Remove unused debug functions and 
  `--debug` option
- Sync `gitspreadd` against "perl" template
- Sync `gitspreadd.t` against "perl-tests" template
- Tests: Quote all variables in system calls
- Tests: Read stdout from daemon instead of leaking it to test output
- Create and use `main()` in `gitspreadd` and `gitspreadd.t`
- Tests: Add "` (stdout)`" to output
- Tested to work with Git versions back to 2008-03-26
- Documentation and typo fixes

v0.10 - 2015-05-31
------------------

- Change license from "GPL v3 or later" to "GPL v2 or later"
- Fix failing tests due to changed output from newer `git`(1) versions
- Add `-q`/`--quiet` option to `gitspreadd`
- Delete obsolete bash version of gitspreadd
- Change official gitspread location from GitHub.com to GitLab.com
- Replace Gitorious location with GitLab
- Documentation updates
- Delete Perl POD, documentation is stored as CommonMark/MarkDown

v0.02 - 2011-04-24
------------------

- Deleted branches are propagated further to the remotes
- Update tests to all current functionality (total 206 tests)
- Make tests work with old Git versions, at least back to git-1.5.6.5
- Add `COPYING` (GNU General Public License v3)
- Add this file (`NEWS`)
- Update `README.md`
- Remove wrong info from `usage()` screen
- Remove annoying `close()` warning in log file

v0.01 - 2011-04-09
------------------

- Convert gitspreadd from Bash to Perl
- Rename Bash version to `gitspreadd.sh` and mark it as obsolete
- Add `-r`/`--repodir` option
- Add `-1`/`--run-once` option
- Log actions to log file
- Add support for `$GITSPREAD_REPODIR` environment variable
- Set up test suite and create tests for all current functionality

Pre-0.01 (Bash version)
-----------------------

- Initial release using bash scripts.

vim: set tw=72 ts=2 sw=2 sts=2 fo=tcqw fenc=utf8 :
