#!/bin/bash

directorio=$1
adaptadores=$2
#------------------
#Aqui comienza el script, elimina lo necesario para poder iterar sobre todos los fastq a trimmear
#------------------


ls $directorio | grep -E "*1.fastq$" > fastq.txt

list=$( cat fastq.txt)
list2=$( awk -F "_" '{print $1}' fastq2)
cd $directorio

for i in $list2
do

trimmomatic PE -phred33 $i"_"1.fastq $i"_"2.fastq $i"_"1_paired.fastq $i"_"1_unpaired.fastq $i"_"2_paired.fastq $i"_"2_unpaired.fastq LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:80
echo -e "$i"
done
echo -e "El script se ha ejecutado correctamente"
