#!/bin/bash

echo "Starting the initialisation process"
set -e

echo "Set-up apcupsd defaults"
#  Set ISCONFIGURED to yes in /etc/default/apcupsd
sed -i -e "s/ISCONFIGURED=no/ISCONFIGURED=yes/g" /etc/default/apcupsd

if [ "$CABLE" = 'USB' ]; then
	echo "Setting-up apcupsd for local USB connection"
	# Configure apcupsd by editing /etc/apcupsd/apcupsd.conf
	sed -i -e "s/#UPSNAME/UPSNAME mainups/g" /etc/apcupsd/apcupsd.conf
	sed -i -e "s/UPSCABLE smart/UPSCABLE usb/g" /etc/apcupsd/apcupsd.conf
	sed -i -e "s/UPSTYPE apcsmart/UPSTYPE usb/g" /etc/apcupsd/apcupsd.conf
	sed -i -e "s_DEVICE /dev/ttyS0_DEVICE_g" /etc/apcupsd/apcupsd.conf
else
	if [ "$CABLE" = 'NET' ]; then
		echo "Setting-up apcupsd for remote connection"
	        # Configure apcupsd by editing /etc/apcupsd/apcupsd.conf
        	sed -i -e "s/#UPSNAME/UPSNAME mainups/g" /etc/apcupsd/apcupsd.conf
        	sed -i -e "s/UPSCABLE smart/UPSCABLE ether/g" /etc/apcupsd/apcupsd.conf
        	sed -i -e "s/UPSTYPE apcsmart/UPSTYPE net/g" /etc/apcupsd/apcupsd.conf
        	sed -i -e s_"DEVICE /dev/ttyS0"_"DEVICE $APCADDR"_g /etc/apcupsd/apcupsd.conf
	fi
fi

# Start apcupsd
echo "Starting apcupsd"
sudo /etc/init.d/apcupsd start

# Start apache
echo "Starting Apache"
exec /usr/sbin/apachectl -DFOREGROUND;

