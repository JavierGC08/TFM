#!/bin/bash

#Javier Gutiérrez Corral 08/12/2023

# ----------------
#Parametros de entrada y variables que se utilizan
#-----------------

lista=$1
outdir=$2

#-----------------
#Comprobación de si se han introducido los 2 parametros
#-----------------

if [ ! $# -eq 2 ]
then
echo -e " No hay 2 parametros"
exit
fi
echo -e " Hay dos parametros"

#-----------------
#Comprobación de si existe la lista
#-----------------

if [ ! -f $lista ]
then
echo -e "La lista no existe"
exit
fi
echo -e "la lista existe"

if [  ! -d $outdir ] 
then
echo -e "El directorio no existe, creando uno"
mkdir $outdir
fi


#------------------
#Aqui comienza el script, comienza con todos los accesion numbers de una lista y les va añadiendo al final lo necesario para poder descargarlo
#------------------

list=$( cat $lista)
end="_1.fastq"

for i in $list
do
	name=$outdir"/"$i$end
	echo -e $name
	if [  ! -f $name ]
	then
		echo -e "prefetching $i"
		~/Downloads/sratoolkit.3.0.7-ubuntu64/bin/prefetch $i
		echo -e "dumping $i"
		~/Downloads/sratoolkit.3.0.7-ubuntu64/bin/fasterq-dump $i
fi
	
done

echo -e "El script se ha ejecutado correctamente"
