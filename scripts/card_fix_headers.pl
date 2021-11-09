#!/usr/bin/env perl

use strict;
use warnings;

my $fas = shift @ARGV;
my $aro = shift @ARGV;

my $data = {};
open(ARO, '<', $aro) or die $!;
my $header = <ARO>;
while (my $line = <ARO>) {
    chomp($line);
    my ($acc, undef, undef, undef, $name, undef, undef, undef, undef, $desc) = split(/\t/, $line);
    #print STDERR $acc . ': '. $name . ' ' . $desc . "\n";
    $data->{$acc} = $name . ' ' . $desc;
}
close(ARO);


open(F, $fas) or die "Cannot read $fas\n";
_read_fasta_file(\*F,
                sub {
                    my ($name, $seq) = @_;
                    my @tmp = split(/\|/, $name);
                    #$tmp[2] = 'ARO:'.substr($tmp[2], 4);
                    if (exists($data->{$tmp[2]})) {
                        print '>lcl|'.$tmp[2]." ".$data->{$tmp[2]}."\n";
                        print $seq."\n";
                    } else {
                        print STDERR "not found: ".$tmp[2].".\n";
                    }
                }
                ); 
close(F);

# helper method to read a fasta file sequence by sequence
sub _read_fasta_file {
    my ($fh, $callback) = @_;
    
    next unless ref($callback);

    my $name;
    my $sequence;
    
    while (<$fh>) {
        chomp;
        # remove ^M's..
        s/\015//g;
        if (/^>(.*)$/) {
            if ($name) {
                &$callback($name, $sequence);
            }
            $name = $1;
            $sequence = "";
        }
        else {
            $sequence .= $_;
        }
    }
    if ($name) {
        &$callback($name, $sequence);
    }
}

