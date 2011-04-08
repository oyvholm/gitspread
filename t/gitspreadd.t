#!/usr/bin/perl

#=======================================================================
# gitspreadd.t
# File ID: aed76eda-6124-11e0-aeaf-adf3f75e27a6
# Test suite for gitspreadd(1).
#
# Character set: UTF-8
# ©opyleft 2011– Øyvind A. Holm <sunny@sunbase.org>
# License: GNU General Public License version 3 or later, see end of 
# file for legal stuff.
#=======================================================================

use strict;
use warnings;

BEGIN {
    # push(@INC, "$ENV{'HOME'}/bin/STDlibdirDTS");
    use Test::More qw{no_plan};
    use_ok('Cwd');
    use_ok('Fcntl');
    use_ok('IO::Handle');
}

use Cwd;
use Getopt::Long;

local $| = 1;

our $Debug = 0;
our $CMD = '../gitspreadd';

our %Opt = (

    'all' => 0,
    'debug' => 0,
    'help' => 0,
    'todo' => 0,
    'verbose' => 0,
    'version' => 0,

);

our $progname = $0;
$progname =~ s/^.*\/(.*?)$/$1/;
our $VERSION = '0.00';

Getopt::Long::Configure('bundling');
GetOptions(

    'all|a' => \$Opt{'all'},
    'debug' => \$Opt{'debug'},
    'help|h' => \$Opt{'help'},
    'todo|t' => \$Opt{'todo'},
    'verbose|v+' => \$Opt{'verbose'},
    'version' => \$Opt{'version'},

) || die("$progname: Option error. Use -h for help.\n");

$Opt{'debug'} && ($Debug = 1);
$Opt{'help'} && usage(0);
if ($Opt{'version'}) {
    print_version();
    exit(0);
}

diag(sprintf('========== Executing %s v%s ==========',
    $progname,
    $VERSION));

unless (ok(-e 'gitspreadd.t' && -e '../gitspreadd' && -e '../post-receive',
    'We are in the correct directory')) {
    diag('Has to be run from inside the gitspread/t/ directory.');
    exit 1;
}

if ($Opt{'todo'} && !$Opt{'all'}) {
    goto todo_section;
}

=pod

testcmd("$CMD command", # {{{
    <<'END',
[expected stdin]
END
    '',
    0,
    'description',
);

# }}}

=cut

diag('Testing -h (--help) option...');
likecmd("$CMD -h", # {{{
    '/  Show this help\./',
    '/^$/',
    0,
    'Option -h prints help screen',
);

# }}}
diag('Testing -v (--verbose) option...');
likecmd("$CMD -hv", # {{{
    '/^\n\S+ v\d\.\d\d\n/s',
    '/^$/',
    0,
    'Option --version with -h returns version number and help screen',
);

# }}}
diag('Testing --version option...');
likecmd("$CMD --version", # {{{
    '/^\S+ v\d\.\d\d\n/',
    '/^$/',
    0,
    'Option --version returns version number',
);

# }}}

my $datefmt = '20\d\d-\d\d-\d\d \d\d:\d\d:\d\dZ';

my $orig_dir = cwd();
my $tmpdir = "$orig_dir/tmpdir";
my $spooldir = "$tmpdir/spool";
my $logfile = "$tmpdir/gitspreadd.log";

cleanup();
testcmd("$CMD -1 -r $tmpdir", # {{{
    '',
    "gitspreadd: $tmpdir: Missing repository top directory\n",
    1,
    'Complain about missing repodir',
);

# }}}
create_tmpdir();
testcmd("$CMD -1 -r $tmpdir", # {{{
    '',
    '',
    0,
    'Run with -r option',
);

# }}}
ok(-d $spooldir, "$spooldir exists");
ok(-e $logfile, "$logfile exists");
like(file_data($logfile), # {{{
    "/^$datefmt - Starting gitspreadd v\\d.\\d\\d\\n\$/s",
    "$logfile looks ok"
);

# }}}
cleanup();
create_tmpdir();
testcmd("GITSPREAD_REPODIR=$tmpdir $CMD -1", # {{{
    '',
    '',
    0,
    'Use GITSPREAD_REPODIR environment variable',
);

# }}}
ok(-d $spooldir, "$spooldir exists");
ok(-e $logfile, "$logfile exists");
cleanup();

todo_section:
;

if ($Opt{'all'} || $Opt{'todo'}) {
    diag('Running TODO tests...'); # {{{

    TODO: {

local $TODO = '';
# Insert TODO tests here.

    }
    # TODO tests }}}
}

diag('Testing finished.');

sub cleanup {
    # {{{
    ok(chdir($orig_dir), "chdir $orig_dir");
    testcmd("rm -rf $tmpdir", '', '', 0, 'Delete tmpdir');
    ok(!-e $tmpdir, "$tmpdir does not exist");
    return;
    # }}}
} # cleanup()

sub create_tmpdir {
    # {{{
    ok(mkdir($tmpdir), "mkdir $tmpdir");
    ok(-d $tmpdir, 'tmpdir exists');
    return;
    # }}}
} # create_tmpdir()

