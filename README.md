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

The connection to a UPS is driven by one single configuration file ```/etc/apcupsd/apcupsd.conf```. It is not uncommon to facte connection issues, especially when using the NET mode.

To access the logs of the container, enter the following command: ```docker logs apcupsd-cgi```. You should get a similar output:
```
Starting the initialisation process
Set-up apcupsd defaults
Setting-up apcupsd for remote connection
Starting apcupsd
Starting UPS power management: apcupsd.
Starting Apache
```

Apache logs (access and error logs) aren't automatically streamed to stdout and stderr. To review the logs, you can launch the following command:

```docker exec -i fxmartin/rpi-apcupsd-cgi tail -f /var/log/apache2/access.log -f /var/log/apache2/error.log```

Finally to enter the container while it is running and execute some apcupsd checks, enter the following command: ```docker exec -i -t apcupsd-cgi /bin/bash```.

Once connected and to see the current status of the UPS, enter ```apcaccess```.

Sample output:
```
root@apcupsd-cgi:/# apcaccess
APC      : 001,037,0923
DATE     : 2016-09-02 14:41:02 +0000
HOSTNAME : apcupsd-cgi
VERSION  : 3.14.12 (29 March 2014) debian
UPSNAME  : MAINUPS
CABLE    : Ethernet Link
DRIVER   : NETWORK UPS Driver
UPSMODE  : Stand Alone
STARTTIME: 2016-09-02 13:15:55 +0000
MASTERUPD: 2016-09-02 14:41:02 +0000
MASTER   : 192.168.50.1:3551
MODEL    : Back-UPS XS 950U
STATUS   : ONLINE SLAVE
LINEV    : 228.0 Volts
LOADPCT  : 11.0 Percent
BCHARGE  : 100.0 Percent
TIMELEFT : 55.9 Minutes
MBATTCHG : 5 Percent
MINTIMEL : 3 Minutes
MAXTIME  : 0 Seconds
SENSE    : Medium
LOTRANS  : 155.0 Volts
HITRANS  : 280.0 Volts
BATTV    : 13.4 Volts
LASTXFER : Low line voltage
NUMXFERS : 0
TONBATT  : 0 Seconds
CUMONBATT: 0 Seconds
XOFFBATT : N/A
SELFTEST : NO
STATFLAG : 0x05000408
SERIALNO : 3B1618X24140
BATTDATE : 2016-05-08
NOMINV   : 230 Volts
NOMBATTV : 12.0 Volts
NOMPOWER : 480 Watts
FIRMWARE : 925.T2 .I USB FW:T2
END APC  : 2016-09-02 14:41:28 +0000
```
