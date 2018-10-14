#!/bin/bash
#11 Feb 2017 - MAJ rewrote script originally by K. Kanda
##Modeltest for fastortho results. Call from folder with cluster subdirectories

#Set number of processors, hard coded but could be a script variable, e.g. $1
PROC=8


startdir=$(pwd)
echo -e "\n##########"
echo "Starting in $startdir ..."
echo $(date)
echo -e "Running Prottest on ortholog groups\n"

let count=0
for GROUP in $(ls -d ORTHOMCL*/)

do
	echo "Running prottest on $GROUP ..."
	groupdir=${startdir}/$GROUP
	input=${groupdir}${GROUP%/}_AA_aln_1line_longcontigs.fa
	output=${input}.modelout
	#go to prottest folder
	cd '/home/andrew/phylo_path/prottest-3.4.2'
	#run prottest, send text to "not stdout" 
	java -jar prottest-3.4.2.jar -threads $PROC  -G -i $input -o $output > /dev/null

	#return to current group directory
	cd $groupdir

	grep -m 1 -A 15 "Confidence Interval" ${GROUP%/}_AA_aln_1line_longcontigs.fa.modelout | grep -m 1 "+G" | cut -d " " -f 1 | tr [a-z] [A-Z] | sed 's/+G//g'>raxmlmodel	
	cd $startdir
done

echo -e "\n#########\n$(date)\nDone selecting models\n##########"
cd $startdir
