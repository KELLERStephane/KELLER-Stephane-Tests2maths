#!/bin/bash

### ===============================================================
### Script d'installation du Raspberry et des logiciels tiers
### Stéphane KELLER – Lycée Agricole Louis Pasteur
###José De Castro
### ===============================================================

### ===============================================================
### Définition des couleurs
### ===============================================================

noir='\e[0;30m'
gris='\e[1;30m'
rougefonce='\e[0;31m'
rougeclair='\e[;31m'
rose='\e[1;31m'
vertfonce='\e[0;32m'
vertclair='\e[1;32m'
jaunefonce='\e[0;33m'
jauneclair='\e[1;33m'
bleufonce='\e[0;34m'
bleuclair='\e[1;34m'
violetfonce='\e[0;35m'
violetclair='\e[1;35m'
cyanfonce='\e[0;36m'
cyanclair='\e[1;36m'
grisclair='\e[0;37m'
blanc='\e[1;37m'
blancclignotant='\e[5;37m'
neutre='\e[0;m'

### ===============================================================
### Copyright
### ===============================================================

echo -e "${jauneclair}\nScript d'installation automatique de Webmin, Motioneye, Apache2, fail2ban et Fail2map pour le Raspberry"
echo -e "Script réalisé par KELLER Stéphane - Lycée Agricole Louis Pasteur"
echo -e "et José De Castro "
echo -e "https://github.com/KELLERStephane/KELLER-Stephane-Tests2maths ${neutre}"

### ===============================================================
### Test si l'utilisateur courant a les droits administrateur
### ===============================================================

utilisateur=$(whoami)
if [[ $utilisateur != "root" ]]; then
    echo -e -n "${jauneclair} Cher $utilisateur, vous n etes pas 'root'; merci de relancer cette commande precedee de 'SUDO'. \n ${neutre}"
    exit
else
    clear
fi

### ===============================================================
### Choix des options d'installation
### ===============================================================

CHOIX=$(whiptail --title "Menu d'installation du Raspberry" --checklist \
"\nScript réalisé par :\n- KELLER Stéphane (Lycée Agricole Louis Pasteur)\n- José De Castro\n\n	Que soutaitez-vous installer ?" 19 72 9 \
"MAJ" "Mise a jour du systeme " OFF \
"Paquets" "Paquets utiles pour une première installation " OFF \
"Webmin" "Administration du système en mode WEB " OFF \
"Motioneye" "Logiciel de vidéosurveillance " OFF \
"Apache2" "Serveur web Apache2 " OFF \
"Domoticz" "Logiciel de domotique Domoticz " OFF \
"Fail2ban" "Protection du systeme via auto-bannissement " OFF \
"Fail2map" "Affichage des ip sur une carte " OFF \
"GPIO" "Wiringpi pour l'utilisation des GPIO " OFF 3>&1 1>&2 2>&3)

exitstatus=$?

read

if [[ $exitstatus = 0 ]]; then
    echo -e -n "${jauneclair}  ======================================= \n ${neutre}"
    echo -e -n "${jauneclair} Les logiciels suivants seront installes \n ${neutre}"
    echo -e -n "${jauneclair} $CHOIX \n ${neutre}"
    echo -e -n "${jauneclair} ======================================= \n ${neutre}"

### ===============================================================
### Mise à jour du système
### ===============================================================

    if [[ $CHOIX =~ "MAJ" ]]; then
	echo -e "${bleuclair}\nMise à jour des paquets si nécessaire ${neutre}"
	apt update && apt -y upgrade
    fi

