#!/usr/bin/perl
#
# Copyright (c) 2016  Peter Pentchev
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

use v5.010;
use strict;
use warnings;

use File::stat;
use File::Temp;
use Test::More;

sub spurt_attr($ $)
{
	my ($fname, $data) = @_;

	open my $f, '>', $fname or
	    die "Could not open $fname for writing: $!\n";
	say $f $data->{contents} or
	    die "Could not write to $fname: $!\n";
	close $f or
	    die "Could not close $fname after writing: $!\n";
	chmod $data->{mode}, $fname or
	    die sprintf 'Could not set mode %4o on %s: %s\n',
	    $data->{mode}, $fname, $!;
	if ($> == 0) {
		chown $data->{owner}[0], $data->{owner}[1], $fname or
		    die "Could not set owner $data->{owner}[0] and ".
		    "group $data->{owner}[1] on $fname: $!\n";
	}
}

sub get_non_root_owner()
{
	my @groups = split /\s+/, $), 2;
	if ($groups[0] !~ /^ (?<egid> 0 | [1-9][0-9]* ) $/x) {
		die "Invalid effective groups list '$)'\n";
	}
	my $o = [$>, $+{egid} + 0];
	return $o unless $o->[0] == 0;

	while (my @u = getpwent) {
		return [$u[2], $u[3]] if $u[2] > 0;
	}
	return $o;
}

sub reinit_test_data($ $)
{
	my ($d, $files) = @_;

	for my $f (sort keys %{$files}) {
		my $data = $files->{$f};
		spurt_attr "$d/$_/$f.txt", $data->{$_} for qw(src dst);
	}
}

sub check_file_attrs($ $)
{
	my ($fname, $data) = @_;

	my $st = stat $fname or
	    die "Could not stat $fname: $!\n";
	is $st->mode & 07777, $data->{mode}, "$fname has the correct mode";
	is $st->uid, $data->{owner}[0], "$fname has the correct owner";
	is $st->gid, $data->{owner}[1], "$fname has the correct group";
}

sub check_file_contents($ $)
{
	my ($fname, $contents) = @_;

	open my $f, '<', $fname or
	    die "Could not open $fname for reading: $!\n";
	my $line = <$f>;
	if (!defined $line) {
		die "Could not read even a single line from $fname: $!\n";
	}
	if (defined scalar <$f>) {
		die "Read more than one line from $fname\n";
	}
	close $f or
	    die "Could not close $fname after reading: $!\n";
	chomp $line;
	is $contents, $line, "$fname has the correct contents";
}

sub capture($ @)
{
	my ($close_stderr, @cmd) = @_;

	my $pid = open my $f, '-|';
	if (!defined $pid) {
		die "Could not fork for '@cmd': $!\n";
	} elsif ($pid == 0) {
		close STDERR if $close_stderr;
		exec { $cmd[0] } @cmd;
		die "Could not execute '@cmd': $!\n";
	}
	my @data = <$f>;
	chomp for @data;
	close $f;
	my $status = $? >> 8;
	return { exitcode => $status, lines => [ @data ] };
}

my $d = File::Temp->newdir(TEMPLATE => 'test-data.XXXXXX') or
    die "Could not create a temporary directory: $!\n";

for my $comp (qw(src dst)) {
	mkdir "$d/$comp" or
	    die "Could not create the $d/$comp directory: $!\n";
}

my %files = (
	1 => {
		src => {
			mode => 0601,
			contents => 'one',
		},
		dst => {
			mode => 0600,
			contents => 'something',
		},
	},

	2 => {
		src => {
			mode => 0602,
			contents => 'two',
		},
		dst => {
			mode => 0644,
			contents => 'something else',
		},
	},

	3 => {
		src => {
			mode => 0603,
			contents => 'three',
		},
		dst => {
			mode => 0755,
			contents => 'something different',
		},
	},
);

my $owner = get_non_root_owner;
for my $f (keys %files) {
	$_->{owner} = $owner for values %{$files{$f}};
}

my $prog = $ENV{INSTALL_MIMIC} // './install-mimic';

plan tests => 56;

my $c = capture(1, $prog);
isnt $c->{exitcode}, 0, "$prog with no parameters failed";
is scalar @{$c->{lines}}, 0, "$prog with no parameters output nothing";

$c = capture(1, $prog, '-X', '-Y', '-Z');
isnt $c->{exitcode}, 0, "$prog with bogus parameters failed";
is scalar @{$c->{lines}}, 0, "$prog with bogus parameters output nothing";

$c = capture(1, $prog, $prog);
isnt $c->{exitcode}, 0, "$prog with a single filename parameter failed";
is scalar @{$c->{lines}}, 0, "$prog with a single filename parameter output nothing";

$c = capture(0, $prog, '-V');
is $c->{exitcode}, 0, "$prog -V succeeded";
is scalar @{$c->{lines}}, 1, "$prog -V output a single line";

$c = capture(0, $prog, '-h');
is $c->{exitcode}, 0, "$prog -h succeeded";
my $h_lines = scalar @{$c->{lines}};
ok $h_lines > 1, "$prog -h output more than one line";

$c = capture(0, $prog, '-h', '-V');
is $c->{exitcode}, 0, "$prog -h -V succeeded";
is scalar @{$c->{lines}}, $h_lines + 1, "$prog -h -V output one line more than $prog -h";

# OK, let's start doing stuff
reinit_test_data $d, \%files;

for my $f (sort keys %files) {
	my $data = $files{$f};
	my $src = "$d/src/$f.txt";
	my $dst = "$d/dst/$f.txt";
	my $c = capture(0, $prog, '--', $src, $dst);
	is $c->{exitcode}, 0, "'$prog $src $dst' succeeded";
	is scalar @{$c->{lines}}, 0, "'$prog $src $dst' output nothing";

	check_file_attrs $dst, $data->{dst};
	check_file_contents $dst, $data->{src}{contents};
}

reinit_test_data $d, \%files;

for my $f (sort keys %files) {
	my $data = $files{$f};
	my $src = "$d/src/$f.txt";
	my $dst = "$d/dst/$f.txt";

	check_file_attrs $dst, $data->{dst};
	check_file_contents $dst, $data->{dst}{contents};
}

$c = capture(0, $prog, '--', (map "$d/src/$_.txt", sort keys %files), "$d/dst");
is $c->{exitcode}, 0, "'$prog all-files $d/dst' succeeded";
is scalar @{$c->{lines}}, 0, "'$prog all-files $d/dst' output nothing";

for my $f (sort keys %files) {
	my $data = $files{$f};
	my $src = "$d/src/$f.txt";
	my $dst = "$d/dst/$f.txt";

	check_file_attrs $dst, $data->{dst};
	check_file_contents $dst, $data->{src}{contents};
}
