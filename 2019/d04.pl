#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say /;
use Test::More tests => 6;

ok( meets_criteria("122345") == 1, "never decreasing, double digit" );
ok( meets_criteria("111123") == 1, "never decreasing, double digit" );
ok( meets_criteria("135679") == 0, "never decreasing, no double digit" );
ok( meets_criteria("111111") == 1, "never decreasing, double digit" );
ok( meets_criteria("223450") == 0, "decreasing, double digit" );
ok( meets_criteria("123789") == 0, "never decreasing, no double digit" );

my @input = split /-/, "171309-643603";

my $count = grep { meets_criteria($_) } ( $input[0] .. $input[1] );
say $count;

sub meets_criteria {
    my $passwd = shift;
    my @passwd = split //, $passwd;
    if ( length $passwd != 6 ) {
        return 0;
    }
    elsif (
        !(     $passwd[0] <= $passwd[1]
            && $passwd[1] <= $passwd[2]
            && $passwd[2] <= $passwd[3]
            && $passwd[3] <= $passwd[4]
            && $passwd[4] <= $passwd[5]
        )
        )
    {
        return 0;
    }
    elsif (
        !(     $passwd[0] == $passwd[1]
            || $passwd[1] == $passwd[2]
            || $passwd[2] == $passwd[3]
            || $passwd[3] == $passwd[4]
            || $passwd[4] == $passwd[5]
        )
        )
    {
        return 0;
    }
    return 1;
}
