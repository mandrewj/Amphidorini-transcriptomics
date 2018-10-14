Phylotranscriptomic Analysis of the Amphidorini LeConte, 1862
======

### Analysis pipeline, scripts, and ortholog sets from M. Andrew Johnston's dissertation


------

This project is a repository to document and share the underlying methods and data for the present project.

##Transcriptomes
Raw FASTQs are not posted here but are available from the author (ajohnston@asu.edu)
Assembled Trinity transcriptomes are available in amino-acid and nucleotide formats in the included Transcriptomes folder

Transcriptomes were assembled following the Agalma pipeline (https://bitbucket.org/caseywdunn/agalma.git) followed by TransDecoder (https://transdecoder.github.io/)

##Ortholog Discovery
Three sets of orthologs were developed for this project.

### FastOrtho
The FastOrtho (https://github.com/olsonanl/FastOrtho) implementation of OrthoMCL (https://doi.org/10.1101/gr.1224503) was used on the transcriptomes developed above.

The raw output of putative ortholog groups (EleoOrtho.end) is available in compressed form in the transcriptomes folder.

1:1 Orthologs (29 genes, 29 taxa) were extracted from this file into the 1to1orthos.txt file.

The FastOrthoProcess.py script in the same folder was called to assemble each group by pulling the corresponding AA and Nucleotide sequences together from the transcriptomes into a new folder.

###SISRS-loci
The SISRS package (https://github.com/rachelss/SISRS) was used to run a standard 'loci' analysis with the genome size set to 50000 and the maximum allowed missing taxa set to 3.

From this standard output, ortholog groups were filtered to find longer genes with 29 taxa each. The following commands were used:

`#Find 1k+ loci - note no loci were over 10kbp`

`grep "_length_[0-9][0-9][0-9][0-9]" loci.txt > 1klong_loci.txt `

`#Find 400+ nt loci`

`grep "_length_[4-9][0-9][0-9]" loci.txt > long_loci.txt`

`#condense files`

`cat 1klong_loci.txt >> long_loci.txt`


Moved the length-filtered SISRS-created fastas to a new directory

`#copy fastas to new folder`

`for GROUP in $(cat long_loci.txt); do cp loci/${GROUP}.fa long_loci/ ; done`

`cd long_loci/`

`mkdir missing_taxa`

`#remove loci missing taxa (used full 29 for this run)`

`for FILE in *.fa ; do if [ $(grep -c ">" $FILE ) -lt 29 ] ; then mv $FILE missing_taxa/ ; echo $FILE missing taxa  ; fi; done`

`#created directory system`

`#had to remove the locus name in fasta files`

`for FILE in *.fa ; do mkdir ${FILE%.fa} ; cat $FILE | cut -f1,2,3 -d'_' > ${FILE%.fa}/${FILE} ; done`



###SISRS-1Kite
Conserved low-copy orthologs were developed by the insect-wide phylotranscriptomic study from the 1KITE project (https://doi.org/10.1126/science.1257570).

The darkling beetle **Triobolium castaneum** (Herbst) was incorporated in this study and the nucleotide sequences for this species were used as a reference for a SISRS assembly.

SISRS loci was called with this fasta as a reference with 0 allowed missing taxa.  From this output, all loci with 29 orthologs were moved to individual folders:

`#Copied those with 29 taxa into a new folder...`

`mkdir 29taxa`

`for FILE in *.fa; do if [ $(grep -c ">" $FILE) -eq 29 ]; then cp $FILE 29taxa/${FILE} ; fi ; done`


###Ortholog alignment and filtering
For each of these ortholog sets, individual ortholog group was aligned and checked for short sequences.  Any groups that contained a sequence that had 40% or more gaps in the final alignment was removed to avoid paralogy issues or erroneous assemblies.

Each directory contains a folder of scripts which were used to run these analyses. This step incorporated the following:
`./all_scripts/MultiMAFFT.sh`

`./all_scripts/Format_alignments.sh`


The remaining groups were passed along to the following phylogenetic analyses.

###Creating the combined ortholog set
The sequences for **Amphidora littoralis** were extracted for each ortholog and reciprocally blasted against each other to find any potential duplicates.

The folder Amphidora_genes/ contains all files used and produced from the analysis. blast_pipeline.txt shows the step=-by-step commands used. The file pairs-aligned.txt is a tab-delimited file which matches the overlapping pairs found.
One of each matches was excluded for the combined analysis (the SISRS-1Kite groups were preferentially removed since they were the most abundnat across all pairs). After duplicates were removed, the concatenation and ASTRAL preparation pipelines followed the protocols given below.



##Phylogenetic Analysis
Both concatenation and coalesct-based species-tree analyses were performed.

###Concatenation

Each ortholog folder contains a script used to concatenate all genes together.  First the sequences were split to files per taxon, then the files were combined into a phylip alignment.

`./concatenate.sh`

`#moved resultant text files to subfolder (each line is a separate locus) - all files had same line and character count`

`for FILE in *.txt ; do echo "${FILE%.txt}     $(cat $FILE | tr -d '\n')" >> alignment.phy; done`

These phylip files, available in the Concatenated_sequences folder, were then analyzed using RAxML on the CIPRES gateway(https://www.phylo.org/portal2/).

###ASTRAL-II coalescent analyses
Each a gene tree was inferred for each ortholog group using raxml, and then the gene trees and bootstrap files were moved to a folder for analysis

`#ran multi raxml script - converts fasta to phylip, runs raxml and cleans up files.`

`./all_scripts/MultiRaxml.sh`

`#gathered and cleaned all gene/BS trees for ASTRAL analysis:`

`./all_scripts/ASTRAL_prep_final.sh`

`#ran Astral using the following command:`

`cd ASTRAL/`

`java -jar '/home/andrew/phylo_path/Astral/astral.4.10.12.jar' -i genetrees_clean.tre -o astral_out -b BStrees  -r 100
`

##Further documentation
Additional notes, reasoning, and minor formatting steps taken are documented in two included text files. First, Transcriptome_Pipeline.txt documents the overall process in most detail. Second, ortholog_sets_pipeline.txt records additional analyses attempted that were mostly abandoned for this project.

###### Kojun Kanda and Aaron Smith are gratefully acknowledged for assistance with analyses and data collection
