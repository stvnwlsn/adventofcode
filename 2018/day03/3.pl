#!/usr/bin/env perl
# '#2 @ 391,45: 27x20' - row of input file

use strict;
use warnings;
use feature qw( say );

my @data;
my $filename = 'input.txt';
my %fabric; # stored as 'point on fabric' -> number of claims e.g. '2x3' -> 3

if (open(my $fh, '<:encoding(UTF-8)', $filename)){
    while (my $row = <$fh>){
        chomp $row;
        my @claim = ($row =~ /(#\d+)\s@\s(\d+),(\d+):\s(\d+)x(\d+)/g);
        push @data, \@claim;
    }
}
else {
    warn "Could not open file '$filename' $!";
}

foreach (@data){
    my $fl = $_->[1];
    my $ft = $_->[2];
    my $wt = $_->[3];
    my $ht = $_->[4];
    for (my $j = $ft; $j < ($ft + $ht); $j++){
        for (my $i = $fl; $i < ($fl + $wt); $i++){
            my $point =  $i. "x" . $j;
            if(exists ($fabric{$point})){
                $fabric{$point}++;
            }
            else {
                $fabric{$point} = 1;
            }
        }
    }
}

my $morethan1 = 0;

foreach (keys %fabric){
    if( $fabric{$_} > 1 ){
        $morethan1++;
    }
}
say "Part 1 answer is: ",$morethan1;


my $id_with_no_overlap;

foreach (@data){
    my $id = $_->[0];
    my $fl = $_->[1];
    my $ft = $_->[2];
    my $wt = $_->[3];
    my $ht = $_->[4];
    my $sum_claims = 0;
    for (my $j = $ft; $j < ($ft + $ht); $j++){
        for (my $i = $fl; $i < ($fl + $wt); $i++){
            my $point = $i. "x" . $j;
            $sum_claims += $fabric{$point};
        }
    }
    if($sum_claims == ($wt * $ht)){
        $id_with_no_overlap = $id;
        last;
    }
}

say "Part 2 answer is: ", $id_with_no_overlap;
