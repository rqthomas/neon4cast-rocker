#FROM rocker/geospatial:dev-osgeo
FROM rocker/geospatial:latest

## Declares build arguments
#ARG NB_USER
#ARG NB_UID

#COPY --chown=${NB_USER} . ${HOME}

#USER root
RUN apt-get update && apt-get -y install cron
RUN apt-get update && apt-get -y install jags

#USER ${NB_USER}

RUN install2.r devtools remotes
RUN R -e "Sys.setenv("NOT_CRAN" = TRUE); Sys.setenv("LIBARROW_MINIMAL" = FALSE); Sys.setenv("LIBARROW_BINARY" = FALSE); devtools::install_version('arrow', version = '8.0.0')"
RUN R -e "remotes::install_github(c('eco4cast/EFIstandards','cboettig/aws.s3','rqthomas/cronR','eco4cast/score4cast','EcoForecast/ecoforecastR','eco4cast/neon4cast','cboettig/prov', 'eco4cast/read4cast','eco4cast/gefs4cast'))"

RUN install2.r renv rjags neonstore ISOweek RNetCDF fable fabletools forecast imputeTS ncdf4 scoringRules tidybayes tidync udunits2 bench contentid flexdashboard shiny yaml RCurl

COPY cron.sh /etc/services.d/cron/run
