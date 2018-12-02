#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

my @data;
my $filename = 'input.txt';
my $checksum;
my @tts;

if (open(my $fh, '<:encoding(UTF-8)', $filename)){
    while (my $row = <$fh>){
        push @data, $row;
    }
}
else {
    warn "Could not open file '$filename' $!";
}

foreach (@data){
    my @item = two_three($_);
    $tts[0] += $item[0];
    $tts[1] += $item[1];
}

say "Checksum is $tts[0] * $tts[1]";
$checksum = $tts[0] * $tts[1];

sub two_three{
    my $str = shift;
    my %letters;
    my $twos = 0;
    my $threes = 0;
    foreach my $i (split("", $str)){
        if( exists $letters{$i} ){
            $letters{$i} += 1;
        } else {
            $letters{$i} = 1;
        }
    }
    if (grep { $letters{$_} == 3 } keys %letters){
        $threes = 1;
    }
    if (grep { $letters{$_} == 2 } keys %letters){
        $twos = 1;
    }
    return ($twos, $threes);
}

say "Puzzle answer is: ", $checksum;
