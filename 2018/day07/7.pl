#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );
use Graph;
use Test::More;

# Part 1 tests
my @td = (
    "Step C must be finished before step A can begin.",
    "Step C must be finished before step F can begin.",
    "Step A must be finished before step B can begin.",
    "Step A must be finished before step D can begin.",
    "Step B must be finished before step E can begin.",
    "Step D must be finished before step E can begin.",
    "Step F must be finished before step E can begin."
    );

# cmp_ok(  );

# done_testing();

my @data;
my $filename = 'input.txt';


if (open(my $fh, '<:encoding(UTF-8)', $filename)){
    while (my $row = <$fh>){
        chomp $row;
        push @data, $row;
    }
}
else {
    warn "Could not open file '$filename' $!";
}


my %instructions;


foreach my $item (@td){
    $item =~ /\b([A-Z])\b.*\b([A-Z])\b/g;
    $instructions{$1} = [$2];
}


sub build_graph{
    my $g = shift;
    my $data = shift;
    my @data = @{$data};
    my @edges = ();
    foreach my $instruction (@data){
        $instruction =~ /\b([A-Z])\b.*\b([A-Z])\b/g;
        push @edges, [$1, $2];
    }
    sort {$b->[1] cmp $a->[1]} @edges;
    $g->add_edges(@edges);
    return $g;
}

my $g = Graph->new;
$g = build_graph($g, \@td);
my @ts = $g->topological_sort;
say @ts;
