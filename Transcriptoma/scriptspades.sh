#!/bin/bash 

#Javier Gutiérrez Corral 08/12/2023

resultdir=/home/proyectos/hyzo/compartida/output
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
cp /home/proyectos/hyzo/compartida/data/SRR12762980_2_paired.fastq $workdir

#--Cargar los módulos y utilizar el comando necesario
module load spades/3.15.4
spades.py --rna -t 24 -1 SRR12762980_1_paired.fastq -2 SRR12762980_2_paired.fastq -o output
module unload spades/3.15.4

#--Copiar los resultados 
cp -r output $resultdir

#--Eliminar el directorio de trabajo 
rm -rf $workdir
