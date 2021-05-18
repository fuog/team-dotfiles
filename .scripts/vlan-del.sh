#!/bin/bash

echo " "
echo " ==== VLAN Script ===="
ifconfig | grep eth\. | grep -v ether | grep -v avahi |  cut -f1 -d":" | tail -n +2 | grep eth > /dev/null 2>&1
if ! [ "$?" == "0" ]; then
    echo " | Error: No VLAN found !"
    exit 1
fi

echo " | Here we have all the VLANs of ETH0:"
 ifconfig | grep eth\. | grep -v ether | grep -v avahi |  cut -f1 -d":" | tail -n +2 | xargs -L1 echo " |   "

echo " | What VLAN should be removed? :"
while ! [ ifconfig eth.$vlan > /dev/null 2>&1 ]
read -p " |>   Enter Gateway-IP : " vlan


echo ""