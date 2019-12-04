#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say /;
use Test::More tests => 5;

ok( run_intcode("1,0,0,0,99") eq "2,0,0,0,99" );
ok( run_intcode("2,3,0,3,99") eq "2,3,0,6,99" );
ok( run_intcode("2,4,4,5,99,0") eq "2,4,4,5,99,9801" );
ok( run_intcode("1,1,1,4,99,5,6,0,99") eq "30,1,1,4,2,5,6,0,99" );
ok( run_intcode("1,9,10,3,2,3,11,0,99,30,40,50") eq
        "3500,9,10,70,2,3,11,0,99,30,40,50" );

my $filename = 'd02input.txt';
my $puzzle_input;
my $noun;
my $verb;

open my $fh, '<', $filename or die "Can't open < $filename: $!";
chomp( $puzzle_input = readline($fh) );
close $fh;

FIND: for my $i ( 0 .. 99 ) {
    for my $j ( 0 .. 99 ) {
        my $memory = $puzzle_input;
        $memory =~ s/^(\d+),(\d+,\d+)/$1,$i,$j/;
        my $halt_state = run_intcode($memory);
        $halt_state =~ m/^(\d+)/;
        if ( $1 == 19690720 ) {
            $noun = $i;
            $verb = $j;
            last FIND;
        }
    }
}

say 100 * $noun + $verb;

sub run_intcode {
    my $intcode = shift;
    my @intcode = split /,/, $intcode;
    my $p       = 0;
    while ( $intcode[$p] != 99 ) {
        if ( $intcode[$p] == 1 ) {
            $intcode[ $intcode[ $p + 3 ] ] = $intcode[ $intcode[ $p + 1 ] ]
                + $intcode[ $intcode[ $p + 2 ] ];
        }
        elsif ( $intcode[$p] == 2 ) {
            $intcode[ $intcode[ $p + 3 ] ] = $intcode[ $intcode[ $p + 1 ] ]
                * $intcode[ $intcode[ $p + 2 ] ];
        }
        $p += 4;
    }
    return join ",", @intcode;
}
