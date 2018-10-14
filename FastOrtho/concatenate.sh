#!/bin/bash
#Concatenate 29taxa 1:1s from 1line fasta files
#assumes PWD is full of subdirectories of ortholog groups
#assumes "taxa.txt" is in PWD which lists all required taxa.
#assumes looking for 29 taxa



for GROUP in $(ls -d ORTHOMCL*/)
do
	
	echo $GROUP
	#echo ${GROUP}*_AA_aln_1line.fa

	if [ $(cat ${GROUP}*_AA_aln_1line.fa | wc -l ) -eq 58 ]
	then
		while read taxon; do
			grep -A 1 $taxon ${GROUP}*_AA_aln_1line.fa | tail -1 >> ${taxon}.txt
		done < taxa.txt
	else
		echo Not enough taxa
	
	fi
done

echo Finished!
