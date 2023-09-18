#!/usr/bin/env perl

use strict;
use warnings;

my $file = shift @ARGV;

open(F, $file) or die "Cannot read $file\n";

_read_fasta_file(\*F,
                sub {
                    my ($name, $seq) = @_;
					# >UniRef50_A0A5A9P0L4 peptidylprolyl isomerase n=1 Tax=Triplophysa tibetana TaxID=1572043 RepID=A0A5A9P0L4_9TELE
                    my ($n) = $name =~ /^(.*)\sn\=\d+\s/;
                    print ">$n\n";
                    print $seq."\n";
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
        if (/^>(.+)/) {
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

