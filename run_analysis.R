# Comenzamos cargando en memoria el paquete data.table con el que muchas operaciones
# son más rápidas que trabajando directamente con data frasmes
library(data.table)

############## Primera parte ################

# Leemos los archivos con read.table y los pasamos a data.table
# para hacerlos más manejables y ganar en velocidad

# subject files
dtSubjectTrain <- data.table(read.table("./train/subject_train.txt"))
dtSubjectTest <- data.table(read.table("./test/subject_test.txt"))

# activity files 
dtActivityTrain <- data.table(read.table("./train/Y_train.txt"))
dtActivityTest <- data.table(read.table("./test/Y_test.txt"))

# data files
dtTrain <- data.table(read.table("./train/X_train.txt"))
dtTest <- data.table(read.table("./test/X_test.txt"))

# Mezclamos los correspondientes archivos de train y test usando rbind()
dtSubject <- rbind(dtSubjectTrain, dtSubjectTest)
colnames(dtSubject) <- c("subject") # Ponemos nombre adecuado a la variable

dtActivity <- rbind(dtActivityTrain, dtActivityTest)
colnames(dtActivity) <- c("activityNum") # Ponemos nombre adecuado a la variable

dt <- rbind(dtTrain, dtTest) # Dejamos los nombres de las variables "V1",..., "V561"

# Mezclamos las columnas hasta obtener un único data.table

dt <- cbind(dtSubject, dtActivity,dt)

# Establecemos una llave (key) para ordenar el data.table dt

setkey(dt, subject, activityNum)

dt
############## Segunda parte ################

# Leemos el archivo features.txt que contiene las variables en dt, mediciones para 
# la media y la desviación stándar
dtFeatures <- data.table(read.table("./features.txt"))
colnames(dtFeatures) <- c("featureNum", "featureName")

# Extraemos el subconjunto en los que aparece  mean() o std() en la variable "featureName"
dtFeatures <- dtFeatures[grepl("mean\\(\\)|std\\(\\)", featureName)]

# Añadimos una nueva columna dtFeatures$featureCode que contiene los nombres de las varables
# (los números de la columna featureNum precedidos por una v)
dtFeatures$featureCode <- dtFeatures[, paste0("V", featureNum)]

# Extraemos el subconjunto de las variables en cuestión.
select <- c(key(dt), dtFeatures$featureCode)
dt <- dt[, select, with=FALSE]

dt
############## Tercera parte ################

# Leemos el archivo activity_labels.txt que nos servirá para poner nombres descriptivos a las actividades
dtActivityNames<- data.table(read.table("./activity_labels.txt"))
colnames(dtActivityNames) <- c("activityNum", "activityName") # Ponemos nombres adecuados a las variables

dtActivityNames
############## Cuarta parte ################

# Hacemos un merge con las etiquetas.
dt <- merge(dt, dtActivityNames, by="activityNum", all.x=TRUE)

# Añadimos activityName  como llave para ordenar dt.
setkey(dt, subject, activityNum, activityName)

# Hacemos un melt para poder dar al data.table una nueva forma más estrecha y alta.
dt <- data.table(melt(dt, key(dt), variable.name="featureCode"))

# Merge activity name.

dt <- merge(dt, dtFeatures[, list(featureNum, featureCode, featureName)], by="featureCode", all.x=TRUE)
dt

############## Quinta parte ################

# Creamos el conjunto de datos ordenado
dtTidy <- dt[, list(average = mean(value)), by=key(dt)]
dtTidy

# write.table(dtTidy, "tidy.txt",sep="\t\t",row.name=FALSE)
