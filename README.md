# fxmartin/rpi-apcupsd-cgi

This image has been designed to allow monitoring an uninterruptible power supplies (UPS). It is built on and for the ARM achitecture (It has been built and tested on a [Raspberry PI3](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/)).

It uses the [APC UPS daemon](http://www.apcupsd.org/) and provides the following features:
- connection to the UPS through the host USB or remotely
- monitoring with [apcupsd Network Monitoring (CGI) Programs](http://www.apcupsd.org/manual/manual.html#apcupsd-network-monitoring-cgi-programs), which run with Apache

The size of this image is 165.5 MB.

Welcome page:
![Screenshot](/images/Screenshot01.jpg)

UPS monitoring page:
![Screenshot](/images/Screenshot02.jpg)

# How to build it ?

Execute the command ```docker build --tag fxmartin/rpi-apcupsd-cgi .```

 This image is based on [resin/rpi-raspbian](https://hub.docker.com/r/resin/rpi-raspbian/). It must therefore be built on an ARM platform.

# How to use it ?

The variable ```CABLE``` allows to define when running the container if the connection to the UPS is via the host USB or remotely via network.

## Connection to the UPS via USB

This will only work if the host is physically connected to the UPS device.

To run it, launch with the below command
```
sudo docker run \
    --privileged \
    --volume /dev/bus/usb:/dev/bus/usb \
    --publish=8081:80 \
    --detach=true \
    --name=apcupsd-cgi \
    --hostname=apcupsd-cgi \
    --env "CABLE=USB" \
    fxmartin/rpi-apcupsd-cgi
```
The --privileged and --volume are mandatory to give access to the host USB port.

## Connection to the UPS remotely

In this case, the UPS node server must also be specified with a --env parameter. See the example below:
```
sudo docker run \
    --publish=8081:80 \
    --detach=true \
    --name=apcupsd-cgi \
    --hostname=apcupsd-cgi \
    --env "CABLE=NET" \
    --env "APCADDR=192.168.50.1:3551" \
    fxmartin/rpi-apcupsd-cgi
```

# How to debug it ?

In case of
