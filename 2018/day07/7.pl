#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );
use List::MoreUtils qw(uniq);

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


sub get_instructions{
    my $ref_data = shift;
    my @data = @{ $ref_data };
    my @instructions;
    foreach my $item (@data){
        $item =~ /\b([A-Z])\b.*\b([A-Z])\b/g;
        push @instructions, $1.$2;
    }
    return @instructions;
}

sub get_blocked{
    my $instructions_ref = shift;
    my @instructions = @{ $instructions_ref };
    my @step1;
    @step1 = uniq map { substr($_, 1, 1) } @instructions;
    return @step1;
}

sub get_next_instruction{
    my $instructions_ref = shift;
    my @instructions = @{ $instructions_ref };
    my @blocked = get_blocked(\@instructions);
    my @step2 = uniq map { substr($_, 0, 1) } @instructions;
    my %lookup;
    my @available;
    my @available_instructions;
    @lookup{@blocked} = ();
    foreach (@step2) {
        push(@available, $_) unless exists $lookup{$_};
    }
    %lookup = ();
    @lookup{@available} = ();
    foreach(@instructions){
        push(@available_instructions, $_) if exists $lookup{substr($_, 0, 1)};
    }
    @available_instructions = sort @available_instructions;
    return shift @available_instructions;
}

sub remove_string_from_array{
    my $s = shift;
    my $ref_array = shift;
    my @array = @{ $ref_array };
    my @results;
    @results = grep { $_ ne $s } @array;
}

sub print_order_steps_completed{
    my $ref_data = shift;
    my @data_p1 = @{ $ref_data };
    my @instructions = get_instructions(\@data_p1);
    my @completed;
    my $instruction;
    while (@instructions){
        $instruction = get_next_instruction(\@instructions);
        push (@completed, substr($instruction, 0, 1));
        @instructions = remove_string_from_array($instruction, \@instructions);
    }
    push (@completed, substr($instruction, 1, 1));
    say uniq @completed;
}


print_order_steps_completed(\@td);
print_order_steps_completed(\@data);
