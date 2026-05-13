---
title: "Investigación de la Influencia de Biomarcadores y Factores Demográficos en Diabetes"
author: "Isabelle Archer, Lucía del Carmen Fito Fito, Iván Navarro Martínez, Ruben
  Saiz López (Grupo B1-08)"
date: "2026-05-13"
output:
    pdf_document: default
---






# Descripción de la BBDD  [1 página máximo]

<!-- Describir la BBDD de la que partimos en esta 2ª entrega, ya que es posible que la hayáis modificado en la 1ª entrega. -->

<!-- Incluir tabla con las variables, su descripción y el tipo de variable (numérica, categórica nominal, categórica ordinal, identificador, fecha, etc.) -->

<!-- Indicar el número de observaciones en la BBDD. -->



Cargamos los datos. Se han registrado 371 observaciones iniciales.

Creamos una tabla descriptiva de las variables presentes en la base de datos, indicando su tipo (numérica o categórica) y una breve descripción de cada una. Esta tabla es fundamental para entender el contexto de cada variable y su posible relevancia y uso en el análisis posterior.


Table: Variables de la base de datos Diabetes_B

|Variable |Tipo               |Descripción                                  |
|:--------|:------------------|:--------------------------------------------|
|pregnant |Numérica           |Número de embarazos                          |
|glucose  |Numérica           |Concentración de glucosa en plasma (mg/dL)   |
|pressure |Numérica           |Presión arterial diastólica (mm Hg)          |
|triceps  |Numérica           |Grosor del pliegue cutáneo del tríceps (mm)  |
|insulin  |Numérica           |Insulina sérica a las 2 horas (mu U/ml)      |
|mass     |Numérica           |Índice de masa corporal (kg/m²)              |
|pedigree |Numérica           |Función de pedigrí de diabetes               |
|age      |Numérica           |Edad (años)                                  |
|diabetes |Categórica nominal |Diagnóstico de diabetes (neg = No, pos = Sí) |
|vegdiet  |Categórica nominal |Dieta vegetariana (yes/no)                   |


# Análisis Clustering  [5 páginas máximo]


## Descripción de los datos utilizados

<!-- Selección de variables a incluir en el modelo? Centrado y escalado? Transformación de variables? -->

El objetivo es encontrar grupos de pacientes con perfiles biomédicos similares. Para ello, utilizaremos en el clustering solo las variables numéricas continuas, excluyendo las variables categóricas *diabetes* y *vegdiet*, que emplearemos posteriormente para relacionarlas con los clústeres obtenidos.

Algunas variables presentan valores iguales a cero que no son fisiológicamente posibles (por ejemplo, glucosa, presión arterial o masa corporal iguales a cero). Estos valores representan datos faltantes y los imputamos mediante la librería *mice*.



Escalamos los datos, dado que las variables están medidas en unidades y magnitudes diferentes y no queremos que esto influya en la agrupación.




## Elección de la medida de distancia y tendencia de agrupamiento

Se utilizará la distancia euclídea, ya que nos interesa agrupar pacientes con valores biomédicos similares (y no simplemente con perfiles relativos similares).

![plot of chunk dist](figs/dist-1.png)

El mapa de color muestra cierta estructura de agrupamiento, aunque no tan pronunciada como en otros conjuntos de datos. Se observan bloques diferenciados que sugieren la existencia de grupos de pacientes con perfiles distintos.

A continuación, calculamos el índice de Hopkins para verificar numéricamente la tendencia de agrupamiento.


```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##  0.6812  0.7048  0.7128  0.7107  0.7179  0.7318
```

El estadístico de Hopkins ha sido calculado para diferentes valores de *m* y con diferentes semillas. Sus valores oscilan entre 0.68 y 0.73, confirmando una tendencia de agrupamiento moderada en los datos.


## Determinación del número de clústeres

### Método jerárquico de Ward

Determinamos el número óptimo de clústeres para el algoritmo jerárquico con el método de Ward combinando el coeficiente de Silhouette y la variabilidad intra-clúster.

![plot of chunk koptJERward](figs/koptJERward-1.png)


```
## grupos1
##   1   2   3 
## 151 160  60
```

![plot of chunk ward](figs/ward-1.png)

### Método jerárquico de la media

![plot of chunk koptJERmedia](figs/koptJERmedia-1.png)


```
## grupos2
##   1   2   3 
## 367   3   1
```

