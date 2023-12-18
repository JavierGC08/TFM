## TRANSCRIPTOMA

### Obtención de datos

Las secuencias en bruto (fastq) se obtuvieron del SRA de NCBI del trabajo realizadp por Nolen y colaboradores (2020). Dado que las secuencias superaban los 5 gigabytes, se utilizó el software SRAtoolkit 3.0.5 (NCBI) para descargarlas. Se escribió la siguiente linea de código en la terminal:

` prefetch accesionnumber ` Con el accesion number determinado.

` fasterq-dump accesionnumber ` Con el mismo accesion number.


Posteriormente, cuando se descargaron los 10 archivos necesarios, se automatizo el proceso mediante el script [download.sh](/Transcriptoma/download.sh/)

Además, se comprobó que los fastq, al tratarse de una secuenciación pair end, ambas copias tuvieran el mismo número de secuencias. Para ello se utilizó : ` wc -l file | awk "{print $1/4 }" `

### Análisis de calidad

Para el análisis de calidad se utilizó FASTQC 0.12.0,` fastqc file.fastq -o /directorio `. Puesto que el resultado general era satisfactorio ([FASTQC](/Transcriptoma/FASTQC/)), en el siguiente paso de trimming usando TRIMMOMATIC 0.32, se utilizarón los parametros por defecto ` LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:80`  con la versión ` PE `, ya que se trata de archivos *paired end* y  con el archivo adaptadores.fas(vacio al no tener niguno) para eliminar las secuencias sobrerrepresentadas:

`trimmomatic PE -phred33 forward.fastq reverse.fastq forwardpaired.fastq forwardunpaired.fastq reversepaired.fastq reverseunpaired.fastq ILLUMINACLIP:ficheroadaptadores.fas LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:80
`
Posteriormente se automatizo con el script [trimming.sh](/Transcriptoma/trimming.sh/).

Se volvió a realizar un análisis de calidad con FASTQC para comprobar que el trimming había mejorado la calidad de las secuencias. Se utilizó el mismo código que en el FASTQC anterior. 

### Ensamblado

Dado que no existe un transcriptoma de referencia que se pueda utilizar durante el ensamblado, se realizó un ensamblado de novo del transcriptoma utilizando SPAdes (Prjibelski *et al*., 2020). Para ello, se utilizaron los servidores del Centro de Computación Científica (CCC) de la UAM, mandando el script ([scriptspades.sh](/Transcriptoma/scriptspades.sh/)) y los datos al servidor. Este script es un ejemplo con una secuencia *forward* y su secuencia *reverse*, para el ensamblado definitivo se concatenaron usando `cat` todas las secuencias *forward* en un archivo y todas las secuencias *reverse* en otro.
Se utilizó la versión para RNA-seq de Spades, RNA-SPAdes 3.15.5 (Bushmanova *et al*., 2019) y no se modificaron lo parámetros de k-mer size de SPAdes, ya que el propio programa no recomienda modificarlo. 

#### Calidad del ensamblado

