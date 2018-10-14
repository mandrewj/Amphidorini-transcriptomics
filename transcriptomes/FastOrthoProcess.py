#!/usr/bin/python3
#Written by M.A.Johnston Feb 10, 2017
#Parses FastOrtho output file into directories of individual fasta files.
#Takes as input 3 command arguments:
#1 - .end file to parse
#2 - directory for AA transcriptomes (single-line fasta format)
#3 - directory for NUCL transcriptomes (single-line fasta format)

import subprocess, os, sys



def fileprep():
    #Creating the output directory
    if not os.path.exists('OrthoGroups'):
        os.mkdir('OrthoGroups')
    #Simple check for 3 arguments, hopefully they are in the correct order...
    if len(sys.argv) == 4:
        return True
    else:
        print("Expecting 3 variables as input, .end file, AA dir, NUCL dir")
        return False

def parseortho(orthoIn):
    #Raed ortholog groups and closes that file.
    #Pass each group to decode function
    orthogroups=[]
    print("parsing "+orthoIn+" for groups")
    with open(orthoIn,"r", encoding="utf-8") as orthoInFile:
        for line in orthoInFile:
            orthogroups.append(line.strip())
    for group in orthogroups:
        decode(group)

def decode(grouptext):
    #This is peculiar to the FastOrtho (maybe OrthMCL?) output
    #Decodes the line, making 'ORTHOMCL###' the name
    #Searches for each listed gene and creates resultant fasta files
    elem=str(grouptext).split("\t")
    name=elem[0][:elem[0].find(" ")]
    print("Parsing "+name+" ...")
    outdir="OrthoGroups/"+name
    if not os.path.exists(outdir):
        os.mkdir(outdir)
        genelist=elem[1].strip().split(" ")
        for gene in genelist:
            query=gene.strip()[:gene.find(":")]
            taxon=gene[gene.find("(")+1:gene.find("_AA")]
            header=">"+taxon+"|"+query+"\n"
            #Note: this assumes *_AA.fa and *_NUCL.fa filenames
            #get and write AA sequence
            AAseq=extract(AAdir+taxon+"_AA.fa",query)
            with open(outdir+"/"+name+"_AA.fa","a",encoding="utf-8") as outfile:
                outfile.write(header)
                outfile.write(AAseq+"\n")
            #get and write NUCL sequence
            NUCLseq=extract(NUCLdir+taxon+"_NUCL.fa",query)
            with open(outdir+"/"+name+"_NUCL.fa","a",encoding="utf-8") as outfile:
                outfile.write(header)
                outfile.write(NUCLseq+"\n")
    else:
        print("The folder "+outdir+" already exists, did not parse this group.")
            
    


def extract(taxfile,gene):
    #utilizes bash grep command to find sequence
    cmd="grep -A 1 '"+str(gene)+"::' "+taxfile
    result=subprocess.check_output(cmd, shell=True)
    #need to change to string and remove some oddball terminal format issues
    seq=str(result)[2:-3]
    seq2=seq.split("\\n")
    return seq2[1]


def main():
    #Check fileprep for validity, if O.K., call parseortho
    valid=fileprep()
    if valid:
        AAdir=sys.argv[2]
        NUCLdir=sys.argv[3]
        parseortho(sys.argv[1])
    





if __name__ == "__main__":
    #This sets some 'global' variables ... I think.
    AAdir=sys.argv[2]
    NUCLdir=sys.argv[3]
    #Run the main function
    main()
