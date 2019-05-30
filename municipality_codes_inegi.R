library('dplyr') 
library('tidyverse') 
library('foreign')

################### Importing data ###################
# Municipalities from ENCEVI 2018
df.munic <- read.dbf("input/ENCEVI_CLVE_ENT_MUN.dbf", FALSE)
# Municipalities codes from INEGI
# Source: https://www.inegi.org.mx/app/ageeml/#
# file can be download also from http://mauricioh2.com/files/
df.agem.codes <- read.dbf("input/AGEEML_20195281547102.dbf", FALSE)

names(df.munic)<-tolower(colnames(df.munic))
names(df.agem.codes)<-tolower(colnames(df.agem.codes))

#Create new column with the state and municipality codes
df.munic <- unite(df.munic, "agem", c("entidad","municipio"), 
                  sep = "", remove = FALSE)
df.agem.codes <- unite(df.agem.codes, "agem", c("cve_ent","cve_mun"), 
                       sep = "", remove = FALSE)
#Keep only the data that is relevant
df.agem.codes <- subset(df.agem.codes, select=c(agem, nom_mun, lat_decimal,
                                                lon_decimal, altitud))

#The values in the file are read as factors. Here, the values are converted to numeric  
df.agem.codes$lat_decimal <- as.numeric(as.character(df.agem.codes$lat_decimal))
df.agem.codes$lon_decimal <- as.numeric(as.character(df.agem.codes$lon_decimal))
df.agem.codes$altitud <- as.numeric(as.character(df.agem.codes$altitud))

df.agem.codes <- df.agem.codes %>%
  group_by(agem, nom_mun) %>%
  summarise_at(vars(lat_decimal, lon_decimal, altitud), funs(mean(., na.rm=TRUE)))

df.munic <- merge(df.munic, df.agem.codes, by="agem", all.x = TRUE)

#Reorder columns
df.munic <- df.munic[c("folio", "agem", "entidad", "municipio", "nom_mun",
                       "lat_decimal", "lon_decimal", "altitud")]

#Write file, with results
write.csv(df.munic, file = "input/INEGI_agem_short.csv", row.names=TRUE, 
          na="")