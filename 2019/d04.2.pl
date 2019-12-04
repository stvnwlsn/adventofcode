#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say /;
use Test::More tests => 4;

ok( meets_criteria("112233") == 1,
    "digits never decrease and all repeated digits are exactly two digits long"
);
ok( meets_criteria("123444") == 0,
    "repeated 44 is part of a larger group of 444" );
ok( meets_criteria("111122") == 1,
    "even though 1 is repeated more than twice, it still contains a double 22"
);
ok( meets_criteria("577789") == 0);

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
    for my $i (0..9){
        my $exactly_2 = ( $passwd =~ /((^|[^$i])[$i]{2}([^$i]|$))/ );
        if ($exactly_2) {
            return 1;
        }
    }
    return 0;
}
