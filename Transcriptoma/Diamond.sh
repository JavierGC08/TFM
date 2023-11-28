#!/bin/bash
resultdir=/home/proyectos/hyzo/compartida/data/reads/diamond
workdir=/temporal/jcorral/output

#--Check if workdir exits, if so delete it, and then create it
if [ -d $workdir ]
      then
      rm -fr $workdir
fi
mkdir -p $workdir
cd $workdir # entering workdir

#--Copy required data to temporal folder
cp /home/proyectos/hyzo/compartida/data/reads/nr.gz $workdir
cp /home/proyectos/hyzo/compartida/data/reads/catalog_normal_annotated.fasta $workdir
cp /home/proyectos/hyzo/compartida/data/reads/prot.accession2taxid.FULL.gz $workdir
cp /home/proyectos/hyzo/compartida/data/reads/nodes.dmp $workdir
#--Running
gzip -d nr.gz
rm nr.gz
/home/proyectos/hyzo/compartida/diamond --version
/home/proyectos/hyzo/compartida/diamond makedb --in nr -d nrdb --taxonnodes nodes.dmp --taxonmap prot.accession2taxid.FULL.gz
/home/proyectos/hyzo/compartida/diamond  blastx --log -d nrdb --taxonlist 6656 -q catalog_normal_annotated.fasta --very-sensitive -o matchesNR.tsv

#--Copy results
cp matchesNR.tsv $resultdir
cp nrdb.dmnd $resultdir
#--Remove working directory to release disk space
rm -rf $workdir