sub testcmd {
    # {{{
    my ($Cmd, $Exp_stdout, $Exp_stderr, $Exp_retval, $Desc) = @_;
    my $stderr_cmd = '';
    my $deb_str = $Opt{'debug'} ? ' --debug' : '';
    my $Txt = join('',
        "\"$Cmd\"",
        defined($Desc)
            ? " - $Desc"
            : ''
    );
    my $TMP_STDERR = 'gitspreadd-stderr.tmp';

    if (defined($Exp_stderr) && !length($deb_str)) {
        $stderr_cmd = " 2>$TMP_STDERR";
    }
    is(`$Cmd$deb_str$stderr_cmd`, $Exp_stdout, $Txt);
    my $ret_val = $?;
    if (defined($Exp_stderr)) {
        if (!length($deb_str)) {
            is(file_data($TMP_STDERR), $Exp_stderr, "$Txt (stderr)");
            unlink($TMP_STDERR);
        }
    } else {
        diag("Warning: stderr not defined for '$Txt'");
    }
    is($ret_val >> 8, $Exp_retval, "$Txt (retval)");
    return;
    # }}}
} # testcmd()

sub likecmd {
    # {{{
    my ($Cmd, $Exp_stdout, $Exp_stderr, $Exp_retval, $Desc) = @_;
    my $stderr_cmd = '';
    my $deb_str = $Opt{'debug'} ? ' --debug' : '';
    my $Txt = join('',
        "\"$Cmd\"",
        defined($Desc)
            ? " - $Desc"
            : ''
    );
    my $TMP_STDERR = 'gitspreadd-stderr.tmp';

    if (defined($Exp_stderr) && !length($deb_str)) {
        $stderr_cmd = " 2>$TMP_STDERR";
    }
    like(`$Cmd$deb_str$stderr_cmd`, "$Exp_stdout", $Txt);
    my $ret_val = $?;
    if (defined($Exp_stderr)) {
        if (!length($deb_str)) {
            like(file_data($TMP_STDERR), "$Exp_stderr", "$Txt (stderr)");
            unlink($TMP_STDERR);
        }
    } else {
        diag("Warning: stderr not defined for '$Txt'");
    }
    is($ret_val >> 8, $Exp_retval, "$Txt (retval)");
    return;
    # }}}
} # likecmd()

sub file_data {
    # Return file content as a string {{{
    my $File = shift;
    my $Txt;
    if (open(my $fp, '<', $File)) {
        local $/ = undef;
        $Txt = <$fp>;
        close($fp);
        return($Txt);
    } else {
        return;
    }
    # }}}
} # file_data()

sub print_version {
    # Print program version {{{
    print("$progname v$VERSION\n");
    return;
    # }}}
} # print_version()

sub usage {
    # Send the help message to stdout {{{
    my $Retval = shift;

    if ($Opt{'verbose'}) {
        print("\n");
        print_version();
    }
    print(<<"END");

Usage: $progname [options] [file [files [...]]]

Contains tests for the gitspreadd(1) program.

Options:

  -a, --all
    Run all tests, also TODOs.
  -h, --help
    Show this help.
  -t, --todo
    Run only the TODO tests.
  -v, --verbose
    Increase level of verbosity. Can be repeated.
  --version
    Print version information.
  --debug
    Print debugging messages.

END
    exit($Retval);
    # }}}
} # usage()

sub msg {
    # Print a status message to stderr based on verbosity level {{{
    my ($verbose_level, $Txt) = @_;

    if ($Opt{'verbose'} >= $verbose_level) {
        print(STDERR "$progname: $Txt\n");
    }
    return;
    # }}}
} # msg()

__END__

# Plain Old Documentation (POD) {{{

=pod

=head1 NAME

run-tests.pl

=head1 SYNOPSIS

gitspreadd.t [options] [file [files [...]]]

=head1 DESCRIPTION

Contains tests for the gitspreadd(1) program.

=head1 OPTIONS

=over 4

=item B<-a>, B<--all>

Run all tests, also TODOs.

=item B<-h>, B<--help>

Print a brief help summary.

=item B<-t>, B<--todo>

Run only the TODO tests.

=item B<-v>, B<--verbose>

Increase level of verbosity. Can be repeated.

=item B<--version>

Print version information.

=item B<--debug>

Print debugging messages.

=back

=head1 AUTHOR

Made by Øyvind A. Holm S<E<lt>sunny@sunbase.orgE<gt>>.

=head1 COPYRIGHT

Copyleft © Øyvind A. Holm E<lt>sunny@sunbase.orgE<gt>
This is free software; see the file F<COPYING> for legalese stuff.

=head1 LICENCE

This program is free software: you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published by the 
Free Software Foundation, either version 3 of the License, or (at your 
option) any later version.

This program is distributed in the hope that it will be useful, but 
WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along 
with this program.
If not, see L<http://www.gnu.org/licenses/>.

=head1 SEE ALSO

=cut

# }}}

# vim: set fenc=UTF-8 ft=perl fdm=marker ts=4 sw=4 sts=4 et fo+=w :
