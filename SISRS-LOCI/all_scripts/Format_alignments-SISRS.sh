#!/bin/bash
#5 Oct 2018 - modified to run on SISRS loci filenames
#11 Feb 2017 MAJ compiled, borrowing from many other sources
#This script parses alignments and removes short sequences before model testing and tree building

mkdir -p failed_groups/short_seqs
startdir=$(pwd)
echo -e "\n##########"
echo "Starting in $startdir ..."
echo $(date)
echo -e "Filtering alignments for model testing.\n"

let count=0
for GROUP in $(ls -d SISRS_NODE*/)

do

	cd $GROUP
	#Convert MAFFT alignments to 1-line fasta files.
	input=${GROUP%/}_aln.fa
	output=${input%.fa}_1line.fa
	fasta_formatter -i $input -o $output -w 0



	#Remove short sequences
	#originally called 'remove_short_seqs.sh' written by K. Kocot and edited by K. Kanda
	#####CHANGE THIS VARIABLE AS NEEDED#####
	max_percent_gaps=40
	input=$output
	output=${input%.fa}_longcontigs.fa
	bashcode='sequ=\1;dashes=$(echo "$sequ" | tr -cd "-");echo $(( ${#dashes}*100/${#sequ} > '$max_percent_gaps' ))' #Determines if the alignment contains any sequences which are more than X% gaps/missing data
	sed -r "/>/{N; /-/{h; s:.*\n(.*):$bashcode:e; /1/d; /0/x}}" $input > $output #Removes any sequences that are more than X% gaps/missing data and writes the output to $FILENAME.long

	#Count the number of unique taxa in the resulting fasta file
	ntaxa=$(cat $output | grep '>' | cut -d \| -f1 | uniq | wc -l)
	#set the number of required taxa, change as needed
	reqtaxa=29
	#reqtaxa2=29
	#remove groups without enough taxa
	if [ "$ntaxa" = "$reqtaxa" ] #|| [ "$ntaxa" = "$reqtaxa2" ]
	then
		cd $startdir
		count=$((count+1))

	else
		cd $startdir
		mv $GROUP failed_groups/short_seqs/
		echo $GROUP had short sequences, was removed.
	fi
done

echo -e "\n#########\n$(date)\nDone - $count groups are good\n##########"
cd $startdir


