# Trabajo de Fin de Máster: Estudio de los genes relacionados con la especiación en *Chorthippus parallelus*

Este github es parte del trabajo de fin de máster **Javier Gutiérrez Corral**. Esta organizado según los objetivos a alcanzar:

## ÍNDICE

- [BASE DE DATOS](/Base_de_datos/)
- [TRANSCRIPTOMA](/Transcriptoma/)
- CLINAS

## SERVIDORES DEL CENTRO DE COMPUTACIÓN CIENTÍFICA 

Durante el desarrollo del TFM, se tuvo acceso a los servidores del Centro de Computación Científica ([CCC](/https://www.ccc.uam.es/index.html/)) de la UAM, que disponen de 2 máquinas (64 cores / 512 Gb de RAM), lo que permitió la realización de este trabajo.
El acceso al mismo se realizaba mediante `ssh` junto a `jcorral@login1.ccc.uam.es`, cambiando el nombre de usuario por el correspondiente en cada caso.
El cluster esta organizado en varios directorios, siendo los más importantes:
- *temporal*: Donde se almacenarán temporalmente todos los datos necesarios para realizar cada trabajo, este se debe borrar al acabar.
- *home*: Es la carpeta *root* de cada usurio, en ella es dondo se guardan los scripts de cada trabajo y los archivos .log que se obtienen al acabar.
- *proyecto*: Carpeta asociada a un proyecto concreto. En esta es donde se guardan los resultados de cada trabajo al acabar.

Este script es un ejemplo de los que se utilizaron en el trabajo, se siguió la estructura propuesta por el [Github](https://github.com/ARastrojo/UAM-BIO) del responsable técnico del cluster UAM-BIO ([alberto.rastrojo@uam.es]((/mailto:alberto.rastrojo@uam.es/))):

```
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
``` 
Para mandar el script a la cola: `sbatch -A hyzo_serv -p bio,biobis -N 1 -n 24 -o log.txt -s bowtiescript.sh`
Siendo `A` el nombre del proyecto asociado, `p` nombre de las colas a los que se mandará el trabajo, `N` número de máquinas a utilizar, `n` número de procesadores, `o` registro del proceso y `s` el script que se correrá.