Se obtuvieron tres ensamblados distintos dependiendo del grado de filtrado, *hard_filtered*, *soft_filtered* y *transcripts*. Para comprobar la calidad de los tres ensamblados se utilizó la versión para RNA de Quast llamada rnaQUAST 2.2(Bushmanova *et al*.,2016 `python rnaQUAST.py -c ~/TFM/Assembly_1/output/*.fasta -o ~/TFM/Assembly_1/rnaquast
` 

Se escogió el ensamblado de hard_filtered_transcripts para los siguientes pasos dado que los tres presentaban valores de calidad muy similares, pero este destacaba. Se analizó la calidad de este ensamblado de forma independiente utilizando BUSCO 5.4.7 (Manni *et al*., 2021) , que permite analizar cuáles de los core-genes que debería presentar nuestro ensamblado se encuentran en el mismo. Uno de los inputs que requiere el programa es una base datos con la que comparar, se escogió la base de datos de artrópodos, ya que es menor nivel taxonómico en el que se incluye Orthoptera de todos los presentes en las bases de datos de BUSCO. Se utilizó el parámetro `m` para especificar que se estaba tratando con datos de RNAseq: 

`busco -m transcriptome -i transcripts.fasta -o buscoutput -l artrhopoda `


Por último, se realizó un alineamiento de las secuencias en bruto frente al ensamblado realizado. Primero se indexo el transcriptoma con `bowtie2-build` y después se mandó  el script [bowtiescript.sh](/Transcriptoma/bowtiescript.sh/) utilizando Bowtie2 2.5.2 (Langmead *et al*., 2012) a los servidores del CCC.

#### Clasificación

Al haber comprobado la calidad del ensamblado, se realizó una clasificación del RNA, pudiendo ser *non-coding* (el transcrito no codifica para una proteína, es decir no se traduce, aunque se transcribe) o *coding* (el transcrito codifica para proteína, es decir se traduce). Para ello se utilizó CPC 2.0 (Kang *et al*., 2017) de forma offline, ya que las secuencias superaban los 50 MB, mediante la siguiente línea de código:

` python ./bin/CPC2.py -i rutacompleta/transcripts.fasta -o output `

El resultado de CPC2 identifica cada uno de los transcritos como *coding* o *non-coding*, por ello se pudo separar cada transcrito utilizando el comando `grep` de la siguiente forma:

` grep -w "noncoding" output.txt > noncoding.txt `

` grep -w "coding" output.txt > coding.txt `

Ahora es necesario separar los transcritos de *hard_filtered_transcripts.fasta* dependiendo de si son codificantes o no, para ello se utilizaron dos scripts, uno para cada tipo de transcrito, pero la estructura de ambos es igual. Por ejemplo, para no codificantes se utilizó el script [NonCodingScript.ipynb](/Transcriptoma/NonCodingScript.ipynb/)

### Anotación

El grupo de investigación ya había realizado el ensamblado y anotación de un transcriptoma, además de la selección y posterior secuenciación de las regiones en las que se ha visto variación. Dado que el análisis de clinas se había realizado sobre ese transcriptoma, se utilizó [catalog_normal_annotated.fasta](https://dauam-my.sharepoint.com/:u:/g/personal/javier_gutierrezcorral_estudiante_uam_es/EYnemDcVAPJAtACdfhiad5YB_zvmeBhcQCCNiDHHrhErdg?e=esEizo) para los siguientes pasos.

#### Base de datos

Se crearon dos bases de datos de artrópodos, una con todas las secuencias codificantes de proteínas no redundantes almacenadas en la base de datos del NCBI ([nr.gz](https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/)) (2023-07-28 6:02) y otra con todas las secuencias codificantes de proteínas de Swiss-Prot ([swissprot.gz](https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/)) (2023-07-27 19:36) para el posterior análisis funcional. Se utilizó DIAMOND (Buchfink *et al*., 2021) tanto para la creación de la base de datos, como para la anotación. Se utilizó la siguiente línea de código para la creación de la base de datos de *non-redundant*

` /home/proyectos/hyzo/compartida/diamond makedb --in nr -d nrdb --taxonnodes nodes.dmp --taxonmap prot.accession2taxid.FULL.gz ` Incluyendo los parámetros de `--taxonnodes` y `--taxonmap` para poder filtrar después la base de datos por artrópodos. Los enlaces a los archivos son: <ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/accession2taxid/prot.accession2taxid.FULL.gz> y el archivo nodes.dmp dentro de (<ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdmp.zip/>)

Se englobaron todas lineas de comando anteriores en el script [Diamond.sh](/Transcriptoma/Diamond.sh) que se mandó al CCC.
.

Se obtuvo [matchesNR.tsv](/Transcriptoma/matchesNR.tsv/) para la anotacion con nr y [matchesSPU.tsv](/Transcriptoma/matchesSPU.tsv/) para la anotación con Swiss-Prot.

De los resultados obtenidos para la anotación con todas las secuencias no redundantes, solo se dejaron las entradas de proteínas que estuvieran caracterizadas, se filtró mediante un script de Python ([api.ipynb](/Transcriptoma/api.ipynb/)) que accedía a la información de cada proteína en la base de datos del NCBI. 

Se compararon las anotaciones frente a otra generada anteriormente por el grupo de investigación [vsInsectae.csv](/Transcriptoma/vsInsectae.csv/), para ello se escribió un script de Python ([Comparation.ipynb](/Transcriptoma/Comparation.ipynb/)) que permitía ver para cada cluster que anotación tenía. Además, también proporcionaba una serie de valores como clusters sin anotar o la diferencia en el e-value para cada una de ellas.

### Bibliografía

Bushmanova, E., Antipov, D., Lapidus, A., & Prjibelski, A. D. (2019). RNASPADES: A de novo transcriptome assembler and its application to RNA-Seq data. GigaScience, 8, 9. https://doi.org/10.1093/gigascience/giz100  

Bushmanova, E., Antipov, D., Lapidus, A., Suvorov, V., & Prjibelski, A.D. (2016). rnaQUAST: a quality assessment tool for de novo transcriptome assemblies. Bioinformatics, 32, 14. 2210-2212. https://doi.org/10.1093/bioinformatics/btw218 

Kang, Y. J., Yang, D., Kong, L., Hou, M., Meng, Y., Wei, L., & Gao, G. (2017). CPC2: A fast and accurate coding potential calculator based on sequence intrinsic features. Nucleic Acids Research, 45, 1, 12-16. https://doi.org/10.1093/nar/gkx428  

Langmead, B., Salzberg, S. (2012). Fast gapped-read alignment with Bowtie 2. Nature Methods. 9, 357-359. https://doi.org/10.1038/nmeth.1923 
Nolen, Z. J., Yildirim, B., Irisarri, I., Liu, S., Crego, C. G., Amby, D. B., Mayer, F., Gilbert, M., & Pereira, R. J. (2020). Historical isolation facilitates species radiation by sexual selection: Insights from Chorthippus grasshoppers. Molecular Ecology, 29, 4985–5002. https://doi.org/10.1111/mec.15695    

Prjibelski, A. D., Antipov, D., Meleshko, D., Lapidus, A., & Korobeynikov, A. (2020). Using SPAdes de novo assembler. Current protocols in bioinformatics, 70, 1. https://doi.org/10.1002/cpbi.102 
