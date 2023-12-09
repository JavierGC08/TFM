#!/bin/bash

#Javier Gutiérrez Corral

resultdir=/home/proyectos/hyzo/compartida/data/reads/diamond
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
cp /home/proyectos/hyzo/compartida/data/reads/nr.gz $workdir
cp /home/proyectos/hyzo/compartida/data/reads/catalog_normal_annotated.fasta $workdir
cp /home/proyectos/hyzo/compartida/data/reads/prot.accession2taxid.FULL.gz $workdir
cp /home/proyectos/hyzo/compartida/data/reads/nodes.dmp $workdir

#--Cargar los módulos y utilizar el comando necesario
gzip -d nr.gz
rm nr.gz
/home/proyectos/hyzo/compartida/diamond --version
/home/proyectos/hyzo/compartida/diamond makedb --in nr -d nrdb --taxonnodes nodes.dmp --taxonmap prot.accession2taxid.FULL.gz
/home/proyectos/hyzo/compartida/diamond  blastx --log -d nrdb --taxonlist 6656 -q catalog_normal_annotated.fasta --very-sensitive -o matchesNR.tsv

#--Copiar los resultados 
cp matchesNR.tsv $resultdir
cp nrdb.dmnd $resultdir

#--Eliminar el directorio de trabajo 
rm -rf $workdir
