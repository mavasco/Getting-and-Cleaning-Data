# Proyect for Getting-and-Cleaning-Data

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example  this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

 You should create one R script called run_analysis.R that does the following.
 
  1. Merges the training and the test sets to create one data set.

  2. Extracts only the measurements on the mean and standard deviation for each measurement.
 
  3. Uses descriptive activity names to name the activities in the data set

  4. Appropriately labels the data set with descriptive variable names. 

  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!


# Explicaci�n del proceso

  1. Descargamos el archivo getdata_projectfiles_UCI HAR Dataset.zip de la direcci�n https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
 
  2. Descomprimimos este archivo y obtendremos otros cuatro archivos y dos carpetas que colocaremos en nuestro working directory.

  3. Cargamos en memoria el paquete "data.table" con library(data.table). Los data frames que vamos creando los transformaremos en data tables. Se gana en velocidad de c�mputo y en presentaci�n.

  4. Leemos los archivos "subject_train.txt" y "subject_test.txt" relacionados con "subject" y que tienen el mismo n�mero de columnas. Juntamos sus filas con rbind() y tendremos los datos en el data table "dtSubject". Leemos tambi�n los archivos "Y_train.txt" y "Y_test.txt" relacionados con las actividades y juntaremos sus filas en el data table "dtActivity". An�logamente con los archivos "X_train.txt" y "X_test.txt" de datos cuyas filas uniremos en el data table "dt".

  5. Ponemos nombres adecuados a las columnas de estos tres data tables: a la �nica columna del data table dtSubject le llamaremos "subject". A la �nica columna del data table dtActivity  le llamamos "activityNum". Dejamos los nombres de las variables "V1",..., "V561" en el data table dt.

  6. Mezclamos ahora las columnas de los tres data table anteriores con dt <- cbind(dtSubject, dtActivity,dt) con lo que tendremos un �nico data table dt. Para ordenarlo pondremos la llave setkey(dt, subject, activityNum). Con esto acabamos la primera parte del proyecto.

  7. Leemos el archivo features.txt que contiene las variables en dt, mediciones para la media y la desviaci�n st�ndar. Ponemos a sus columnas los nombres "featureNum" y "featureName"

  8. Extraemos el subconjunto en los que aparece  mean() o std() en la variable "featureName". Esto se hace con ayuda de lo estudiado en la semana 4 mediante la linea de c�digo dtFeatures <- dtFeatures[grepl("mean\\(\\)|std\\(\\)", featureName)]. Es importante resaltar que se debe escribir "\\(\\)" para que los s�mbolos de par�ntesis abierto ("(") y cerrado (")") sean interpretados como tales y no com metacaracteres.

  9. A�adimos una nueva columna dtFeatures$featureCode que contiene los nombres de las varables (los n�meros de la columna featureNum precedidos por una v) para poder utilizarlas en el c�digo; esto lo hace la l�nea dtFeatures$featureCode <- dtFeatures[, paste0("V", featureNum)]. A continuaci�n extraemos el subconjunto de las variables en cuesti�n ayud�ndonos del comando select.

  10. Leemos el archivo activity_labels.txt que nos servir� para poner nombres descriptivos a las actividades. Ponemos a las columnas del data table correspondiente los nombres "activityNum" y "activityName".

  11. Hacemos un merge con las etiquetas: dt <- merge(dt, dtActivityNames, by="activityNum", all.x=TRUE) y a�adimos activityName como llave. A continuaci�n hacemos un melt y un merge para poder dar al data.table una nueva forma m�s estrecha y alta.

  12. Creamos el conjunto de datos ordenado dtTidy
