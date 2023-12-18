#!/bin/bash 

#Javier Gutiérrez Corral 08/12/2023

resultdir=/home/proyectos/hyzo/compartida/output/bowtie2
workdir=/temporal/jcorral/output

#--Comprueba si el workdir existe, si existe lo elimina sino lo crea
if [ -d $workdir ]
	then
	rm -fr $workdir
fi
mkdir -p $workdir

#--Entrar en el directorio de trabajo
cd $workdir 

#--Copiar los datos necesarios
cp /home/proyectos/hyzo/compartida/data/SRR12762980_1_paired.fastq $workdir
cp /home/proyectos/hyzo/compartida/data/SRR12762980_2_paired.fastq  $workdir
cp /home/proyectos/hyzo/compartida/data/index/*.bt2 $workdir
cp /home/proyectos/hyzo/compartida/output/transcripts.fasta $workdir

#--Cargar los módulos y utilizar el comando necesario
module load bowtie2/2.5.0
bowtie2  -p 24 -x index -1 SRR12762980_1_paired.fastq -2 SRR12762980_2_paired.fastq -q -S ref.sam 
module unload bowtie2/2.5.0

#--Copiar los resultados 
cp -r $workdir $resultdir
cp ref.sam $resultdir

#--Eliminar el directorio de trabajo 
rm -rf $workdir