El método de la media genera clústeres muy desequilibrados (un grupo dominante con la mayoría de observaciones), por lo que lo descartamos en favor del método de Ward.


## Comparación de métodos de clustering

<!-- Indicar claramente el método elegido y justificar la decisión. -->

### K-medias

![plot of chunk koptKmeans](figs/koptKmeans-1.png)

![plot of chunk koptKmeansBis](figs/koptKmeansBis-1.png)

```
## *** : The Hubert index is a graphical method of determining the number of clusters.
##                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
##                 significant increase of the value of the measure i.e the significant peak in Hubert
##                 index second differences plot. 
## 
```

![plot of chunk koptKmeansBis](figs/koptKmeansBis-2.png)

```
## *** : The D index is a graphical method of determining the number of clusters. 
##                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
##                 second differences plot) that corresponds to a significant increase of the value of
##                 the measure. 
##  
## ******************************************************************* 
## * Among all indices:                                                
## * 8 proposed 2 as the best number of clusters 
## * 10 proposed 3 as the best number of clusters 
## * 1 proposed 4 as the best number of clusters 
## * 1 proposed 5 as the best number of clusters 
## * 3 proposed 6 as the best number of clusters 
## 
##                    ***** Conclusion *****                            
##  
## * According to the majority rule, the best number of clusters is  3 
##  
##  
## *******************************************************************
```

De los índices visibles en los gráficos de `NbClust`: el estadístico de Hubert (segundas diferencias) apunta a **k=5**, mientras que el D-index (segundas diferencias) apunta a **k=3**. Ambos índices se contradicen, lo que refleja la débil estructura de agrupamiento de estos datos. El resultado final de la votación por mayoría se obtiene del texto de consola y debe consultarse antes de fijar k.

Dado que el criterio de Silhouette —principal referencia del análisis— señala **k=2** como óptimo para K-medias (coeficiente ~0.19, el más alto en todo el rango evaluado), adoptamos k=2 en coherencia con ese criterio.


```
## 
##   1   2 
## 150 221
```

### K-medoides

![plot of chunk koptPam](figs/koptPam-1.png)

El gráfico de Silhouette para K-medoides muestra el máximo en **k=2** (~0.21), superior incluso al de K-medias. Adoptamos k=2 en coherencia con ese criterio, igual que para K-medias.


```
## 
##   1   2 
## 257 114
```

### Selección y validación del método

Comparamos los tres métodos mediante el coeficiente de Silhouette por clúster y por observación. Dado que Ward opera con k=3 y K-medias y K-medoides con k=2, cada método se evalúa en su k óptimo individual, lo que implica que la comparación refleja el mejor rendimiento posible de cada uno.

![plot of chunk silhouette](figs/silhouette-1.png)


```
## 
## Clustering Methods:
##  hierarchical kmeans pam 
## 
## Cluster sizes:
##  2 3 4 5 
## 
## Validation Measures:
##                                   2        3        4        5
##                                                               
## hierarchical APN             0.2220   0.3164   0.4152   0.4541
##              AD              4.2372   4.0609   4.0117   3.9670
##              ADM             0.7394   0.9053   1.1165   1.2563
##              FOM             0.9613   0.9498   0.9385   0.9312
##              Connectivity  103.2143 157.2468 211.5857 270.3925
##              Dunn            0.1086   0.1174   0.1185   0.1185
##              Silhouette      0.1243   0.1275   0.1176   0.0769
## kmeans       APN             0.1107   0.1604   0.2792   0.3200
##              AD              4.0890   3.8963   3.8379   3.7684
##              ADM             0.3831   0.5048   0.8166   0.9469
##              FOM             0.9530   0.9350   0.9105   0.9054
##              Connectivity  122.0722 177.8496 222.8437 289.4357
##              Dunn            0.1040   0.1165   0.1259   0.1204
##              Silhouette      0.1927   0.1743   0.1565   0.1071
## pam          APN             0.1649   0.3292   0.4010   0.4579
##              AD              4.1743   4.0560   3.9893   3.9232
##              ADM             0.5282   1.0158   1.1060   1.2071
##              FOM             0.9536   0.9426   0.9393   0.9257
##              Connectivity  119.7770 211.5476 290.4960 364.3234
##              Dunn            0.1320   0.1047   0.0831   0.0831
##              Silhouette      0.2060   0.1661   0.1095   0.0645
## 
## Optimal Scores:
## 
##              Score    Method       Clusters
## APN            0.1107 kmeans       2       
## AD             3.7684 kmeans       5       
## ADM            0.3831 kmeans       2       
## FOM            0.9054 kmeans       5       
## Connectivity 103.2143 hierarchical 2       
## Dunn           0.1320 pam          2       
## Silhouette     0.2060 pam          2
```

