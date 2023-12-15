## CLINAS

### Conversión de los datos

Los resultados del análisis de clinas estaban organizados por el SNP. Cada uno de ellos ([Snps_names](/Clinas/snp_names/)) procede una región concreta que se amplificó para su análisis la cual forma parte de un *cluster* ([grasshopperRef.positions](/Clinas/grasshopperRef.positions/)), que son los que fueron anotados en el apartado de [TRANSCRIPTOMA](/Transcriptoma/). Se utilizó el script [References.ipynb](/Clinas/References.ipynb/) para obtener la relación.

### Anotación de las clinas

Los SNPs se estudiaron en los dos transectos, en cada uno de ellos se analizaba la desviación de la clina asociada respecto a lo esperado en un caso neutro para las dos variables analizadas, pendiente y centro, identificándose como True o False dependiendo de si dicha desviación era significativa. De esta forma, para las anotaciones realizadas, por ejemplo para toda la base de *non redundant*, mediante el script [Clines-NRU](/Clinas/Clines-NRU.ipynb/) se filtraron los resultados quedándose con aquellas clinas que tuvieran al menos una variable significativa en uno de los transectos y estuviera anotada. Por último, se agruparon los SNPs mediante el script [GO-SPU](/Clinas/GO-SPU.ipynb/) según el número de variables significativas por transecto, agrupándose en: significativo para al menos una variable en alguno de los transectos (True), significativo en los dos transectos para las dos variables (CTTPTT), significativo en los dos transectos para la variable centro (CTT) pudiendo ser significativa o no la pendiente, significativo en los dos transectos para la variable pendiente (PTT) pudiendo ser significativo  o no el centro, significativo para la variable centro en uno de los transectos además de significativo para la variable pendiente en ese mismo transecto (CTFPTF) y significativo para la variable centro en el otro transecto además de significativo para la variable pendiente en ese mismo transecto (CFTPFT). 

### Análisis funcional

Para todos los grupos menos CTTPTT, PTT y CTFPTF se realizaron dos análisis de enriquecimiento funcional utilizando la versión web de DAVID (Huang et al.,2008; Sherman et al.,2022), uno usando de background todos los clusters anotados y otro usando como background todas las clinas anotadas, significativas o no. Para ello se utilizó el script anterior [GO-SPU](/Clinas/GO-SPU.ipynb/), para obtener la lista de genes a introducir en DAVID, así como el background. CTTPTT, al ser un número reducido de *clusters*, se agrupó y comprobó manualmente desde el archivo csv generado.

### Bibliografía

Huang, D. W., Sherman, B. T., & Lempicki, R. A. (2008). Systematic and integrative analysis of large gene lists using DAVID Bioinformatics resources. Nature Protocols, 4, 1, 44-57. https://doi.org/10.1038/nprot.2008.211 

Sherman, B. T., Ming, H., Qiu, J., Jiao, X., Baseler, M., Lane, H. C., Imamichi, T., & Chang, W. (2022). DAVID: A web server for functional enrichment analysis and functional annotation of gene lists. Nucleic Acids Research, 50, 1, 216-221. https://doi.org/10.1093/nar/gkac194 
