#11 Feb 2017 M. Andrew Johnston
#Convert aligned fasta file to phylip
#assumes 2 inputs, 1= fasta input name, 2= phylip output name
import sys
infile=sys.argv[1]
outfile=sys.argv[2]
taxa=[]
seqs=[]
seq=""

with open(infile, "r", encoding="utf-8") as infile:
    for line in infile:
        if line.strip() != "":
            
            if line[0] == ">":
                if seq!="":
                    taxa.append(taxon)
                    seqs.append(seq)
                taxon=line.strip()[1:]
                seq=""
            else:
                seq=seq+line.strip()
    taxa.append(taxon)
    seqs.append(seq)

with open(outfile, "w", encoding="utf-8") as outfile:
    outfile.write(str(len(taxa))+" "+str(len(seqs[0]))+"\n")
    for item in taxa:
        outfile.write(item+"\t"+seqs[taxa.index(item)]+"\n")
        
    

                    
