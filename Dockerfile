FROM rocker/geospatial:latest

RUN apt-get update && apt-get -y install cron
RUN apt-get update && apt-get -y install jags

RUN install2.r renv remotes rjags neonstore ISOweek RNetCDF devtools fable fabletools forecast imputeTS ncdf4 scoringRules tidybayes tidync udunits2

RUN R -e "Sys.setenv("LIBARROW_MINIMAL" = FALSE); Sys.setenv("LIBARROW_BINARY" = FALSE); devtools::install_version('arrow', version = '8.0.0')"
RUN R -e "remotes::install_github(c('eco4cast/EFIstandards','cboettig/aws.s3','rqthomas/cronR','eco4cast/score4cast','EcoForecast/ecoforecastR','eco4cast/neon4cast','cboettig/prov', 'eco4cast/read4cast'))"

COPY cron.sh /etc/services.d/cron/run