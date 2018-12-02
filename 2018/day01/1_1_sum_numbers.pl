#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

my @data;
my $filename = 'input.txt';

if (open(my $fh, '<:encoding(UTF-8)', $filename)){
    while (my $row = <$fh>){
        push @data, $row;
    }
}
else {
    warn "Could not open file '$filename' $!";
}

my $sum = 0;
while(@data){
    $sum += shift @data;
}
say "Puzzle answer is: ", $sum;
