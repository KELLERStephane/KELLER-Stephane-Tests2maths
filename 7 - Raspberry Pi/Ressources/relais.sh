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
                L3='\n\n/usr/bin/gpio export 12 out #mode OUT pour le pin 32 (BCM 12)'
                L4='\n/usr/bin/gpio export 17 out #mode OUT pour le pin 11 (BCM 17)'
                L5='\n/usr/bin/gpio export 18 out #mode OUT pour le pin 12 (BCM 18)'
                L6='\n/usr/bin/gpio export 27 out #mode OUT pour le pin 13 (BCM 27)'
                L7='\n/usr/bin/gpio export 22 out #mode OUT pour le pin 15 (BCM 22)'
                L8='\n/usr/bin/gpio export 23 out #mode OUT pour le pin 16 (BCM 23)'
                L9='\n/usr/bin/gpio export 24 out #mode OUT pour le pin 18 (BCM 24)'
                L10='\n/usr/bin/gpio export 25 out #mode OUT pour le pin 22 (BCM 25)'
                L11='\n\nsudo gpio -g write 12 1 #mise a HIGH du BCM 12'
                L12='\nsudo sh -c "echo 1 > /sys/class/gpio/gpio12/active_low"' #inversion logique BCM12'
                L13='\nsleep 2 #pause pendant 2 secondes'
                L14='\n\nsudo gpio -g write 17 1 #mise a HIGH du BCM17'
                L15='\nsudo sh -c "echo 1 > /sys/class/gpio/gpio17/active_low"' #inversion logique BCM17'
                L16='\nsudo gpio -g write 18 1 #mise a HIGH du BCM18'
                L17='\nsudo sh -c "echo 1 > /sys/class/gpio/gpio18/active_low"' #inversion logique BCM18'
                L18='\nsudo gpio -g write 27  1 #mise a HIGH du BCM27'
                L19='\nsudo sh -c "echo 1 > /sys/class/gpio/gpio27/active_low"' #inversion logique BCM27'
                L20='\nsudo gpio -g write 22  1 #mise a HIGH du BCM22'
                L21='\nsudo sh -c "echo 1 > /sys/class/gpio/gpio22/active_low"' #inversion logique BCM22'
                L22='\nsudo gpio -g write 23  1 #mise a HIGH du BCM23'
                L23='\nsudo sh -c "echo 1 > /sys/class/gpio/gpio23/active_low"' #inversion logique BCM23'
                L24='\nsudo gpio -g write 24  1 #mise a HIGH du BCM24'
                L25='\nsudo sh -c "echo 1 > /sys/class/gpio/gpio24/active_low"' #inversion logique BCM24'
                L26='\nsudo gpio -g write 25  1 #mise a HIGH du BCM25'
                L27='\nsudo sh -c "echo 1 > /sys/class/gpio/gpio25/active_low"' #inversion logique BCM25'
                L28='\n\nsudo gpio -g write 12 0 #mise a LOW du BCM12'

                sed -i '/'"$L1"'/ c\'"$L2"''"$L3"''"$L4"''"$L5"''"$L6"''"$L7"''"$L8"''"$L9"''"$L10"''"$L11"''"$L12"''"$L13"''"$L14"''"$L15"''"$L16"''"$L17"''"$L18"''"$L19"''"$L20"''"$L21"''"$L22"''"$L23"''"$L24"''"$L25"''"$L26"''"$L27"''"$L28"'' /etc/rc.local

        fi


