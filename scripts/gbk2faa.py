#!/usr/bin/env python

#This script is a modification of the script found in Peter Cock's site (http://www2.warwick.ac.uk/fac/sci/moac/people/students/peter_cock/python/genbank2fasta/).
# Usage: python gbk2faa.py <input> <output>

import sys
from Bio import GenBank
from Bio import SeqIO

input_handle  = open(sys.argv[1], "r")
output_handle = open(sys.argv[2], "w")

seen = dict()

for seq_record in SeqIO.parse(input_handle, "genbank") :
    #print "Dealing with GenBank record %s" % seq_record.id
    for seq_feature in seq_record.features :
        try: # Without "try", it crashes when it finds a CDS without translation (pseudogene).
            if seq_feature.type=="CDS":
                assert len(seq_feature.qualifiers['translation'])==1
                locus = seq_feature.qualifiers['locus_tag'][0].lower()
                locus = locus.replace("-", "_")
                if locus not in seen:
                    output_handle.write(">lcl|%s %s [%s]\n%s\n" % (
                        locus,
                        seq_feature.qualifiers['product'][0],
                        seq_record.description,
                        seq_feature.qualifiers['translation'][0]))
                    seen[locus] = 1
                pass
        except:
            continue

output_handle.close()
input_handle.close()
