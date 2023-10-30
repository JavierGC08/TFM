## TRANSCRIPTOMA

### Obtención de datos

Las secuencias en bruto (fastq) se obtuvieron del SRA de NCBI del trabajo realizo por Nolen et al.(2020). Dado que las secuencias superaban los 5 gigabytes, se utilizó el software SRAtoolkit 3.0.5 (NCBI) para descargarlas. Se escribió la siguiente linea de código en la terminal:

` prefetch accesionnumber ` Con el accesion number determinado.

` fasterq-dump accesionnumber ` 

Además, se comprobó que los fastq, al tratarse de una secuenciación pair end, ambas copias tuvieran el mismo número de secuencias. Para ello se utilizó : ` wc -l file | awk "{print $1/4 }" `

### Análisis de calidad

Para el análisis de calidad se utilizó FASTQC 0.12.0,` fastqc file.fastq -o /directorio `. Puesto que el resultado general era satisfactorio ([FASTQC](/Transcriptoma/FASTQC/)), en el siguiente paso de trimming usando TRIMMOMATIC 0.32, se utilizarón los parametros por defecto ` LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:80`  con la versión ` PE `, ya que se trata de archivos *paired end* y  con el archivo adaptadores.fas(cuando lo tenga ponerlo) para eliminar las secuencias sobrerrepresentadas:

`trimmomatic PE -phred33 forward.fastq reverse.fastq forwardpaired.fastq forwardunpaired.fastq reversepaired.fastq reverseunpaired.fastq ILLUMINACLIP:ficheroadaptadores.fas LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:80
`

Cabe destacar que en el FASTQC se detectaron ciertas secuencias sobrerrepresentadas que fueron identificadas como no hit, lo que implica que esta secuencia no esta reconocida por la lista de posibles contaminantes que tiene el programa. Por ello, se realizó una búsqueda con esta secuencia para comprobar si provenía de algún primer o adaptador no identificado, pero no era así. Por otro lado, como podía tratarse de una contaminación por Wolbachia, se realizó un blast con la secuencia, encontrando como hit el genoma mitocondrial de especies muy relacionadas con *Chorthippus*, por ello se decidió no eliminarlas. Se volvió a realizar un análisis de calidad con FASTQC para comprobar que el trimming había mejorado la calidad de las secuencias. 

### Ensamblado

Dado que no existe un transcriptoma de referencia que se pueda utilizar durante el ensamblado, se realizó un ensamblado de novo del transcriptoma utilizando SPAdes (Prjibelski et al., 2020). Para ello, se utilizaron los servidores del Centro de Computación Científica (CCC) de la UAM, mandando el script ([scriptspades.sh](/Transcriptoma/scriptspades.sh/)) y los datos al servidor. Se utilizó la versión para RNA-seq de Spades, RNA-SPAdes 3.15.5 (Bushmanova et al., 2019) y no se modificaron lo parámetros de k-mer size de SPAdes, ya que el propio programa no recomienda modificarlo. 

#### Calidad del ensmablado

Se obtuvieron tres ensamblados distintos dependiendo del grado de filtrado, *hard_filtered*, *soft_filtered* y *transcripts*. Para comprobar la calidad de los tres ensamblados se utilizó la versión para RNA de Quast llamada rnaQUAST 2.2 `python rnaQUAST.py -c ~/TFM/Assembly_1/output/*.fasta -o ~/TFM/Assembly_1/rnaquast
` 

Se escogió el ensamblado de transcripts para los siguientes pasos dado que los tres presentaban valores de calidad muy similares. Se analizó la calidad de este ensamblado de forma independiente utilizando BUSCO 5.4.7 (Manni et al., 2021) , que permite analizar cuáles de los core-genes que debería presentar nuestro ensamblado se encuentran en el mismo. Uno de los inputs que requiere el programa es una base datos con la que comparar, se escogió la base de datos de artrópodos, ya que es menor nivel taxonómico en el que se incluye Orthoptera de todos los presentes en las bases de datos de BUSCO. Se utilizó el parámetro `m` para especificar que se estaba tratando con datos de RNAseq: 

`busco -m transcriptome -i transcripts.fasta -o buscoutput -l artrhopoda `


Por último, se realizó un alineamiento de las secuencias en bruto frente al ensamblado realizado, para ello se  mando el script [bowtiescript.sh](/Transcriptoma/bowtiescript.sh/) utilizando Bowtie2 2.5.2 (Langmead et al., 2012) a los servidores del CCC.

### Bibliografía

Bushmanova, E., Antipov, D., Lapidus, A., & Prjibelski, A. D. (2019). RNASPADES: A de novo transcriptome assembler and its application to RNA-Seq data. GigaScience, 8(9). https://doi.org/10.1093/gigascience/giz100

Bushmanova, E., Antipov, D., Lapidus, A., Suvorov, V. and Prjibelski, A.D., 2016. rnaQUAST: a quality assessment tool for de novo transcriptome assemblies. Bioinformatics, 32(14), pp.2210-2212.

Langmead B, Salzberg S. Fast gapped-read alignment with Bowtie 2. Nature Methods. 2012, 9:357-359.

Nolen, Z. J., Yildirim, B., Irisarri, I., Liu, S., Groot Crego, C., Amby, D. B., Mayer, F., Gilbert, M., & Pereira, R. J. (2020). Historical isolation facilitates species radiation by sexual selection: Insights from Chorthippus grasshoppers. Molecular Ecology, 29, 4985–5002. https://doi.org/10.1111/mec.15695  

Prjibelski, A. D., Antipov, D., Meleshko, D., Lapidus, A., & Korobeynikov, A. (2020). Using SPAdes de novo assembler. Current protocols in bioinformatics, 70(1). https://doi.org/10.1002/cpbi.102
