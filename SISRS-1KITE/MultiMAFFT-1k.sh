#!/bin/bash

#27 Sept 2018 MAJ modified version from previous astral/fastortho pipeline
#Searches for every fasta in current folder and starts new directory plus aligns using mafft


mkdir -p failed_groups/no_fasta
#hardcoded processor number since this is just my computer ... could make it n argument as $1, etc.
PROC=7
startdir=$(pwd)
echo "Starting in $startdir ..."
echo date
echo "Aligning fasta files and moving to subfolders..."
for GROUP in $(ls -d *_GLEAN_*/)

do
	cd $GROUP
	input=${GROUP%/}.fa
	out=${GROUP%/}_nt_align.fa
	mafft --quiet --thread $PROC $input > $out
	cd $startdir
	echo '$GROUP aligned'

done
echo -e "\n\n#########\n$(date)\nDone aligning\n##########"
cd $startdir
