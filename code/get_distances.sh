#
# takes in fasta file and calcualtes a distance file in mothur's column format
# the default is to use a cutoff of 0.05
#
# input: target - the distance matrix name, which is also the output!

TARGET=$1 # data/v4/rrnDB.unique.dist

ALIGN=`echo $TARGET | sed -E "s/dist/align/"`

code/mothur/mothur "#dist.seqs(fasta=$ALIGN, cutoff=0.10)"
