#!/bin/bash

#=======================================================================
# gitspreadd
# File ID: 9277e412-5ebe-11e0-ae13-fefdb24f8e10
# Push received commits and tags to other remotes to save bandwith
# License: GNU General Public License version 2 or later.
#=======================================================================

# This file is obsolete, and is superseded by the Perl version.

progname=gitspreadd
repodir=$HOME/Git-spread
spool=$repodir/spool
logfile=$repodir/$progname.log

log() {
    echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ -") $*" >>$logfile
}

log Starting $progname
while :; do
    if [ -e $spool/* ]; then
        log $progname: Found new commits: $(cd $spool; ls)
        cd $spool || { log $progname: $spool: Cannot chdir, aborting; exit 1; }
        for f in *; do
            log $progname: Processing $f
            cd $repodir/$f.git || { log $progname: $repodir/$f.git: Cannot chdir, aborting >&2; exit 1; }
            force="$(git config --get gitspread.forcepush)"
            if [ "$force" != "true" -a "$force" != "false" -a ! -z "$force" ]; then
                log WARNING: $f: gitspread.forcepush contains invalid value \"$force\". Using \"false\".
                force=false
            fi
            if [ "$force" = "true" ]; then
                force_opt=" -f"
            else
                force_opt=""
            fi
            for r in $(git remote); do
                git push$force_opt --all $r >>$logfile 2>&1
                git push$force_opt --tags $r >>$logfile 2>&1
            done
            rm -v $spool/$f >>$logfile 2>&1
        done
    fi
    sleep 5
done
