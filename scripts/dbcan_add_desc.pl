#!/usr/bin/env perl

use strict;
use warnings;

my $desc = {};
open(INFO, '<', $ARGV[0]) or die;
while (my $line = <INFO>) {
    if (substr($line,0,1) ne '#') {
        chomp($line);
        my @f = split(/\t\s+/, $line);
        $desc->{$f[0]} = $f[1];
    }
}
close(INFO);

open(HMM, '<', $ARGV[1]) or die;
while (my $line = <HMM>) {
    if (substr($line,0,3) ne 'ACC') {
        print $line;
    }

    if (substr($line,0,4) eq 'NAME') {
        my ($name) = ($line =~ /^NAME  (.+)$/);
        if ($name =~/\.hmm$/) { substr($name,-4 ) = ''; }

        # transfer name to accession
        print "ACC   $name\n";

        if (($name eq 'GT2_Cellulose_synt') or
            ($name eq 'GT2_Chitin_synth_1') or
            ($name eq 'GT2_Chitin_synth_2') or
            ($name eq 'GT2_Glycos_transf_2') or
            ($name eq 'GT2_Glyco_tranf_2_2') or
            ($name eq 'GT2_Glyco_tranf_2_3') or
            ($name eq 'GT2_Glyco_tranf_2_4') or
            ($name eq 'GT2_Glyco_tranf_2_5') or
            ($name eq 'GT2_Glyco_trans_2_3')) {
            # entry already has a description
        } else {

            if (defined($desc->{$name})) {
                print "DESC  $name ".$desc->{$name}."\n";
            } else {
                print "DESC  $name\n";
            }
        }
    }
}
close(HMM);
