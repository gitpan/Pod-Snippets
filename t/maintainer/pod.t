#!perl

=head1 NAME

pod.t - Tests that the POD in the I<compiled files> is clean enough.
See also pod-source.t

=cut

use strict;
use Test::More;
use File::Spec::Functions;
use File::Slurp qw(read_file);

plan(skip_all => "Test::Pod 1.14 required for testing POD"), exit unless
    eval "use Test::Pod 1.14; 1";
plan(skip_all => "Pod::Checker required for testing POD"), exit unless
    eval "use Pod::Checker; 1";
plan(skip_all => "Pod::Text required for testing POD"), exit unless
    eval "use Pod::Text; 1";

my @mainfiles = Test::Pod::all_pod_files("blib");
my @testfiles = Test::Pod::all_pod_files("t");
plan(skip_all => "no POD (yet?)"), exit if (! @mainfiles && ! @testfiles);

plan( tests => 3 * scalar (@mainfiles) + scalar(@testfiles) );

my $out = catfile(qw(t pod-out.tmp));

foreach my $file ( @testfiles ) {
    ok(podchecker($file, undef) <= 0);
}

foreach my $file (@mainfiles) {
    ok(podchecker($file, undef) <= 0);

=pod

We also check that the internal and test suite documentations are
B<not> visible in the POD.

=cut

    my $parser = Pod::Text->new (sentence => 0, width => 78);
    $parser->parse_from_file($file, $out);
    my $result = read_file($out);
    unlike($result, qr/^TEST SUITE/m,
           "Test suite documentation is podded out");
    unlike($result, qr/^INTERNAL/,
           "Internal documentation is podded out");
}


unlink($out);
