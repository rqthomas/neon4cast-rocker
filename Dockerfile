FROM rocker/binder

## Declares build arguments
ARG NB_USER
ARG NB_UID

COPY --chown=${NB_USER} . ${HOME}

ENV DEBIAN_FRONTEND=noninteractive
USER root
RUN echo "Checking for 'apt.txt'..." \
        ; if test -f "apt.txt" ; then \
        apt-get update --fix-missing > /dev/null\
        && xargs -a apt.txt apt-get install --yes \
        && apt-get clean > /dev/null \
        && rm -rf /var/lib/apt/lists/* \
        ; fi
        
RUN apt-get update && apt-get -y install cron
RUN apt-get update && apt-get -y install jags

USER ${NB_USER}

## Run an install.R script, if it exists.
RUN if [ -f install.R ]; then R --quiet -f install.R; fi

RUN install2.r renv remotes rjags neonstore ISOweek RNetCDF devtools fable fabletools forecast imputeTS ncdf4 scoringRules tidybayes tidync udunits2

RUN R -e "remotes::install_github(c('eco4cast/EFIstandards','cboettig/aws.s3','rqthomas/cronR','eco4cast/score4cast','EcoForecast/ecoforecastR','eco4cast/neon4cast','cboettig/prov', 'eco4cast/read4cast'))"
RUN R -e "Sys.setenv("LIBARROW_MINIMAL" = FALSE); Sys.setenv("LIBARROW_BINARY" = FALSE); devtools::install_version('arrow', version = '8.0.0')"

COPY cron.sh /etc/services.d/cron/run
