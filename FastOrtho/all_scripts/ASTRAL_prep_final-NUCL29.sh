#!/bin/bash
#modified filename to ASTRAL29
#13 Feb 2017 - MAJ 
#This script collects all the gene trees (best and bootstraps) into files for ASTRAL analysis
#this is a modified script to pull the bootstrap files into a useable form for ASTRAL
#Script modified 28 Sept 2018 MAJ - keeps nucleotide data in separate directory than previous AA analysis

NumProc=8

startdir=$(pwd)
echo -e "\n##########"
echo "Starting in $startdir ..."
echo $(date)
mkdir -p ASTRAL29NUCL/bootstrap
touch ASTRAL29NUCL/genetrees.tre
touch ASTRAL29NUCL/BStrees
echo -e "Gathering Gene trees to place in the directory ASTRAL ...\n"


for GROUP in $(ls -d ORTHOMCL*/)
do

	#Get the best tree into our file...
	cat ${GROUP}${GROUP%/}_NUCLbip.tre >> ASTRAL29NUCL/genetrees.tre
	#Get the BS trees into our file...
	cp ${GROUP}raxml/RAxML_bootstrap.${GROUP%/}NUCLBS ASTRAL29NUCL/bootstrap
	echo ${startdir}/ASTRAL29NUCL/bootstrap/RAxML_bootstrap.${GROUP%/}NUCLBS >> ASTRAL29NUCL/BStrees

done

echo -e "\nCleaning gene ID's from tree files ...\n"
cat ASTRAL29NUCL/genetrees.tre | sed -e 's/|Gene.[0-9]\{1,\}//g' > ASTRAL29NUCL/genetrees_clean.tre

for FILE in ASTRAL29NUCL/bootstrap/RAxML_bootstrap*
do
	sed -i 's/|Gene.[0-9]\{1,\}//g' $FILE
done
echo -e "\n#########\n$(date)\nDone assembling and cleaning trees\n##########"
cd $startdir
