#!/bin/bash

echo " "
echo " ==== VLAN Script ===="

# Check if
ifconfig | grep eth0  > /dev/null 2>&1
if ! [ "$?" == "0" ]; then
    echo " | Error: No eth0 interface found!"
    exit
fi

echo " | found eth0, What VLAN should be added?"
read -p " |>VLAN-ID [1-4094]: " vlanid
# Check input
if [ "$vlanid" -gt "4094" ] || [ "$vlanid" -lt "1" ]; then
    echo " | Error: VLAN-ID needs to be between  1 and 4094 !"
    exit
fi


# Do command and Check result
vconfig add eth0 $vlanid > /dev/null 2>&1
if ! [ "$?" == "0" ]; then
    echo " | Error: vconfig command failed!"
    exit
fi


#
#  s t a t i c 
#

echo " | created VLAN $vlanid, Use DHCP or Static (v4)?"
read -p " |>[S]tatic or [D]HCP ]: " typ
if [ "${typ,,}" == "s" ]; then
    echo " | VLAN $vlanid ready for static configuration"

    while [[ ! $staticip =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\/([12][0-9]|[0-9]|3[012])$ ]]; do
        read -p " |>   Enter IP/subnet : " staticip
        if [[ ! $staticip =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\/([12][0-9]|[0-9]|3[012])$ ]]; then
            echo " |   Wrong format: somthing like 192.168.1.111/24, again"
        fi
    done

    ifconfig eth0.$vlanid $staticip
    echo " | Static IP is set, do you like to change the default gateway to VLAN $vlanid?"

    while  ! [ "${gwqestion,,}" == "n" -o "${gwqestion,,}" == "y" ] ; do
        read -p " |>   [Y]es or [N]o : " gwqestion
        if ! [ "${gwqestion,,}" == "n" -o "${gwqestion,,}" == "y" ] ; then
            echo " | Wrong answer, Y or N .."
        fi
    done

    if [ "${gwqestion,,}" == "n" ]; then
        echo " | script done .."
        echo " "
        exit 0

    elif [ "${gwqestion,,}" == "y" ]; then
        echo " | any other default gateway will be removed "

        while [[ ! $gateway =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; do
            read -p " |>   Enter Gateway-IP : " gateway
                if [[ ! $gateway =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
                    echo " |   Wrong format: somthing like 192.168.1.1, again"
                fi
        done

        # remove all default routes
        true
        while [ "$?" -eq "0" ]; do
            ip route delete default > /dev/null 2>&1
        done

        ip route add default via $gateway dev eth0.$vlanid
        echo " | script done .."
        echo " "
        exit 0
    fi

#
# D y n a m i c
#

elif [ "${typ,,}" == "d" ]; then
    ifconfig eth0.$vlanid up
    echo " | VLAN $vlanid ready for DHCP, Requesting Offer.."
    stop="0"
    while [ "$stop" -ne "1" ]; do
        # Check VLAN Interface
        ifconfig eth0.$vlanid > /dev/null 2>&1
        if ! [ "$?" == "0" ]; then
            echo " | Error: No VLAN 16 interface found!"
            exit
        fi
        timeout 5s dhclient eth0.$vlanid
        if ! [ "$?" == "0" ]; then
            echo " |   Did not get any lease... try agin? "
            read -p " |>  just return or [N]o : " again
            if [ "${again,,}" == "n" ]; then
                stop="1"
                echo " | Script rollback ... "
                vconfig rem eth0.$vlanid > /dev/null 2>&1
                echo " | Note: removing VLAN $vlanid "
                exit 1

            fi
        else
            echo " | Got a Lease!, do you want to keep the default gateway of VLAN $vlanid ?"
            while  ! [ "${dhcpgwqestion,,}" == "n" -o "${dhcpgwqestion,,}" == "y" ] ; do
                read -p " |>   [Y]es or [N]o : " gwqestion
                if ! [ "${dhcpgwqestion,,}" == "n" -o "${dhcpgwqestion,,}" == "y" ] ; then
                    echo " | Wrong answer, Y or N .."
                fi
            done
            if [ "${dhcpgwqestion,,}" == "n" ]; then
                ip route del default dev eth0.16
                echo " | default gateway removed, script done .."
            else
                echo " | script done .."
            fi
            echo " "
            exit 0
        fi
    done



# no selection
else
    echo " | Error: You need to select Static or DHCP with S or D !"
    vconfig rem eth0.$vlanid > /dev/null 2>&1
    echo " | Note: removing VLAN $vlanid "
    exit 1
fi

echo $vlanid




