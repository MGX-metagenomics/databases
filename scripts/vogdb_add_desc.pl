#!/usr/bin/env perl

use strict;
use warnings;

my $desc = {};
open(INFO, '<', $ARGV[0]) or die;
while (my $line = <INFO>) {
    if (substr($line,0,1) ne '#') {
        chomp($line);
        my @f = split(/\t/, $line);
        $f[4] = substr($f[4], index($f[4], ' ')+1);
        $desc->{$f[0]} = $f[4];
    }
}
close(INFO);

while (my $line = <STDIN>) {
    print $line;

    if (substr($line,0,4) eq 'NAME') {
        my ($name) = ($line =~ /^NAME  (.+)$/);

        # transfer name to accession
        print "ACC   $name\n";

        if (defined($desc->{$name})) {
            print "DESC  ".$desc->{$name}."\n";
        } else {
            print "DESC  $name\n";
        }
    }
}
