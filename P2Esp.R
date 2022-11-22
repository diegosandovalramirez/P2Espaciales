# Basado en 08_autocorrelacion_espacial.R y 10_inferencia_espacial.R 
# en Geospatial de github.com/raimun2

pacman::p_load(rgdal, rgeos, stars, spatstat, spdep, sf, raster,
               spatialreg, tidyverse, gstat, MASS)


#################################################################
# Genere un raster interpolando la variable ESCOLARIDAD del censo
#################################################################
iq_cen17 <- readRDS("iquique/mz_censo17_iquique.rds") %>%
  st_as_sf() %>%
  drop_na() %>%
  st_transform("+proj=utm +zone=19 +south +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")

# *************************
# Ponderacion por distancia ----
# *************************

gs <- gstat(formula = iq_cen17$JH_ESC_P~1, locations = iq_cen17)

rast <- raster(iq_cen17, res=30)

idw <- interpolate(rast, gs)

plot(idw, col = viridis::viridis(100), main='Interpolacion de Escolaridad')


########################################################################
# Genere un raster con kernel de densidad de la variable MtOfCom del SII
########################################################################



#############################################################
# Impute los datos de ambos raster a los puntos de tasaciones 
#############################################################


##############################################################
# Genere un modelo OLS para estimar el precio de las viviendas 
# a partir de las otras variables disponibles
##############################################################



############################################
# Ejecute los diagnósticos de error espacial 
############################################



###############################################################
# Genere una matriz de vecinos mas cercanos para las tasaciones 
###############################################################



################################################################################
# Genere el modelo de regresión espacial correspondiente al diagnóstico obtenido
################################################################################



################################################################################
# Responda: ¿Qué variable del entorno tiene más impacto en el valor de viviendas?
################################################################################