### ===============================================================
### Installation des paquets nécessaires pour une première installation
### ===============================================================

    if [[ $CHOIX =~ "Paquets" ]]; then
	echo -e "${bleuclair}\nInstallation d'Aptitude si nécessaire ${neutre} ${neutre}"
	apt -y install aptitude

	echo -e "${bleuclair}\nInstallation de wget si nécessaire ${neutre}"
	apt -y install wget

	echo -e "${bleuclair}\nInstallation de git si nécessaire ${neutre}"
	apt -y install git

	echo -e "${bleuclair}\nInstallation du gestionnaire et éditeur de fichier mcedit si nécessaire ${neutre}"
	apt -y install mc

	echo -e "${bleuclair}\nInstallation de locate si nécessaire et indexation des fichiers ${neutre}"
	apt -y install locate && updatedb

	echo -e "${bleuclair}\nInstallation du protocole de synchronisation de l'heure si nécessaire ${neutre}"
	aptitude install ntp -y
	/etc/init.d/ntp start
	if [ -e /etc/ntp.com ]
		then
			echo -e "${cyanclair}\nLe fichier /etc/ntp.com existe déja ${neutre}"
			echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
			rm /etc/ntp.com
		fi
	echo -e "${vertclair}Création du fichier /etc/ntp.com ${neutre}"
	echo "server 0.fr.pool.ntp.org" | sudo tee -a /etc/ntp.com

	echo -e "${bleuclair}\nInstallation de python3 si nécessaire ${neutre$"
	apt install python3

	echo -e "${bleuclair}\nInstallation de pip pour python3 si nécessaire ${neutre$"
	apt install python3-pip
    fi

### ===============================================================
### Installation de Webmin
### ===============================================================

  if [[ $CHOIX =~ "Webmin" ]]; then
        ### Installation de l interface WEB du gestionnaire systeme si necessaire
	echo -e -n "${bleuclair}\nInstallation/MAJ de la derniere version de WEBMIN...\n ${neutre}"
	### installer les dépendances
	aptitude -y install libnet-ssleay-perl openssl libauthen-pam-perl libio-pty-perl apt-show-versions python
	### telecharger la derniere version de Webmin
	wget -q --show-progress http://www.webmin.com/download/deb/webmin-current.deb --no-check-certificate
	### installer le paquet puis le supprimer
	dpkg --install webmin-current.deb && rm -f webmin-current.deb
    fi

### ===============================================================
### Installation de Motioneye
### ===============================================================

  if [[ $CHOIX =~ "Webmin" ]]; then
	echo -e "${bleuclair}\nInstallation de Motioneye avec le module de caméra CSI OV5647 pour le Rapsberry Pi ${neutre}" 
	echo -e "${rougeclair}\nNe pas oublier d'activer la caméra avec sudo raspi-config ${neutre}"

        if [ -d "/etc/motioneye" ]
	then
                echo -e "${cyanclair}Le répertoire d'installation /etc/motioneye existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}"
                rm -r /etc/motioneye
        fi

        if [ -d "/var/lib/motioneye" ]
	then
                echo -e "${cyanclair}Le répertoire média /var/lib/motioneye existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}"
                rm -r /var/lib/motioneye
        fi

	echo -e "${vertclair}\nInstallation du module bcm2835-v4l2 pour la caméra CSI OV5647 ${neutre}"
	if grep -q "bcm2835-v4l2" "/etc/modules"
	then
                echo -e "${cyanclair}Le module bcm2835-v4l2 est déja déclaré dans /etc/modules ${neutre}"
	else
 		echo "Déclaration du module bcm2835-v4l2 dans /etc/modules" | sudo tee -a /etc/modules
	fi

        echo -e "${vertclair}\nDésactivation de la led de la caméra CSI OV5647 pour le Rapsberry Pi ${neutre}"
	if grep -q "disable_camera_led=1" "/boot/config.txt"
	then
                echo -e "${cyanclair}La désactivation de la led de la caméra est déja active dans /boot/config.txt ${neutre}"
        else
        	echo "disable_camera_led=1" | sudo tee -a /boot/config.txt
        fi

	echo -e "${vertclair}\nMise à jour des paquets dépendants si nécessaire ${neutre}"
        apt -y install python-dev libssl-dev libcurl4-openssl-dev libjpeg-dev libz-dev
        apt -y install ffmpeg libmariadb3 libpq5 libmicrohttpd12

        echo -e "${vertclair}\ntéléchargement de Motioneye ${neutre}"
	if [ -e /home/pi/pi_buster* ]
	then
		echo -e "${cyanclair}\nLe fichier de téléchargement pour Motioneye existe déja ${neutre}"
		echo -e "${cyanclair}Effacement du fichier puis téléchargement du nouveau fichier ${neutre}"
		rm /home/pi/pi_buster*
	fi
        wget https://github.com/Motion-Project/motion/releases/download/release-4.2.2/pi_buster_motion_4.2.2-1_armhf.deb
        echo -e "${vertclair}\nInstallation de Motioneye ${neutre}"
        dpkg -i pi_buster_motion_4.2.2-1_armhf.deb && rm -f pi_buster_motion_4.2.2-1_armhf.deb
        pip install motioneye

        mkdir -p /etc/motioneye
        cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf

        mkdir -p /var/lib/motioneye
        cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
        systemctl daemon-reload
        systemctl enable motioneye
        systemctl start motioneye
    fi

