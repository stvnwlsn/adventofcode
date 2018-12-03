#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

my @data;
my $sum = 0;
my %freq;
my $match = 0;
my $filename = 'input.txt';

if (open(my $fh, '<:encoding(UTF-8)', $filename)){
    while (my $row = <$fh>){
        push @data, $row;
    }
}
else {
    warn "Could not open file '$filename' $!";
}

my @data_copy = @data;

while(!$match){
    if(!@data){
        @data = @data_copy;
    }
    $sum += shift @data;
    if( exists $freq{$sum}  ){
        $match = 1;
    } else {
        $freq{$sum} = 1;
    }
}
say "Puzzle answer is: ", $sum;
