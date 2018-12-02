#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

my @data;
my $filename = 'input.txt';

if (open(my $fh, '<:encoding(UTF-8)', $filename)){
    while (my $row = <$fh>){
        chomp($row);
        push @data, $row;
    }
}
else {
    warn "Could not open file '$filename' $!";
}

my $sod = @data;  # get the size of data

for (my $i = 0; $i < $sod - 1; $i++){
    my $j_start = $i + 1;
    for (my $j = $j_start; $j < $sod; $j++){
        if (diff_by_char($data[$i], $data[$j])){
            say remove_diff_char($data[$i], $data[$j]);
        }
    }
}

sub diff_by_char{
    # Returns true if 2 strings differ by a single character else false
    my $s1 = shift;
    my $s2 = shift;
    my $diff = 0;
    my $ss = length $s1;
    for(my $i = 0; $i < $ss; $i++){
        if (substr($s1, $i, 1) ne substr($s2, $i, 1)){
            $diff += 1;
        }
    }
    if ($diff == 1){
        return 1;
    }
    else {
        return 0;
    }
}

sub remove_diff_char{
    # takes 2 strings which differ by a character and returns a string
    # with the character that differs removed.
    my $s1 = shift;
    my $s2 = shift;
    my $ss = length $s1;
    for(my $i = 0; $i < $ss; $i++ ){
        if (substr($s1, $i, 1) ne substr($s2, $i, 1)){
            substr ($s1, $i, 1, "");
            return $s1;
        }
    }
}
