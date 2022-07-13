#!/usr/bin/env perl

use Bio::SeqIO;

$in  = Bio::SeqIO->new(-file => "/dev/fd/0" , -format => 'genbank');
$out = Bio::SeqIO->new(-file => ">/dev/fd/1" , -format => 'Fasta');

while ( my $seq = $in->next_seq() ) {
    $out->write_seq($seq);
}