### ===============================================================
### Installation d'Apache
### ===============================================================

   if [[ $CHOIX =~ "Apache2" ]]; then
        echo -e "${bleuclair}\nInstallation d'Apache ${neutre}"

#        if [ -d "/etc/apache2" ]
#        then
#                echo -e "${cyanclair}Le répertoire d'installation d'Apache2 /etc/apache2 existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}"
#                rm -r /etc/apache2
#        fi
        aptitude install apache2 -y

	echo -e "${vertclair}suppression si nécessaire de la page par défaut d'Apache2 ${neutre}"
	if [ -f "/var/www/html/index.html" ]
	then
		rm /var/www/html/index.html
	fi

	boucle=true
	while "$boucle";do
        	echo -e "${vertclair}\nSécuristion d'Apache2. ${neutre}"
	        if [ -d "/var/www/passwd" ]
	        then
        	        echo -e "${cyanclair}Le répertoire de mots de passe /var/www/passwd existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}"
                	rm -r /var/www/passwd
	        fi
	        echo -e "${vertclair}\nCréation du répertoire de mot de passe sécurisé /var/wwww/passwd ${neutre}"
	        cd /var/www/
	        mkdir passwd
	        echo -e -n "${vertclair}\nSaisir le nom de l'utilisateur principal pour Apache2 : ${neutre}"
	        read username
	        htpasswd -c /var/www/passwd/passwords "$username"
		erreur=$?
#		echo -e "L'erreur est $erreur"
		if [ "$erreur" = 0 ]
		then
			boucle=false
		else
			echo -e "${rougeclair}Erreur. Recommencer ${neutre}"
		fi
	done

        echo -e "${vertclair}\nModification du fichier /etc/apache2/apache2.conf pour sécuriser l'accès à Apache2 ${neutre}"
        if grep -q "AuthName \"ACCES PROTEGE\"" "/etc/modules"
        then
                echo -e "${cyanclair}Le fichier /etc/apache2/apache2.conf a déjà été modifiéa ${neutre}"
		echo -e "${cyanclair}Poursuite de l'installation ${neutre}"
        else
                echo -e "${vertclair}Sauvegarde du fichier /etc/apache2/apache2.conf dans /etc/apache2/apach2.copy ${neutre}"
                cp /etc/apache2/apache2.conf /etc/apache2/apache2.copy
                L1='#<\/Directory>'
                L2='\n\<Directory /var/www/html>'
                L3='\n\tAuthType Basic'
                L4='\n\tAuthName "ACCES PROTEGE"'
                L5='\n\t# (Following line optional)'
                L6='\n\tAuthBasicProvider file'
                L7='\n\tAuthUserFile "/var/www/passwd/passwords"'
                L8='\n\tRequire valid-user'
                L9='\n\t# tri horaire décroissant'
                L10='\n\tIndexOrderDefault Descending Date'
                L11='\n</Directory>'
                sudo sed '/'"$L1"'/ a\'"$L2"''"$L3"''"$L4"''"$L5"''"$L6"''"$L7"''"$L8"''"$L9"''"$L10"''"$L11"'' /etc/apache2/apache2.conf>/home/pi/apache2.conf
                cp /home/pi/apache2.conf /etc/apache2/apache2.conf
        fi

	echo -e "${vertclair}Redémarrage du service Apache2 ${neutre}"
	/etc/init.d/apache2 restart
    fi

