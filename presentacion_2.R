### Análisis de precios de viviendas en Iquique ----

####################################################
########## CODIGO DLE KYLE #########################
########## BORRAR ANTES DE ENTREGAR ################
########## SOLO PARA REFERENCIA ####################
####################################################




# Cargar Librerias
pacman::p_load(raster, tidyverse, sf)


# ***************************
# Cargar y ordenar datos ----

# Censo Iquique:
censo_iquique <- readRDS("iquique/mz_censo17_iquique.rds") %>%
 st_as_sf()

# censo_iquique_df <- as.data.frame(censo_iquique) # convert to dataframe



# censo_iquique_df

#SII Iquique:
sii_iquique <- readRDS("iquique/mz_SII_iquique.rds") %>%
 st_as_sf()


#Puntos espaciales de tasaciones Iquique:
tasaciones_iquique <- readRDS("iquique/tasacion_iquique.rds") %>%
 st_as_sf()


# Visualizar:
ggplot() +
  geom_sf(data = censo_iquique) +
  geom_sf(data = tasaciones_iquique)


##########################################################
########## Hasta acá no funciona como los cocos	##########
##########################################################

# *************************
# Ponderacion por distancia ---- 1) here!
# *************************

gs <- gstat(formula = censo_iquique~1, locations = tasaciones_iquique)

rast <- raster(tasaciones_iquique, res = 30)

idw <- interpolate(rast, gs)

plot(idw, col = viridis::viridis(100), main = "Densidad de Delitos KNN")





# *************************
# Kernel density ----			2) here!
# *************************

# Calculo de Hotspots con radios mas y menos extensos de agregacion
# extraigo puntos para la funcion kde2d
pts <- violencia$geometry %>% unlist() %>% matrix(nrow=2) %>% t()

del_hotspots_1 <- kde2d(pts[,1], pts[,2], h = 1500, n = 100)
image(del_hotspots_1, col = viridis::viridis(100), main='Densidad de Delitos Violentos 0.06')


del_hotspots_2 <- kde2d(pts[,1], pts[,2], h = 3000, n = 100)
image(del_hotspots_2, col = viridis::viridis(100), main='Densidad de Delitos Violentos 0.03')
















# ?????????????????????????

iquique_point <- tasaciones_iquique %>%
  st_as_sf() %>%
  st_set_crs("+proj=utm +zone=19 +south +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0") %>% 
  mutate(area = st_area(.) / 10000,
         densidad = poblacion / area,
         violencia = lengths(st_intersects(geometry, violencia)))

# Calcular poblacion por manzana
poblacion <-
  censo_iquique %>%
  group_by(MANZENT_I) %>%
  summarise(poblacion = sum(poblacion))

# ?????????????????????????
