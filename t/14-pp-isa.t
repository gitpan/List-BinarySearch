#!/usr/bin/env perl

use strict;
use warnings;

require B;

# Cargo-culted from Sub::Identify.  Thanks. ;)
sub get_code_info {
    my ($coderef) = @_;
    ref $coderef or return;
    my $cv = B::svref_2object($coderef);
    $cv->isa('B::CV') or return;
    # bail out if GV is undefined
    $cv->GV->isa('B::SPECIAL') and return;

    return ($cv->GV->STASH->NAME, $cv->GV->NAME);
};

use Test::More;

BEGIN{
  # Force pure-Perl
  $ENV{List_BinarySearch_PP} = 1; ## no critic (local)
}

use List::BinarySearch qw( binsearch );


my( $pkg, $subname ) = get_code_info( \&binsearch );

note "$pkg => $subname";

is( $pkg, "List::BinarySearch::PP",
    '$List::BinarySearch::PP=1 forces pure-Perl implementation.'
);

done_testing;
