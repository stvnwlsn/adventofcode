#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use Test::More;

#Part 1 tests
my @test_data = (
    ["aA", ""],
    ["abBA", ""],
    ["abAB", "abAB"],
    ["aabAAB", "aabAAB"],
    ["dabAcCaCBAcCcaDA", "dabCBAcaDA"]
    );

foreach (@test_data){
    cmp_ok( react_polymer($_->[0]), "eq", $_->[1], "reduction" );
}

# Part 2 tests
my $test_string = "dabAcCaCBAcCcaDA";

my @test_data_remove_instances = (
    ["A", "a", "dbcCCBcCcD"],
    ["B", "b", "daAcCaCAcCcaDA"],
    ["C", "c", "dabAaBAaDA"],
    ["D", "d", "abAcCaCBAcCcaA"]
    );

foreach (@test_data_remove_instances){
    cmp_ok( remove_instances($_->[0], $_->[1], $test_string), "eq", $_->[2], "remove_instances");
}

done_testing();


my $data = "";
my $filename = 'input.txt';


if (open(my $fh, '<:encoding(UTF-8)', $filename)){
    while (my $row = <$fh>){
        chomp $row;
        $data = $data . $row;
    }
}
else {
    warn "Could not open file '$filename' $!";
}

sub react_polymer{
    my $polymer = shift;
    my $index = 0;
    while(length $polymer > ($index + 1)){
        if(can_reduce(substr($polymer, $index, 1), substr($polymer, ($index + 1), 1) )){
            substr($polymer, $index, 2, "");
            if( $index != 0){
                $index--;
            }
        }
        else {
            $index++;
        }
    }
    return $polymer;
}

sub can_reduce{
    my $a = shift;
    my $b = shift;
    if (ord($a) ==  (ord($b) + 32) || ord($a) == ord($b) - 32){
        return 1;
    }
    else {
        return 0;
    }
}

my $react_polymer = react_polymer($data);

say "Part 1 answer is: ", length $react_polymer;


# Part 2

sub remove_instances{
    my ($x, $y, $polymer) = @_;
    $polymer =~ s/[$x|$y]//g;
    return $polymer;
}

for (my $i = 65; $i <= 90; $i++){
    my $polymer = $data;
    $polymer = remove_instances(chr($i), chr($i+32), $polymer);
    $polymer = react_polymer($polymer);
    say chr($i), "/", chr($i+32), ": reduced and reacted to: ", length $polymer;
}
