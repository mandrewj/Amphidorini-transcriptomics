#!/bin/bash

#11 Feb 2017 MAJ modified version from KK script
#Searches for every folder starting with ORTHMCL* to align AA fasta
#If there is no *_AA.fa fasta, then it moves the folder 

mkdir -p failed_groups/no_fasta
#hardcoded processor number since this is just my computer ... could make it n argument as $1, etc.
PROC=7
startdir=$(pwd)
echo "Starting in $startdir ..."
echo date
echo "Aligning NUCL fastas in ORTHOMCL sub-directories..."
for GROUP in $(ls -d ORTHOMCL*/)

do
	cd $GROUP
	input="$(echo *_NUCL.fa)"
	#make sure there is a fasta to align, if not chunk the group
	if [ "$input" == "" ]
	then
		cd $startdir
		mv $GROUP failed_groups/no_fasta/
		echo $GROUP had no NUCL fasta, was removed.
	else
		out=${input%.fa}_aln.fa
		mafft --quiet --thread $PROC $input>$out
		echo $input aligned
		cd $startdir
	fi
done
echo -e "\n\n#########\n$(date)\nDone aligning\n##########"
cd $startdir
