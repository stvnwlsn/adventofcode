#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say /;
use Test::More tests => 2;
use POSIX;

ok( calculate_fuel(1969) == 966 );
ok( calculate_fuel(100756) == 50346 );

my $filename   = 'd01.1-input.txt';
my $total_fuel = 0;

open my $fh, '<', $filename or die "Can't open < $filename: $!n";

while (<$fh>) {
    chomp;
    $total_fuel += calculate_fuel($_);
}

close $fh;

say $total_fuel;

sub calculate_fuel {
    my $mass = shift;
    my $fuel = ( floor( $mass / 3 ) ) - 2;
    if ($fuel <= 0) {
        return 0;
    }
    else {
        return $fuel + calculate_fuel($fuel);
    }
}
