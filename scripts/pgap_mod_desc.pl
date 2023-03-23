#!/usr/bin/env perl

use strict;
use warnings;

open(HMM, '<', $ARGV[0]) or die;
while (my $line = <HMM>) {
    if (substr($line,0,4) eq 'DESC') {
        $line =~ s/NCBIFAM: //;
        $line =~ s/NCBI Protein Cluster \(PRK\): //;
        $line =~ s/JCVI: //;
    }
    print $line;
}

close(HMM);
