## Base de datos


Para crear la base de datos se utilizó el software GNFish (Lorente-Martínez et al., 2022), en concreto, el script de Python get_query_sequences, programa para descargar secuencias de nucleótidos de la base de datos del NCBI. Existe un error en el script, ya que, a la hora de crear el directorio de salida, lo generaba dentro de una carpeta antes formada llamada “Data”, pero, a la hora de escribir el path, la llamaba como Data./, lo que impedía que funcionase, es necesario borrar el "." para que el programa funcione. 

