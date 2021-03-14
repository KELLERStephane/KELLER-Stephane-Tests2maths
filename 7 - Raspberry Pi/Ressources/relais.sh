#!/bin/bash
# coding: utf-8

### ===============================================================
### Script d'installation du relais sur Domoticz
### Stéphane KELLER – Lycée Agricole Louis Pasteur
### https://github.com/KELLERStephane/KELLER-Stephane-Tests2maths
### ===============================================================


### ===============================================================
### Test si l'utilisateur courant a les droits administrateur
### ===============================================================

utilisateur=$(whoami)
if [[ $utilisateur != "root" ]]; then
    echo -e -n "${jauneclair} Cher $utilisateur, vous n'êtes pas 'root'; merci de relancer cette commande précédée de 'SUDO'. \n ${neutre}"
    exit
else
    clear
fi

echo -e "${bleuclair}\nModification du fichier /etc/rc.local ${neutre}"

	grep -i "gpio export" "/etc/rc.local" >/dev/null
        if [ $? = 0  ]; then
                echo -e "${cyanclair}Le fichier /etc/rc.local a déjà été modifié ${neutre}"
		echo -e "${cyanclair}Fin de l'installation ${neutre}"
        else
                L1='fi'
		L2='fi'
                L3='\n\n/usr/bin/gpio export 4 out #mode OUT pour le pin 7 (BCM 4)'
                L4='\n/usr/bin/gpio export 17 out #mode OUT pour le pin 11 (BCM 17)'
                L5='\n/usr/bin/gpio export 18 out #mode OUT pour le pin 12 (BCM 18)'
                L6='\n/usr/bin/gpio export 27 out #mode OUT pour le pin 13 (BCM 27)'
                L7='\n/usr/bin/gpio export 22 out #mode OUT pour le pin 15 (BCM 22)'
                L8='\n/usr/bin/gpio export 23 out #mode OUT pour le pin 16 (BCM 23)'
                L9='\n/usr/bin/gpio export 24 out #mode OUT pour le pin 18 (BCM 24)'
                L10='\n/usr/bin/gpio export 25 out #mode OUT pour le pin 22 (BCM 25)'
                L11='\n/usr/bin/gpio export 5 out #mode OUT pour le pin 29 (BCM 5)'
                sed -i '/'"$L1"'/ c\'"$L2"''"$L3"''"$L4"''"$L5"''"$L6"''"$L7"''"$L8"''"$L9"''"$L10"''"$L11"'' /etc/rc.local

        fi


