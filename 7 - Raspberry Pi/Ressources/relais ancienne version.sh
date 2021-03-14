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
                L12='\n\nsudo gpio -g write 4 1 #mise a HIGH du BCM 4'
                L13='\nsudo sh -c "echo 1 > /sys/class/gpio/gpio4/active_low"' #inversion logique BCM4'
                L14='\nsleep 2 #pause pendant 2 secondes'
                L15='\n\nsudo gpio -g write 17 1 #mise a HIGH du BCM17'
                L16='\nsudo sh -c "echo 1 > /sys/class/gpio/gpio17/active_low"' #inversion logique BCM17'
                L17='\nsudo gpio -g write 18 1 #mise a HIGH du BCM18'
                L18='\nsudo sh -c "echo 1 > /sys/class/gpio/gpio18/active_low"' #inversion logique BCM18'
                L19='\nsudo gpio -g write 27  1 #mise a HIGH du BCM27'
                L20='\nsudo sh -c "echo 1 > /sys/class/gpio/gpio27/active_low"' #inversion logique BCM27'
                L21='\nsudo gpio -g write 22  1 #mise a HIGH du BCM22'
                L22='\nsudo sh -c "echo 1 > /sys/class/gpio/gpio22/active_low"' #inversion logique BCM22'
                L23='\nsudo gpio -g write 23  1 #mise a HIGH du BCM23'
                L24='\nsudo sh -c "echo 1 > /sys/class/gpio/gpio23/active_low"' #inversion logique BCM23'
                L25='\nsudo gpio -g write 24  1 #mise a HIGH du BCM24'
                L26='\nsudo sh -c "echo 1 > /sys/class/gpio/gpio24/active_low"' #inversion logique BCM24'
                L27='\nsudo gpio -g write 25  1 #mise a HIGH du BCM25'
                L28='\nsudo sh -c "echo 1 > /sys/class/gpio/gpio25/active_low"' #inversion logique BCM25'
                L29='\nsudo gpio -g write 5  1 #mise a HIGH du BCM5'
                L30='\nsudo sh -c "echo 1 > /sys/class/gpio/gpio5/active_low"' #inversion logique BCM5'
                L31='\n\nsudo gpio -g write 4 0 #mise a LOW du BCM4'

                sed -i '/'"$L1"'/ c\'"$L2"''"$L3"''"$L4"''"$L5"''"$L6"''"$L7"''"$L8"''"$L9"''"$L10"''"$L11"''"$L12"''"$L13"''"$L14"''"$L15"''"$L16"''"$L17"''"$L18"''"$L19"''"$L20"''"$L21"''"$L22"''"$L23"''"$L24"''"$L25"''"$L26"''"$L27"''"$L28"''"$L29"''"$L30"''"$L31"'' /etc/rc.local

        fi


