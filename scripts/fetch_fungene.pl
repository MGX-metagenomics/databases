#!/usr/bin/env perl

use LWP::Simple;

use strict;
use warnings;

my $content = get('http://fungene.cme.msu.edu/');
die "Couldn't get index page" unless defined $content;
my @lines = split(/\n/, $content);

$|=1;

my $category = undef;

open(SUM, '>', 'funGenesummary.tsv') or die;

foreach my $l (@lines) {
    if (index($l, 'hilite') != -1) {
        ($category) = ($l =~ /hilite">([\w\s]+)</);
    }
    if (index($l, 'class="gene"') != -1) {
        my ($hmmid, $name) = ($l =~ /hmm_id=(\d+)">([-\w\s]+)</);
        die "Invalid gene line: $l\n" unless (defined($name) and defined($hmmid));
        print SUM $name."\t". $hmmid . "\t".$category . "\n";
        download_hmm($category, $hmmid, $name);
    }
}

close(SUM);

sub download_hmm {
    my ($category, $hmmid, $name) = @_;
    die "No category\n" unless defined($category);
    die "No ID\n" unless defined($hmmid);
    die "No name\n" unless defined($name);

    if ( -f $name.'.hmm') {
        #print STDERR "HMM data for $name ($hmmid) already present.\n";
        return;
    }
    print STDERR "fetching HMM data for $name ($hmmid).\n";
    my $hmmdata = get('http://fungene.cme.msu.edu/hmm_download.spr?hmm_id=' . $hmmid);
    if (defined($hmmdata) && length($hmmdata) > 0) {
        my @lines = split(/\n/, $hmmdata);
        foreach my $line (@lines) {
            if (index($line, 'NAME') == 0) {
                #print STDERR "1: $line\n";
                $line =~ s/^(NAME\s{2})(\S+)$/$1$name/;
                #print STDERR "2: $line\n";
            }
        }
        $hmmdata = join("\n", @lines);
        $hmmdata .= "\n" unless ($hmmdata =~ /\n$/);
        open(O, '>', $name.'.hmm') or die;
        #open(O, '>>', 'funGene.hmm') or die;
        print O $hmmdata;
        close(O);
    } else {
        print STDERR "No HMM data for $name ($hmmid).\n";
    }
}

