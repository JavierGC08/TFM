## BASE DE DATOS


Para crear la base de datos se utilizó el software GNFish (Lorente-Martínez *et al*., 2022), en concreto, el script de Python get_query_sequences, programa para descargar secuencias de nucleótidos de la base de datos del NCBI. Se hicieron ciertas modificaciones en el script, ya que, a la hora de crear el directorio de salida, lo generaba dentro de una carpeta antes formada llamada “Data”, pero, a la hora de escribir el path, la llamaba como Data./, lo que impedía que funcionase, es necesario borrar el "." para que el programa funcione. 
El script se llama desde la terminal siguiendo la siguiente estructura:

` get_query_sequences.py correoelectronico listagenes --parámetros` 

Entre los parámetros que se utilizarán se encuentran:
| PARÁMETRO    | INFORMACIÓN |
| :----------: | :-----------: |
|` retmax `    | Permite limitar el numero máximo de entradas que se recuperan por cada una de las búsquedas.
|` nucleotide `| Acotar la búsqueda a nucleótidos.
|` curated `   | Bases de datos curadas
|` refine `    | Para hacer un filtrado por organismo a la hora de buscar los genes en concreto. |

Este es el código que se utilzó para la búsqueda, utilizando el archivo [Genes2](/Base_de_datos/Genes2/) que contiene los genes de interés:
 
` ./Code/get_query_sequences.py javier.gutierrezcorral@estudiante.uam.es Example/Genes2 --retmax 800 --nucleotide --curated --refine 'AND biomol_mrna[PROP]' ` 

Adicionalmente, se programó un script ([ScriptBusqueda.ipynb](/Base_de_datos/ScriptBusqueda.ipynb/)) para convertir los datos almacenados en archivo [Excel](/Base_de_datos/Posible_genes.csv/), el cual guardaba la información sobre los genes potenciales, estructurado como : Nombre del gen – Siglas – Autores – Estudiado – Grupo – Comentario. De esta forma, se pasó automáticamente al archivo Genes2 con la lista de genes en el formato NombreDelGen ( AND GrupoTaxonómico[Organism]).

### Blast

Sobre el transcriptoma generado por el grupo de investigación [catalog_normal_annotated.fasta](https://dauam-my.sharepoint.com/:u:/g/personal/javier_gutierrezcorral_estudiante_uam_es/EYnemDcVAPJAtACdfhiad5YB_zvmeBhcQCCNiDHHrhErdg?e=esEizo), se realizó un BlastN (Altschul *et al*., 1990) de todas las secuencias obtenidas con GNFish, escribiendo un script en Unix ([merged.sh](/Base_de_datos/merged.sh/)) para juntar todas las secuencias antes generadas en un único archivo [.fasta](/Base_de_datos/merged800.fas/). Primero se creo una base de datos compatible con Blast mediante `makeblastdb` y el fasta recién generado. Con la base de datos y los parámetros básicos del programa se realizó el Blast.

### Procesamiento

El Blast anterior dió como resultado un archivo en el que están todos los *hits* y *no hits*. Por ello, para recuperar solo los *hits* en la base de datos, se utilizó el script [Processer.ipynb](/Base_de_datos/Processer.ipynb/). Además, del archivo con los [hits](/Base_de_datos/processed800names.txt/) se obtuvo una lista con todos los nombres de los [genes](/Base_de_datos/processed800genes.txt/).

### Bibliografía

Altschul, S. F., Gish, W., Miller, W., Myers, E. W., & Lipman, D. J. (1990). Basic Local Alignment Search Tool. Journal of Molecular Biology, 215, 3, 403-410. https://doi.org/10.1016/s0022-2836(05)80360-2 

Lorente-Martínez, H., Agorreta, A., & Mauro, D. S. (2022). Genomic fishing and data processing for molecular evolution research. Methods and Protocols, 5, 2, 26. https://doi.org/10.3390/mps5020026 





