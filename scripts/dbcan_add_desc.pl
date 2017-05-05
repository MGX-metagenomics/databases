#!/usr/bin/env perl

use strict;
use warnings;

my $desc = {};
open(INFO, '<', $ARGV[0]) or die;
while (my $line = <INFO>) {
    chomp($line);
    my @f = split(/\t/, $line);
    $desc->{$f[0]} = $f[3];
}
close(INFO);

open(HMM, '<', $ARGV[1]) or die;
while (my $line = <HMM>) {
    print $line;
    if (substr($line,0,4) eq 'NAME') {
        my ($name) = ($line =~ /^NAME  (.+)$/);
        if ($name =~/\.hmm$/) { substr($name,-4 ) = ''; }

        if ($name eq 'GT2_Cellulose_synt') {
            # entry already has a description
        } else {

            if (exists($desc->{$name})) {
                print "DESC  $name ".$desc->{$name}."\n";
            }
        }
    }
}
close(HMM);