### ===============================================================
### Installation de Domoticz
### ===============================================================

   if [[ $CHOIX =~ "Domoticz" ]]; then
        echo -e "${bleuclair}\nInstallation de Domoticz ${neutre}" 
	curl -L install.domoticz.com | bash
    fi

### ===============================================================
### Installation de Fail2ban
### ===============================================================

   if [[ $CHOIX =~ "Fail2ban" ]]; then
        echo -e "${bleuclair}\nInstallation de Fail2ban ${neutre}"

        if [ -d "/etc/fail2ban" ]
        then
                echo -e "${cyanclair}Le répertoire d'installation de Fail2ban /etc/fail2ban existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}"
	        echo -e "${vertclair}/etc/fail2ban/jail.copy -> /etc/fail2ban/jail.conf ${neutre}"
        	echo -e "${vertclair}/etc/fail2ban/fail2ban.copy -> /etc/fail2ban/fail2ban.conf ${neutre}"
     	   	cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.copy
        	cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.copy
        fi
        apt -y install fail2ban
	echo -e "${vertclair}Sauvegarde des fichiers de configuration des prisons de Fail2ban${neutre}"
	echo -e "${vertclair}/etc/fail2ban/jail.conf -> /etc/fail2ban/jail.copy ${neutre}"
	echo -e "${vertclair}/etc/fail2ban/fail2ban.conf -> /etc/fail2ban/fail2ban.copy ${neutre}"
 	cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.copy
	cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.copy

	echo -e "${vertclair}\nInstallation de Postfix si nécessaire pour l'envoi des mails d'alerte ${neutre} ${neutre}"
	apt install postfix

        echo -e "${vertclair}\nTéléchargement du fichier de configuration des prisons (à personnaliser) ${neutre}"
	if [ -e /etc/fail2ban/jail.d/custom.conf ]
	then
		echo -e "${cyanclair}\nLe fichier /etc/fail2ban/jail.d/custom.conf existe déja ${neutre}"
		echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
		rm /etc/fail2ban/jail.d/custom.conf
	fi
	wget -P /etc/fail2ban/jail.d/ https://raw.githubusercontent.com/KELLERStephane/KELLER-Stephane-Tests2maths/master/7%20-%20Raspberry%20Pi/custom.conf
	boucle=true

	while "$boucle";do
	        echo -e "${jauneclair}\nSaisir l'adresse mail pour les messages de Fail2ban : ${neutre}"
	        read repmaila
	        echo -e "${jauneclair}\nResaisir l'adresse mail : ${neutre}"
	        read repmailb
	        if [ "$repmaila" = "$repmailb" ]
	        then
	                echo -e "${rougelclair}Adresse mail correcte ${neutre}"
	                boucle=false
	        else
	                echo -e "${rougeclair}Adresse mail différente. Recommencer"
        	fi
	done

        echo -e "${vertclair}Sauvegarde du fichier de configuration personnalisable de Fail2ban ${neutre}"
        echo -e "${vertclair}/etc/fail2ban/jail.d/custom.conf -> /etc/fail2ban/jail.d/custom.copy ${neutre}"
	cp /etc/fail2ban/jail.d/custom.conf /etc/fail2ban/jail.d/custom.copy
        echo -e "${vertclair}Ajout de l'adresse dans le fichier de configuration personnalisable de Fail2ban ${neutre}"
        L1='destemail='
        L2='\n#destemail='
        L3='\ndestemail='
	sed '/'"$L1"'/ c\'"$L2"''"$L3"''"$repmaila"'' /etc/fail2ban/jail.d/custom.conf >/home/pi/custom.conf
	mv /home/pi/custom.conf /etc/fail2ban/jail.d/custom.conf

	echo -e "${vertclair}Démarrage du service Postfix ${neutre}"
	service postfix reload

        echo -e "${vertclair}\nPour éviter le surplus d'information dans les mails ${neutre}"
        echo -e "${vertclair}Création du fichier /etc/fail2ban/action.d/sendmail-common.local ${neutre}"
        echo -e "[Definition]\naction start =\naction stop =" | sudo tee –a /etc/fail2ban/action.d/sendmail-common.local


	#Téléchargement si nécessaire du script jails.sh
        echo -e "${vertclair}\nTéléchargment si nécessaire du script jails.sh pour l'affichage ${neutre}"
        echo -e "${vertclair}des prisons et du nombre de bannis dans : ${neutre}"

        if [ -d "/home/pi/script" ]
        then
                echo -e "${cyanclair}Le répertoire /home/pi/script existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}"
                rm -r /home/pi/script
        fi

	mkdir /home/pi/script
	wget -P /home/pi/script/ https://raw.githubusercontent.com/KELLERStephane/KELLER-Stephane-Tests2maths/master/7%20-%20Raspberry%20Pi/jails.sh
	chmod +x /home/pi/script/jails.sh
	echo -e "${vertclair}\nCréation d'un raccourci vers le bureau ${neutre}"
	if [ -h "/home/pi/jails.sh" ]
	then
		cd /home/pi
		rm jails.sh
	fi
	ln -s /home/pi/script/jails.sh /home/pi/
	echo -e "${rougelair}Pour la liste des prisons et le nombre de bannis : ${neutre}"
	echo -e "${rougeclair}cd /home/pi ${neutre}"
	echo -e "${rougeclair}sudo ./jails.sh ${neutre}"

	#téléchargement si nécessaire du script banip
        echo -e "${vertclair}\nTéléchargement si nécessaire du script banip.sh ${neutre}"
        echo -e "${vertclair}pour bannir ou débannir une adresse IP : ${neutre}"
        echo -e "${vertclair}/home/pi/script/jails.sh ${neutre}"
  	wget -P /home/pi/script/ https://raw.githubusercontent.com/KELLERStephane/KELLER-Stephane-Tests2maths/master/7%20-%20Raspberry%20Pi/banip.sh
	chmod +x /home/pi/script/banip.sh
        if [ -h "/home/pi/banip.sh" ]
        then
		cd /home/pi
		rm banip.sh
                unlink /home/pi/script/banip.sh
        fi
	echo -e "${vertclair}\nCréation d'un raccourci vers le bureau ${neutre}"
	ln -s /home/pi/script/banip.sh /home/pi/
        echo -e "${rougeclair}Pour bannir ou débannir une adresse IP : ${neutre}"
        echo -e "${rougeclair}cd /home/pi ${neutre}"
        echo -e "${rougeclair}sudo ./banip.sh ${neutre}"

    fi

