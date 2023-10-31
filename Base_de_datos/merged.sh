#!/bin/bash

#!/bin/bash

# ----------------
#Parametros de entrada y variables que se utilizan
#-----------------

dir=$1
outfile=$2
lista=$( find ~/TFM/BaseDatos/Data/Query_seqs -name "*.fas")

#-----------------
#Comprobación de si se han introducido los 3 parametros
#-----------------

if [ ! $# -eq 3 ]
then
      echo -e " No hay 3 parametros"
      exit
fi

#-----------------
#Comprobación de si existe el directorio
#-----------------

if [  ! -d $dir ]
then
      echo -e "El directorio no existe"
      exit
fi

#------------------
#Si existe el outfile, se borra para crear uno nuevo y no solapar resultados
#------------------

if [ -e $outfile ]
then
rm $outfile
echo -e "Existe el outfile, se borrará"
fi


#------------------
#Aqui comienza el script, comenzando mirando todos los elementos que aparecen en la lista de string que se han introducido y se añaden a un archivo temporal que se utilizará después
#------------------

echo -e " " > $outfile

for i in $lista
do
	echo -e "$i"
        cat $i >> $outfile
done

echo -e "El script se ha ejecutado correctamente"
