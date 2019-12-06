#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say /;
use Graph;
use Test::More tests => 1;

my @edges_t = qw/ COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L /;
ok( number_of_orbits( \@edges_t ) == 42 );

my $filename = 'd06input.txt';
my @puzzle_input;
open my $fh, '<', $filename or die "Can't open < $filename: $!";
while (<$fh>) {
    my $line = $_;
    chomp($line);
    push @puzzle_input, $line;
}
close $fh;

say number_of_orbits( \@puzzle_input );

sub number_of_orbits {
    my $edges_ref = shift;
    my @edges     = @$edges_ref;
    my $graph     = Graph->new;
    my $count;
    for my $edge (@edges) {
        my ( $a, $b ) = split /\)/, $edge;
        $graph->add_edge( $a, $b );;
    }
    my @vertices = $graph->vertices;
    for my $vertex (@vertices) {
        my @path = $graph->SP_Bellman_Ford( "COM", $vertex );
        $count += (scalar @path - 1);
    }
    return $count;
}
