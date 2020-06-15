#!/bin/sh

dnsmasq --test

webproc -p $PORT -m $WP_MAX_LINES -c $DNSMASQ_CONF_DHCP -c $DNSMASQ_CONF_SRV dnsmasq --no-daemon --log-facility=$DNSMASQ_LOG