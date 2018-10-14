#!/bin/bash
#11 Feb 2017 - MAJ rewritten from K.Kanda
##This will calculate the .besttree, the bootstrap, and then draw BS support values on best-known ML tree
#assumes fasta_to_phylip.py is in same directory as this script

NumProc=4

startdir=$(pwd)
echo -e "\n##########"
echo "Starting in $startdir ..."
echo $(date)
echo -e "Running RAxML on ortholog groups\n"

for GROUP in $(ls -d ORTHOMCL*/)
do

	cd $GROUP
	#MAKE SURE THIS GOES TO THE PYTHON SCRIPT!!!!!!
	python3 ${startdir}/all_scripts/fasta_to_phylip.py ${GROUP%/}_NUCL_aln_1line_longcontigs.fa ${GROUP%/}_NUCL.phy
	
	#Run raxml
	rand=$RANDOM
	#ML search (10 independant searches)
	raxml -s ${GROUP%/}_NUCL.phy -n ${GROUP%/}NUCL -m GTRGAMMA -f d -# 10 -T $NumProc -p $rand
	# 100 bootstrap replicates	
	raxml -s ${GROUP%/}_NUCL.phy -n ${GROUP%/}NUCLBS -m GTRGAMMA -f d -# 100 -T $NumProc -p $rand -b $rand
	#draw BS bipartitions on best tree	
	raxml -s ${GROUP%/}_NUCL.phy -n ${GROUP%/}NUCLbip -m GTRGAMMA -f b -T $NumProc -t RAxML_bestTree.${GROUP%/}NUCL -z RAxML_bootstrap.${GROUP%/}NUCLBS

	#clean-up time.
	mkdir -p raxml
	mv RAxML* raxml/
	cp raxml/RAxML_bipartitions.${GROUP%/}NUCLbip ${GROUP%/}_NUCLbip.tre
	
	cd $startdir

done


echo -e "\n#########\n$(date)\nDone inferring trees\n##########"
cd $startdir
