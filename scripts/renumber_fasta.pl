#!/usr/bin/env perl

use strict;
use warnings;

my $cnt = 1;

_read_fasta_file(\*STDIN,
                sub {
                    my ($name, $seq) = @_;
                    my @tmp = split(/\ /, $name, 2);
                    print '>lcl|seq'.$cnt." ".$tmp[1]."\n";
                    print $seq."\n";
                    $cnt++;
                }
                ); 

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

