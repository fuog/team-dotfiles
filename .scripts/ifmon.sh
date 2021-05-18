#!/bin/bash

# TODO:  needs rework...
echo " "
nmcli device
echo " "
echo "== WiFi Build-In =="
ifconfig wlp1s0


ifconfig | grep enx8cae4cf6615e  > /dev/null 2>&1
if [ "$?" == "0" ]; then
echo " "
echo "== Dockingstation =="
  ifconfig | grep enx8cae4cf6615e |  cut -f1 -d":" | xargs -L1 ifconfig
fi


# ifconfig eth0
ifconfig | grep eth | grep -v ether | grep -v avahi  > /dev/null 2>&1
if [ "$?" == "0" ]; then
echo " "
echo "== Ethernet =="
  ifconfig | grep eth | grep -v ether | grep -v avahi |  cut -f1 -d":" | xargs -L1 ifconfig
fi


echo " "
echo "== Routing =="
route -n
echo "== DNS =="
nmcli device show | grep DNS
