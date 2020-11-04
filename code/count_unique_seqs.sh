#!/usr/bin/env bash

# name: count_unique_seqs.sh
#
# takes in fasta file and uniques and counts the sequences. it then converts count_table to a
# tibble with columns esv, genome, and count to indicate the number of times each esv appears
# in each genome
#
# input: target - either the count_tibble or align file - also the output!

TARGET=$1 # data/v19/rrnDB.unique.align

STUB=`echo $TARGET | sed -E "s/(.*rrnDB).*/\1/"`
STUB_TEMP=$STUB.temp

ALIGN=$STUB.align
TEMP_ALIGN=$STUB_TEMP.align
TEMP_GROUPS=$STUB_TEMP.groups

sed -E "s/>.*\|(.*)\|(.*)\|.*\|(.*)_.$/>\1|\2|\3/" $ALIGN > $TEMP_ALIGN

grep ">" $TEMP_ALIGN | sed -E "s/>((.*)\|.*\|.*)/\1 \2/" > $TEMP_GROUPS

code/mothur/mothur "#unique.seqs(fasta=$TEMP_ALIGN);
	count.seqs(group=$TEMP_GROUPS, compress=FALSE)"

code/convert_count_table_to_tibble.R $STUB_TEMP.count_table $STUB.esv.count_tibble

mv $STUB_TEMP.unique.align $STUB.unique.align

rm $STUB_TEMP.count_table
rm $STUB_TEMP.names
rm $STUB_TEMP.groups
rm $STUB_TEMP.align
