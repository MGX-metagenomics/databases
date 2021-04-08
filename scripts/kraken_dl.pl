#!/usr/bin/perl

use File::Basename;
use Bio::SeqIO;
use Bio::PrimarySeq;

my $fa = $ARGV[0];
my $taxid = $ARGV[1];

# get the assembly file
system("wget -q -O tmp.fna.gz $fa") == 0
    or die "failed: $?";

# open the file
my $fname = basename($fa);
$fname =~ s/\.gz//g;

open(IN, "zcat tmp.fna.gz |");
my $in = Bio::SeqIO->new(-fh => \*IN, -format => 'fasta');

# open output - sorry about the hardcoded name!
my $out = Bio::SeqIO->new(-file => ">$fname", -format => 'fasta');

# iterate over sequences
while(my $seq = $in->next_seq()) {

	# add kraken:taxid to the unique ID
	my $id = $seq->primary_id;
	$id = $id . '|' . "kraken:taxid" . '|' . $taxid;
	
	# create new seq object with updated ID
	my $newseq = Bio::PrimarySeq->new(-id => $id, -seq => $seq->seq, -desc => $seq->description);

	# write it out
	$out->write_seq($newseq);
}

close IN;

unlink("tmp.fna.gz");
