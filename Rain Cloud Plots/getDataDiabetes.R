## Short script to summarize data for the rainclouds tutorial.
## Simulates data drawn from two distribions of similar mean and SD,
## with group A being drawn from a random exponential distribution
## and group B drawn drawn from a random normal distribution.

# Cargar el dataset (modifica la ruta según donde tengas el archivo)
pima <- read.csv("diabetes.csv")  

# Mostrar las primeras filas para revisar
head(pima)

# Filtrar solo las columnas necesarias
pima_clean <- pima %>%
  select(Glucose, Outcome) %>%
  mutate(Outcome = factor(Outcome, labels = c("No Diabético", "Diabético")))