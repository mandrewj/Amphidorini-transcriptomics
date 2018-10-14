#!/bin/bash
#27 Sep 2018 - MAJ rewritten from fastortho pipeline
##This will calculate the .besttree, the bootstrap, and then draw BS support values on best-known ML tree
#assumes fasta_to_phylip.py is in same directory as this script

NumProc=4

startdir=$(pwd)
echo -e "\n##########"
echo "Starting in $startdir ..."
echo $(date)
echo -e "Running RAxML on ortholog groups\n"

for GROUP in $(ls -d *_GLEAN_*/)
do

	cd $GROUP
	#MAKE SURE THIS GOES TO THE PYTHON SCRIPT!!!!!!
	python3 ${startdir}/fasta_to_phylip-1k.py ${GROUP%/}_nt_align_1line_longcontigs.fa ${GROUP%/}_nt.phy
	
	#Run raxml
	rand=$RANDOM
	#ML search (10 independant searches)
	raxml -s ${GROUP%/}_nt.phy -n ${GROUP%/} -m GTRGAMMA -f d -# 10 -T $NumProc -p $rand
	# 100 bootstrap replicates	
	raxml -s ${GROUP%/}_nt.phy -n ${GROUP%/}BS -m GTRGAMMA -f d -# 100 -T $NumProc -p $rand -b $rand
	#draw BS bipartitions on best tree	
	raxml -s ${GROUP%/}_nt.phy -n ${GROUP%/}bip -m GTRGAMMA -f b -T $NumProc -t RAxML_bestTree.${GROUP%/} -z RAxML_bootstrap.${GROUP%/}BS

	#clean-up time.
	mkdir -p raxml
	mv RAxML* raxml/
	cp raxml/RAxML_bipartitions.${GROUP%/}bip ${GROUP%/}_bip.tre
	
	cd $startdir

done


echo -e "\n#########\n$(date)\nDone inferring trees\n##########"
cd $startdir