### ===============================================================
### Installation de Fail2map
### ===============================================================

   if [[ $CHOIX =~ "GLPI" ]]; then
        echo -e "${bleuclair}\nInstallation de Fail2map (nécessite Fail2ban) ${neutre}"

        echo -e "${vertclair}\nTéléchargement de Fail2map ${neutre}"
	if [ -d "/var/www/html/fail2map" ]
	then
		echo -e "${cyanclair}Le répertoire /var/www/html/fail2map existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}"
		rm -r /var/www/html/fail2map
 	fi
        git clone https://github.com/mvonthron/fail2map /var/www/html/fail2map
        echo -e "${vertclair}Modification de la géolocalisation ${neutre}"
        echo -e "${vertclair}Sauvegarde du fichier ${neutre}"

        echo -e "${vertclair}/var/www/html/fail2map/fail2map.py -> /var/www/html/fail2map/fail2map.copy ${neutre}"
        cp /var/www/html/fail2map/fail2map.py /var/www/html/fail2map/fail2map.copy

        echo -e "${vertclair}Modification du fichier /var/www/html/fail2map/fail2map.conf ${neutre}"
        L1='GEOIP_API = "http:\/\/www.telize.com\/geoip\/%s"'
        L2='#GEOIP_API = "http:\/\/www.telize.com\/geoip\/%s"'
        L3='\nGEOIP_API = "http:\/\/ip-api.com\/json\/%s"'
        sed '/'"$L1"'/ c\'"$L2"''"$L3"'' /var/www/html/fail2map/fail2map.py>/home/pi/fail2map.py
        sed -i -e "s/longitude/lon/g" /home/pi/fail2map.py
        sed -i -e "s/latitude/lat/g" /home/pi/fail2map.py
        mv /home/pi/fail2map.py /var/www/html/fail2map/fail2map.py

        echo -e "${vertclair}Modification du fichier /var/www/html/fail2map/fail2map-action.conf ${neutre}"
        cp /var/www/html/fail2map/fail2map-action.conf /var/www/html/fail2map/fail2map-action.copy
        L1='fail2map = *'
        L2='#fail2map = cd **FAIL2MAP PATH** && python fail2map.py'
        L3='\nfail2map = cd /var/www/html/fail2map && python fail2map.py'
        sed '/'"$L1"'/ c\'"$L2"''"$L3"'' /var/www/html/fail2map/fail2map-action.conf>/home/pi/fail2map-action.conf
        mv /home/pi/fail2map-action.conf /var/www/html/fail2map/fail2map-action.conf

        echo -e "${vertclair}Copie du fichier /var/www/html/fail2map/fail2map-action.conf -> /etc/fail2ban/action.d/fail2map-action.conf ${neutre}"
	if [ -e /etc/fail2ban/actions.d/fail2map-action.conf ]
	then
		echo -e "${cyanclair}\nLe fichier /etc/fail2ban/action.d/fail2map-action.conf existe déja ${neutre}"
		echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
		rm /etc/fail2ban/action.d/fail2map-action.conf
	fi
        cp /var/www/html/fail2map/fail2map-action.conf /etc/fail2ban/action.d/fail2map-action.conf

        echo -e "${vertclair}Suppression du fichier d'exemple de localisation /var/www/html/fail2map/places.geojson ${neutre}"
        rm /var/www/html/fail2map/places.geojson

        echo -e "${vertclair}Création d'un fichier vide localisation /var/www/html/fail2map/places.geojson ${neutre}"
        echo "" | sudo tee -a /var/www/html/fail2map/places.geojson
        echo -e "${vertclair}Modification des droits du fichier /var/www/html/fail2map/places.geojson en -rwxr-xr-x ${neutre}"
        chmod 755 /var/www/html/fail2map/places.geojson

        echo -e "${vertclair}Changement de la carte par défaut en modifiant le fichier /var/www/html/fail2map/js/map.js ${neutre}"
        sudo sed '/'"$L1"'/ c\'"$L2"''"$L3"'' /var/www/html/fail2map/js/maps.js >>/home/pi/maps.js
        L1="baseLayer = *"
        L2="//    baseLayer = L.tileLayer.provider('Thunderforest.Landscape', {"
        L3="\n\tbaseLayer = L.tileLayer.provider('Esri.NatGeoWorldMap', {"
        sed '/'"$L1"'/ c\'"$L2"''"$L3"'' /var/www/html/fail2map/js/maps.js >/home/pi/maps.js
        mv /home/pi/maps.js /var/www/html/fail2map/js/maps.js
    fi

