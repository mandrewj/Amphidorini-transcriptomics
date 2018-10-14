#!/bin/bash
#13 Feb 2017 - MAJ 
#This script collects all the gene trees (best and bootstraps) into files for ASTRAL analysis
#this is a modified script to pull the bootstrap files into a useable form for ASTRAL

NumProc=8

startdir=$(pwd)
echo -e "\n##########"
echo "Starting in $startdir ..."
echo $(date)
mkdir -p ASTRAL/bootstrap
touch ASTRAL/genetrees.tre
touch ASTRAL/BStrees
echo -e "Gathering Gene trees to place in the directory ASTRAL ...\n"


for GROUP in $(ls -d ORTHOMCL*/)
do

	#Get the best tree into our file...
	cat ${GROUP}${GROUP%/}_bip.tre >> ASTRAL/genetrees.tre
	#Get the BS trees into our file...
	cp ${GROUP}raxml/RAxML_bootstrap.${GROUP%/}BS ASTRAL/bootstrap
	echo ${startdir}/ASTRAL/bootstrap/RAxML_bootstrap.${GROUP%/}BS >> ASTRAL/BStrees

done

echo -e "\nCleaning gene ID's from tree files ...\n"
cat ASTRAL/genetrees.tre | sed -e 's/|Gene.[0-9]\{1,\}//g' > ASTRAL/genetrees_clean.tre

for FILE in ASTRAL/bootstrap/RAxML_bootstrap*
do
	sed -i 's/|Gene.[0-9]\{1,\}//g' $FILE
done
echo -e "\n#########\n$(date)\nDone assembling and cleaning trees\n##########"
cd $startdir