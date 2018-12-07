#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );
use List::MoreUtils qw(uniq);

use Test::More;

#Part 1 tests
my @td = (
    "1, 1",
    "1, 6",
    "8, 3",
    "3, 4",
    "5, 5",
    "8, 9"
    );

cmp_ok( md( get_x($td[0]), get_y($td[0]), get_x($td[3]), get_y($td[3])), "eq", 5, "Manhattan distance" );
cmp_ok( md( get_x($td[2]), get_y($td[2]), get_x($td[3]), get_y($td[3])), "eq", 6, "Manhattan distance" );
my @tmbb = get_minimum_bounding_box(@td);
my $tmbbs = "(" . $tmbb[0] . "," . $tmbb[1] . '), (' . $tmbb[2] . "," . $tmbb[3] . ")";
cmp_ok( $tmbbs , "eq", "(1,1), (8,9)", "Test minimum bounding box");

done_testing();


my @data;
my $filename = 'input.txt';
my %points_distances;


if (open(my $fh, '<:encoding(UTF-8)', $filename)){
    while (my $row = <$fh>){
        chomp $row;
        push @data, $row;
    }
}
else {
    warn "Could not open file '$filename' $!";
}

# get the x co-ordinate forom string "x, y"
sub get_x{
    my $coordinate = shift;
    $coordinate =~ /(\d+)/;
    return $1;
}

# get the y co-ordinate forom string "x, y"
sub get_y{
    my $coordinate = shift;
    $coordinate =~ /, (\d+)/;
    return $1;
}

# Return the manhattan distance given 2 co-ordinates
sub md{
    my ($p1, $p2, $q1, $q2) = @_;
    return  (abs($p1 - $q1) + abs($p2 - $q2));
}

# take an array of strings which are co-ordinates and returns the co-ordinates
# of the minimum bounding box.
sub get_minimum_bounding_box{
    my @data = @_;
    my ($min_x, $max_x, $min_y, $max_y);
    foreach(@data){
        my ($x, $y) = (get_x($_), get_y($_));
        if (!defined $min_x || $x < $min_x ){
            $min_x = $x;
        }
        if (!defined $max_x || $x > $max_x ){
            $max_x = $x;
        }
        if (!defined $min_y || $y < $min_y ){
            $min_y = $y;
        }
        if (!defined $max_y || $y > $max_y ){
            $max_y = $y;
        }
    }

    return ($min_x, $min_y, $max_x, $max_y);
}

# return locations to eliminate as having infinite area
sub locations_with_finite_area{
    my $locations = shift;
    my $points = shift;
    my @locations = @{$locations};
    my %points = %{$points};
    my @mbb = get_minimum_bounding_box(@locations);
    my @infinite;
    my @finite;
    my @edge_points;

    # top edge points
    for(my $x = $mbb[0]; $x <= $mbb[2]; $x++){
        push @edge_points, $x . ", " . $mbb[1];
    }
    # bottom edge points
    for(my $x = $mbb[0]; $x <= $mbb[2]; $x++){
        push @edge_points, $x . ", " . $mbb[3];
    }
    # left edge points
    for(my $y = $mbb[1]; $y <= $mbb[3]; $y++){
        push @edge_points, $mbb[0] . ", " . $y;
    }
    # right edge points
    for(my $y = $mbb[1]; $y <= $mbb[3]; $y++){
        push @edge_points, $mbb[2] . ", " . $y;
    }

    foreach my $loc (@locations){
        foreach my $ep (@edge_points){
            foreach my $poi (@{$points{$ep}}){
                if ($loc eq $poi){
                    push @infinite, $loc;
                }
            }
        }
    }

    @infinite = uniq @infinite;
    foreach my $loc (@locations){
        push @finite, $loc unless grep {$loc eq $_} @infinite;
    }
    return @finite;
}


sub populate_point_distances{
    my @locations = @_;
    my %points;
    my @mbb = get_minimum_bounding_box(@locations);
    for(my $j = $mbb[1]; $j <= $mbb[3]; $j++){
        for(my $i = $mbb[0]; $i <= $mbb[2]; $i++){
            my $closest_distance = undef;
            my @closest_locations = ();
            foreach (@locations){
                my $distance = md($i, $j, get_x($_), get_y($_));
                if(!defined $closest_distance || $distance < $closest_distance){
                    @closest_locations = ();
                    push @closest_locations, $_;
                    $closest_distance = $distance;
                } elsif ($distance == $closest_distance){
                    push @closest_locations, $_;
                }
            }
            $points{($i . ", " . $j)} = [@closest_locations];
        }
    }
    return %points;
}


sub largest_area_not_finate{
    my $finite = shift;
    my $points = shift;
    my @finite = @{$finite};
    my %points = %{$points};
    my $location_largest_area = "";
    my $largest_area = 0;
    my @array;
    foreach my $fin (@finite){
        my $area = 0;
        foreach my $poi (keys %points){
            foreach my $loc (@{$points{$poi}}){
                if($fin eq $loc and @{$points{$poi}} == 1){
                    $area++;
                    if($fin eq "5, 5"){
                        push @array, $poi;
                    }
                }
            }
        }
        if($location_largest_area eq "" || $largest_area < $area){
            $location_largest_area = $fin;
            $largest_area = $area;
        }
    }
    return ($location_largest_area, $largest_area);
}

# Part 1
# my %points = populate_point_distances(@data);
# my @locations_with_finite_area = locations_with_finite_area(\@data, \%points);
# my @largest_area_not_finate = largest_area_not_finate(\@locations_with_finite_area, \%points);
# foreach (@largest_area_not_finate){
#     say $_;
# }

# Part 2

# go through each location and sum the distances to each location
# find the number of locations with sum less than 10000

sub sum_locations_for_points{
    my @locations = @_;
    my %coord;
    my @mbbox = get_minimum_bounding_box(@locations);
    for(my $j = $mbbox[1]; $j <= $mbbox[3]; $j++){
        for(my $i = $mbbox[0]; $i <= $mbbox[2]; $i++){
            my $distance;
            foreach (@locations){
                $distance += md($i, $j, get_x($_), get_y($_));
            }
            $coord{($i . ", " . $j)} = $distance;
        }
    }
    return %coord;
}

sub locations_less_than_number{
    my $x = shift;
    my %coor = %{$x};
    my $number = shift;
    my $number_of_locations;
    foreach my $co (keys %coor){
        if ($coor{$co} < $number){
            $number_of_locations++;
        }

    }
    return $number_of_locations
}

my %td_points = sum_locations_for_points(@td);
my $td_region_size = locations_less_than_number(\%td_points, 32);
say $td_region_size;

my %data_points = sum_locations_for_points(@data);
my $input_region_size = locations_less_than_number(\%data_points, 10000);
say $input_region_size;
