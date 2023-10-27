## Base de datos


Para crear la base de datos se utilizó el software GNFish (Lorente-Martínez et al., 2022), en concreto, el script de Python get_query_sequences, programa para descargar secuencias de nucleótidos de la base de datos del NCBI. Existe un error en el script, ya que, a la hora de crear el directorio de salida, lo generaba dentro de una carpeta antes formada llamada “Data”, pero, a la hora de escribir el path, la llamaba como Data./, lo que impedía que funcionase, es necesario borrar el "." para que el programa funcione. 
El script se llama desde la terminal siguiendo la siguiente estructura:

 ` get_query_sequences.py correoelectronico listagenes --parámetros` 

Entre los parámetros que se utilizarán se encuentran:

` retmax ` Permite limitar el numero máximo de entradas que se recuperan por cada una de las búsquedas.

` nucleotide ` Acotar la búsqueda a nucleótidos.

` curated ` 

` refine ` Para hacer un filtrado por organismo a la hora de buscar los genes en concreto.

Este es el código que se utilzó para la búsqueda:
 
` ./Code/get_query_sequences.py javier.gutierrezcorral@estudiante.uam.es Example/Genes2 --retmax 50 --nucleotide --curated --refine 'AND biomol_mrna[PROP]' ` 
