#fxmartin/rpi-httpd-apcupsd-cgi
Docker image to access apcupsd cgi

just launch with the command
``sudo docker run \
  --privileged \
  --volume /dev/bus/usb:/dev/bus/usb \
  --publish=8081:80 \
  --detach=true \
  --name=apcupsd-cgi \
  --hostname=apcupsd-cgi \
  fxmartin/rpi-httpd-apcupsd```
 
