FROM rocker/geospatial

RUN apt-get update && apt-get -y install cron
RUN apt-get update && apt-get -y install jags

RUN install2.r renv cronR

COPY cron.sh /etc/services.d/cron/run

RUN if [ -f install.R ]; then R --quiet -f install.R; fi
