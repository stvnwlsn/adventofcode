#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

my @data;
my $filename = 'input.txt';
my %sleep_patterns;


# Reading the input file and sorting the array of strings
if (open(my $fh, '<:encoding(UTF-8)', $filename)){
    while (my $row = <$fh>){
        chomp $row;
        push @data, $row;
    }
    @data = sort(@data);
}
else {
    warn "Could not open file '$filename' $!";
}

my $guard;
my $asleep;
my $wakes;

# Building the sleeping pattern for each guard
foreach (@data){
    if (/Guard/){
        $_ =~ /#(\d+)/;
        $guard = $1;
    } elsif (/falls/){
        $_ =~ /:(\d{2})/;
        $asleep = $1;
    } else {
        $_ =~ /:(\d{2})/;
        $wakes = $1;
        for(my $i = $asleep; $i < $wakes; $i++){
            $sleep_patterns{$guard}[$i] += 1;
        }
    }
}

# Part 1 variables
my $max_guard;
my $max_guard_minute = 0;
my $max_count = 0;

# Part 2 variables
my $max_minute_guard;
my $max_minute = 0;
my $max_minute_value = 0;

# Part 1: Looping through the guards, counting the total minutes asleep for
# each to find the max
# Part 2: identifying the minute with the most sleep and the guard
foreach (keys %sleep_patterns){
    my $count = 0;
    for (my $i = 0; $i <= 59; $i++){
        if(defined $sleep_patterns{$_}[$i]){
            $count += $sleep_patterns{$_}[$i];
            # Part 2 logic
            if($sleep_patterns{$_}[$i] > $max_minute_value){
                $max_minute_guard = $_;
                $max_minute = $i;
                $max_minute_value = $sleep_patterns{$_}[$i];
            }
        }
    }
    if($count > $max_count ){
        $max_count = $count;
        $max_guard = $_;
    }
}

# Part 1 finding the minute with most sleep for the guard with the highest
# total minutes asleep.
for(my $i = 0; $i <=59; $i++){
    if(defined $sleep_patterns{$max_guard}[$i]){
        if($sleep_patterns{$max_guard}[$max_guard_minute] < $sleep_patterns{$max_guard}[$i]){
            $max_guard_minute = $i;
        }
    }
}

say "Part 1 answer is: " . $max_guard * $max_guard_minute;
say "Part 2 answer is: " . $max_minute_guard * $max_minute;