Calculamos también el ARI entre Ward y K-medias para cuantificar su similitud:


```
## [1] 0.265866
```

Cabe destacar que todos los coeficientes de Silhouette globales son inferiores a 0.25, umbral por debajo del cual se considera que la estructura de agrupamiento es débil. Esto es coherente con la ausencia de codos pronunciados en los gráficos WSS y refleja que los datos de diabetes no presentan grupos naturales muy compactos y bien separados. Las conclusiones del clustering deben interpretarse con esta limitación en mente.

A la vista de los resultados de Silhouette y de las métricas internas y de estabilidad, seleccionamos el método **K-medias con 2 clústeres** como el más equilibrado: presenta el mayor coeficiente de Silhouette global entre los métodos de partición y un número de clústeres respaldado directamente por ese criterio.


## Interpretación de los resultados del clustering

### Caracterización de los clústeres obtenidos

Realizamos un PCA para visualizar la separación de los clústeres y entender qué variables contribuyen más a su formación.


```
## Warning: To avoid problems with numeric identifiers, we added r prefix to the identifiers
```

![plot of chunk PCAkmeans](figs/PCAkmeans-1.png)

El número de componentes principales se determina a partir del scree plot anterior, buscando el codo de la curva. Seleccionamos las primeras K componentes que expliquen una proporción suficiente de la varianza total.


Table: Varianza explicada por las PCs seleccionadas

|comp | eigenVal| percVar| cumPercVar|
|:----|--------:|-------:|----------:|
|1    | 2.972970| 27.0270|    27.0270|
|2    | 1.728585| 15.7144|    42.7414|
|3    | 1.253470| 11.3952|    54.1366|

![plot of chunk PCAkmeans2](figs/PCAkmeans2-1.png)

Para complementar el PCA, calculamos el perfil medio de cada clúster sobre las variables originales (sin escalar):


Table: Media de cada variable por clúster

|            |     c1|     c2|
|:-----------|------:|------:|
|pregnant    |   5.09|   2.04|
|glucose     | 144.56| 106.84|
|pressure    |  77.33|  66.34|
|triceps     |  34.56|  25.11|
|insulin     | 221.31| 109.41|
|mass        |  36.79|  30.52|
|pedigree    |   0.59|   0.47|
|age         |  37.51|  25.91|
|cholesterol | 211.45| 200.20|
|leptin      |   8.65|   9.36|
|CRP         |   4.12|   3.14|

![plot of chunk perfiles](figs/perfiles-1.png)


### Relación de los clústeres con otras variables

Analizamos la relación entre los clústeres y las variables categóricas *diabetes* y *vegdiet*, que no fueron utilizadas en el proceso de clustering.


```
##         misclust
## diab_cat         1         2
##      neg 0.3666667 0.8733032
##      pos 0.6333333 0.1266968
```

![plot of chunk rel_diabetes](figs/rel_diabetes-1.png)


```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  table(diab_cat, misclust)
## X-squared = 101.22, df = 1, p-value < 2.2e-16
```


```
##        misclust
## vegdiet         1         2
##     No  0.6866667 0.6832579
##     Yes 0.3133333 0.3167421
```

![plot of chunk rel_vegdiet](figs/rel_vegdiet-1.png)


```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  table(vegdiet, misclust)
## X-squared = 0, df = 1, p-value = 1
```

Los tests chi-cuadrado evalúan si existe asociación significativa entre los clústeres y cada variable categórica. Un p-valor reducido indicaría que la agrupación captura diferencias relevantes en el perfil de los pacientes respecto a esa variable.


# Modelos PLS  [5 páginas máximo]

## Descripción de los datos utilizados y objetivo

<!-- Selección de variables a incluir en el modelo? Centrado y escalado? Transformación de variables? -->

<!-- Indicar si se va a aplicar PLS o PLS-DA y justificarlo. -->


## Optimización del modelo

<!-- Determinación del número de componentes y procedimiento empleado para estimarlo -->


## Validación del modelo


## Interpretación del modelo


## Conclusiones




# Análisis Discriminante  [OPCIONAL. 2 páginas máximo]
