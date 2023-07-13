#!/usr/bin/env perl

use strict;
use warnings;

my $desc = {};
open(INFO, '<', $ARGV[0]) or die $!;
my $hdr = <INFO>; # skip first line
while (my $line = <INFO>) {
    chomp($line);
    my @f = split(/\t/, $line);
    $desc->{$f[0]} = $f[11];
}
close(INFO);

foreach my $acc (keys %$desc) {
    if ( -f $ARGV[1] . '/' . $acc . '.hmm') {
    open(HMM, '<', $ARGV[1] . '/' . $acc . '.hmm') or print STDERR "missing file: " . $ARGV[1] . '/' . $acc . '.hmm';
    while (my $line = <HMM>) {

        print $line;

        if (substr($line,0,4) eq 'NAME') {
            my ($name) = ($line =~ /^NAME  (.+)$/);

            # create accession
            print "ACC   $name\n";

            # create description
            print "DESC  " . $name . " " . $desc->{$acc} . "\n";
        }
    }
    close(HMM);
    }
}

