#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say /;
use Graph;
use Test::More tests => 1;

my @edges_t = qw/ COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L K)YOU I)SAN /;
ok( number_of_orbital_transfers( \@edges_t ) == 4 );

my $filename = 'd06input.txt';
my @puzzle_input;
open my $fh, '<', $filename or die "Can't open < $filename: $!";
while (<$fh>) {
    my $line = $_;
    chomp($line);
    push @puzzle_input, $line;
}
close $fh;

say number_of_orbital_transfers( \@puzzle_input );

sub number_of_orbital_transfers {
    my $edges_ref = shift;
    my @edges     = @$edges_ref;
    my $graph     = Graph::Undirected->new;
    for my $edge (@edges) {
        my ( $a, $b ) = split /\)/, $edge;
        $graph->add_edge( $a, $b );
    }
    my @path = $graph->SP_Bellman_Ford("YOU", "SAN");
    return (scalar @path) - 3;
}
