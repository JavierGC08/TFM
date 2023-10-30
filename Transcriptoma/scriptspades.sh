#!/bin/bash 

resultdir=/home/proyectos/hyzo/compartida/output
workdir=/temporal/jcorral/output

#--Check if workdir exits, if so delete it, and then create it 
if [ -d $workdir ]
	then
	rm -fr $workdir
fi
mkdir -p $workdir
cd $workdir # entering workdir

#--Copy required data to temporal folder
cp /home/proyectos/hyzo/compartida/data/SRR12762980_1_paired.fastq $workdir
cp /home/proyectos/hyzo/compartida/data/SRR12762980_2_paired.fastq $workdir

#--Running 
module load spades/3.15.4
spades.py --rna -t 24 -1 SRR12762980_1_paired.fastq -2 SRR12762980_2_paired.fastq -o output
module unload spades/3.15.4

#--Copy results 
cp -r output $resultdir

#--Remove working directory to release disk space 
rm -rf $workdir
