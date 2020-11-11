#
# takes in distance file, count file, and cutoff value and generate a
# count_tibble file to indicate the number of times each asv appears
# in each genome
#
# input: target - file name in the format of data/v4/rrnDB.01.count_tibble
#               - this file name is also the output!
#               - the "01" in this example is threshold (i.e. 0.01)

TARGET=$1 # data/v4/rrnDB.01.count_tibble
STUB=`echo $TARGET | sed -E "s/(.*rrnDB).*/\1/"`
THRESHOLD=`echo $TARGET | sed -E "s/.*rrnDB\.(.*).count_tibble/\1/"`

DISTANCES=$STUB.unique.dist
COUNT=$STUB.count_table
CUTOFF=0.$THRESHOLD

code/mothur/mothur "#cluster(column=$DISTANCES, count=$COUNT, cutoff=$CUTOFF);
  make.shared()"

code/convert_shared_to_tibble.R $STUB.unique.opti_mcc.shared $TARGET

# Garbage collection
rm $STUB.unique.opti_mcc.list
rm $STUB.unique.opti_mcc.steps
rm $STUB.unique.opti_mcc.sensspec
rm $STUB.unique.opti_mcc.shared
