FROM resin/rpi-raspbian

MAINTAINER F.-X. Martin mail@fxmartin.me

RUN apt-get update && apt-get install -y apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sudo apt-get -y update && sudo apt-get -y install apcupsd apcupsd-cgi && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./config/apcupsd /etc/default/

COPY ./config/apcupsd.conf /etc/apcupsd/

COPY ./config/entrypoint.sh /

RUN echo 'ServerName apcupsd' >> /etc/apache2/apache2.conf

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

RUN sudo chown -R www-data:www-data /usr/lib/cgi-bin && \
	sudo chmod -R g+rw /usr/lib/cgi-bin && \
	sudo chown -R www-data:www-data /var/www && \
	sudo chmod -R g+rw /var/www && \
	a2enmod cgi

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
