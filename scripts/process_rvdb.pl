#!/usr/bin/env perl

use strict;
use warnings;

my $annotDir = $ARGV[0] . '/';

while (my $line = <STDIN>) {
    print $line;

    if (substr($line,0,4) eq 'NAME') {
        my ($name) = ($line =~ /^NAME  (.+)$/);

        # transfer name to accession
        print "ACC   $name\n";

        my ($num) = ($name =~ /FAM(\d+)$/);
        $num = int($num); # remove leading zeroes
        my $desc = read_annot($annotDir . $num . '.txt');

        print "DESC  ".$desc."\n";
    }
}

sub read_annot {
    my $annotFile = shift;
    die unless -f $annotFile;
    open(A, '<', $annotFile) or die $!;
    my $lca;
    my $desc;
    while (my $line = <A>) {
        chomp($line);
        #if (substr($line,0,3) eq 'LCA') {
        #    (undef, $lca) = split(/\s+/, $line);
        #    #print $lca . "\n";
        #}
        if ($line eq 'SEQUENCES:') {
            # read first description
            $line = <A>;
            chomp($line);
            $desc = substr($line, rindex($line, '|')+1);
            $desc = substr($desc, 0, index($desc, '[')-1);
        }
    }
    close(A);
    return $desc;
}
