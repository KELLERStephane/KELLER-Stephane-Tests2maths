#!/bin/bash
#lancer le script en sudo 
JAILS=$(fail2ban-client status | grep " Jail list:" | sed 's/`- Jail list:\t//g' | sed 's/,//g')
for j in $JAILS
do
echo "$j $(fail2ban-client status $j | grep " Currently banned:" | sed 's/   |- Currently banned:\t//g')"
done

