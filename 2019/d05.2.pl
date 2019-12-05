#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say /;

my $filename = 'd05input.txt';
my $puzzle_input;
open my $fh, '<', $filename or die "Can't open < $filename: $!";
chomp( $puzzle_input = readline($fh) );
close $fh;

run_intcode($puzzle_input);

sub run_intcode {
    my $intcode = shift;
    my @intcode = split /,/, $intcode;
    my $p       = 0;
    my $increment;
    my ( $opcode, $para1, $para2, $para3 )
        = get_code_and_modes( $intcode[$p] );
    while ( $opcode != 99 ) {
        if ( $opcode == 1 ) {
            my $p1 = $para1 ? $p + 1 : $intcode[ $p + 1 ];
            my $p2 = $para2 ? $p + 2 : $intcode[ $p + 2 ];
            my $p3 = $para3 ? $p + 3 : $intcode[ $p + 3 ];
            $intcode[$p3] = $intcode[$p1] + $intcode[$p2];
            $increment = 4;
        }
        elsif ( $opcode == 2 ) {
            my $p1 = $para1 ? $p + 1 : $intcode[ $p + 1 ];
            my $p2 = $para2 ? $p + 2 : $intcode[ $p + 2 ];
            my $p3 = $para3 ? $p + 3 : $intcode[ $p + 3 ];
            $intcode[$p3] = $intcode[$p1] * $intcode[$p2];
            $increment = 4;
        }
        elsif ( $opcode == 3 ) {
            my $p1 = $para1 ? $p + 1 : $intcode[ $p + 1 ];
            chomp( my $input = <STDIN> );
            $intcode[$p1] = $input;
            $increment = 2;
        }
        elsif ( $opcode == 4 ) {
            my $p1 = $para1 ? $p + 1 : $intcode[ $p + 1 ];
            say $intcode[$p1];
            $increment = 2;
        }

       # Opcode 5 is jump-if-true: if the first parameter is non-zero, it sets
       # the instruction pointer to the value from the second parameter.
       # Otherwise, it does nothing.
        elsif ( $opcode == 5 ) {
            my $p1 = $para1 ? $p + 1 : $intcode[ $p + 1 ];
            my $p2 = $para2 ? $p + 2 : $intcode[ $p + 2 ];
            if ( $intcode[$p1] != 0 ) {
                $p         = $intcode[$p2];
                $increment = 0;
            }
            else {
                $increment = 3;
            }
        }

      # Opcode 6 is jump-if-false: if the first parameter is zero, it sets the
      # instruction pointer to the value from the second parameter. Otherwise,
      # it does nothing.
        elsif ( $opcode == 6 ) {
            my $p1 = $para1 ? $p + 1 : $intcode[ $p + 1 ];
            my $p2 = $para2 ? $p + 2 : $intcode[ $p + 2 ];
            if ( $intcode[$p1] == 0 ) {
                $p         = $intcode[$p2];
                $increment = 0;
            }
            else {
                $increment = 3;
            }
        }

       # Opcode 7 is less than: if the first parameter is less than the second
       # parameter, it stores 1 in the position given by the third parameter.
       # Otherwise, it stores 0.
        elsif ( $opcode == 7 ) {
            my $p1 = $para1 ? $p + 1 : $intcode[ $p + 1 ];
            my $p2 = $para2 ? $p + 2 : $intcode[ $p + 2 ];
            my $p3 = $para3 ? $p + 3 : $intcode[ $p + 3 ];
            if ( $intcode[$p1] < $intcode[$p2] ) {
                $intcode[$p3] = 1;
            }
            else {
                $intcode[$p3] = 0;
            }
            $increment = 4;
        }

        # Opcode 8 is equals: if the first parameter is equal to the second
        # parameter, it stores 1 in the position given by the third parameter.
        # Otherwise, it stores 0.
        elsif ( $opcode == 8 ) {
            my $p1 = $para1 ? $p + 1 : $intcode[ $p + 1 ];
            my $p2 = $para2 ? $p + 2 : $intcode[ $p + 2 ];
            my $p3 = $para3 ? $p + 3 : $intcode[ $p + 3 ];
            if ( $intcode[$p1] == $intcode[$p2] ) {
                $intcode[$p3] = 1;
            }
            else {
                $intcode[$p3] = 0;
            }
            $increment = 4;
        }

        $p += $increment;
        ( $opcode, $para1, $para2, $para3 )
            = get_code_and_modes( $intcode[$p] );
    }
    return join ",", @intcode;
}

sub get_code_and_modes {
    my $instruction = shift;
    $instruction =~ /(\d{1,2})$/;
    my $opcode = $1;
    my $para1  = length $instruction > 2 ? substr $instruction, -3, 1 : 0;
    my $para2  = length $instruction > 3 ? substr $instruction, -4, 1 : 0;
    my $para3  = length $instruction > 4 ? substr $instruction, -5, 1 : 0;
    return ( $opcode, $para1, $para2, $para3 );
}
