#!/bin/bash 

resultdir=/home/proyectos/hyzo/compartida/output/bowtie2
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
cp /home/proyectos/hyzo/compartida/data/SRR12762980_2_paired.fastq  $workdir
cp /home/proyectos/hyzo/compartida/data/index/*.bt2 $workdir
cp /home/proyectos/hyzo/compartida/output/transcripts.fasta $workdir

#--Running 
module load bowtie2/2.5.0
bowtie2  -p 24 -x index -1 SRR12762980_1_paired.fastq -2 SRR12762980_2_paired.fastq -q -S ref.sam 
module unload bowtie2/2.5.0

#--Copy results 
cp -r $workdir $resultdir
cp ref.sam $resultdir
#--Remove working directory to release disk space 
rm -rf $workdir