### ===============================================================
### GPIO
### ===============================================================

   if [[ $CHOIX =~ "GPIO" ]]; then
        echo -e "${bleuclair}\nInstallation de wiringpi pour l'utilisation des GPIO (nécessite Fail2ban) ${neutre}"
        echo -e "${rougeclair}\nNe pas oublier d'activer les GPIO avec sudo raspi-config ${neutre}"
	cd /tmp
	wget https://project-downloads.drogon.net/wiringpi-latest.deb
	sudo dpkg -i wiringpi-latest.deb
        echo -e "${bleuclair}\nExecuter la commande gpio readall pour voir la configuration des broches ${neutre}"
    fi


### ===============================================================
### Copyright
### ===============================================================

    echo -e "${jauneclair}\nScript d'installation automatique de Webmin, Motioneye, Apache2, fail2ban et Fail2map pour le Raspberry"
    echo -e "Script réalisé par KELLER Stéphane - Lycée Agricole Louis Pasteur"
    echo -e "et José De Castro"
    echo -e "https://github.com/KELLERStephane/KELLER-Stephane-Tests2maths ${neutre}"

### ===============================================================
### Fin de l'installation
### ===============================================================

    echo -e "${blancclignotant}Appuyer une touche pour redémarrer le Raspberry ${neutre}"
    read
    reboot
else
    echo "Annulation des installations."
fi
