#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say /;
use List::Compare;
use Test::More tests => 5;

ok( min_distance( "R8,U5,L5,D3", "U7,R6,D4,L4" ) == 6 );
ok( min_distance(
        "R75,D30,R83,U83,L12,D49,R71,U7,L72",
        "U62,R66,U55,R34,D71,R55,D58,R83"
    ) == 159
);
ok( min_distance(
        "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
        "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    ) == 135
);
ok( min_steps(
        "R75,D30,R83,U83,L12,D49,R71,U7,L72",
        "U62,R66,U55,R34,D71,R55,D58,R83"
    ) == 610
);
ok( min_steps(
        "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
        "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    ) == 410
);

my $filename = 'd03input.txt';
my @input;
open my $fh, '<', $filename or die "Can't open < $filename: $!";
while (<$fh>) {
    chomp;
    push @input, $_;
}
close $fh;

say "Min distance: ", min_distance( $input[0], $input[1] );
say "Min steps: ", min_steps($input[0], $input[1]);

sub min_steps {
    my $cable_a = shift;
    my $cable_b = shift;
    my ( $intersection_ref, $points_a_ref, $points_b_ref )
        = get_intersection_points( $cable_a, $cable_b );
    my @intersection = @$intersection_ref;
    my @points_a     = @$points_a_ref;
    my @points_b     = @$points_b_ref;
    my $min_steps;
    for my $intersect_point (@intersection) {
        my $steps = 0;
        for my $check_point (@points_a) {
            $steps++;
            if ( $check_point eq $intersect_point ) {
                last;
            }
        }
        for my $check_point (@points_b) {
            $steps++;
            if ( $check_point eq $intersect_point ) {
                last;
            }
        }
        if ( !defined $min_steps || $steps < $min_steps ) {
            $min_steps = $steps;
        }
    }
    return $min_steps;
}

sub get_intersection_points {
    my $cable_a      = shift;
    my $cable_b      = shift;
    my $points_a_ref = get_cable_points($cable_a);
    my $points_b_ref = get_cable_points($cable_b);
    my $lc           = List::Compare->new( $points_a_ref, $points_b_ref );
    my @intersection = $lc->get_intersection;
    return ( \@intersection, $points_a_ref, $points_b_ref );
}

sub min_distance {
    my $cable_a = shift;
    my $cable_b = shift;
    my ($intersection_ref) = get_intersection_points( $cable_a, $cable_b );
    my @intersection = @$intersection_ref;
    my $min_distance;
    for (@intersection) {
        my ( $x, $y ) = split /,/, $_;
        my $distance = abs($x) + abs($y);
        if ( !defined $min_distance || $distance < $min_distance ) {
            $min_distance = $distance;
        }
    }
    return $min_distance;
}

sub get_cable_points {
    my $cable = shift;
    my @path  = split /,/, $cable;
    my @point = ( 0, 0 );
    my @points;
    for my $path (@path) {
        $path =~ /(\d+)/;
        my $number = $1;
        if ( $path =~ /U/ ) {
            for ( my $i = 1; $i <= $number; $i++ ) {
                $point[1] = $point[1] + 1;
                push @points, "$point[0],$point[1]";
            }
        }
        elsif ( $path =~ /D/ ) {
            for ( my $i = 1; $i <= $number; $i++ ) {
                $point[1] = $point[1] - 1;
                push @points, "$point[0],$point[1]";
            }
        }
        elsif ( $path =~ /R/ ) {
            for ( my $i = 1; $i <= $number; $i++ ) {
                $point[0] = $point[0] + 1;
                push @points, "$point[0],$point[1]";
            }
        }
        elsif ( $path =~ /L/ ) {
            for ( my $i = 1; $i <= $number; $i++ ) {
                $point[0] = $point[0] - 1;
                push @points, "$point[0],$point[1]";
            }
        }
    }
    return \@points;
}
