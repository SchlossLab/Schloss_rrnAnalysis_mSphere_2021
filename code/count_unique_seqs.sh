#!/usr/bin/env bash

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


mv $STUB_TEMP.unique.align $STUB.unique.align
mv $STUB_TEMP.count_table $STUB.count_table

rm $STUB_TEMP.names
rm $STUB_TEMP.groups
rm $STUB_TEMP.align
