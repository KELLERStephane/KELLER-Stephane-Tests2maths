#!/bin/bash

### ===============================================================
### Script d'installation du Raspberry et des logiciels tiers
### Stéphane KELLER – Lycée Agricole Louis Pasteur
### José De Castro
### echo -e "et José De Castro "
### https://github.com/KELLERStephane/KELLER-Stephane-Tests2maths
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
### Test si l'utilisateur courant a les droits administrateur
### ===============================================================

utilisateur=$(whoami)
if [[ $utilisateur != "root" ]]; then
    echo -e -n "${jauneclair} Cher $utilisateur, vous n'êtes pas 'root'; merci de relancer cette commande précédée de 'SUDO'. \n ${neutre}"
    exit
else
    clear
fi

### ===============================================================
### Choix des options d'installation
### ===============================================================

CHOIX=$(whiptail --title "Menu d'installation du Raspberry" --checklist \
"\nScript réalisé par :\n- KELLER Stéphane (Lycée Agricole Louis Pasteur)\n- José De Castro\nhttps://github.com/KELLERStephane/KELLER-Stephane-Tests2maths\n\nQue soutaitez-vous installer ?" 23 72 8 \
"MAJ" "Mise a jour du systeme " OFF \
"Webmin" "Administration du système en mode WEB " OFF \
"Motioneye" "Logiciel de vidéosurveillance " OFF \
"Apache2" "Serveur web Apache2 " OFF \
"Fail2ban" "Protection du systeme via auto-bannissement " OFF \
"Fail2map" "Affichage des ip sur une carte " OFF \
"Domoticz" "Logiciel de domotique Domoticz " OFF \
"GPIO" "Wiringpi pour l'utilisation des GPIO " OFF \
"DHT22" "Capteur de température DHT22 " OFF 3>&1 1>&2 2>&3)

exitstatus=$?

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
        if [ -e /etc/ntp.com ] ; then
             echo -e "${cyanclair}\nLe fichier /etc/ntp.com existe déja ${neutre}"
             echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
             rm /etc/ntp.com
        fi
        echo -e "${vertclair}Création du fichier /etc/ntp.com ${neutre}"
        echo "server 0.fr.pool.ntp.org" | sudo tee -a /etc/ntp.com

        echo -e "${bleuclair}\nInstallation de python3 si nécessaire ${neutre}"
        apt -y install python3
	echo -e "${vertclair}\nModification da la version par défaut de python en python3 si nécessaire ${neutre}"
	update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
	update-alternatives --install /usr/bin/python python /usr/bin/python3.7 2
	echo -e "${vertclair}\nChoix de la version de Python par défaut : ${neutre}"
        echo -e "${vertclair}\nChoisir Python3 de préférence : ${neutre}"
	echo 1 | sudo update-alternatives --config python
	echo -e "${vertclair}\nLa version de Python par défaut est : ${neutre}"
	python --version

        echo -e "${vertclair}\nInstallation de pip pour python3 si nécessaire ${neutre}"
        apt -y install python3-pip
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

    if [[ $CHOIX =~ "Motioneye" ]]; then
	echo -e "${bleuclair}\nInstallation de Motioneye avec le module de caméra CSI OV5647 pour le Rapsberry Pi ${neutre}" 
	echo -e "${rougeclair}\nNe pas oublier d'activer la caméra avec sudo raspi-config ${neutre}"

        if [ -d "/etc/motioneye" ]; then
                echo -e "${cyanclair}Le répertoire d'installation /etc/motioneye existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}"
                rm -r /etc/motioneye
        fi

        if [ -d "/var/lib/motioneye" ]; then
                echo -e "${cyanclair}Le répertoire média /var/lib/motioneye existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}"
                rm -r /var/lib/motioneye
        fi

	echo -e "${vertclair}\nInstallation du module bcm2835-v4l2 pour la caméra CSI OV5647 ${neutre}"
	if [ grep -q "bcm2835-v4l2" "/etc/modules" ]; then
                echo -e "${cyanclair}Le module bcm2835-v4l2 est déja déclaré dans /etc/modules ${neutre}"
	else
 		echo "Déclaration du module bcm2835-v4l2 dans /etc/modules" | sudo tee -a /etc/modules
	fi

        echo -e "${vertclair}\nDésactivation de la led de la caméra CSI OV5647 pour le Rapsberry Pi ${neutre}"
	if [ grep -q "disable_camera_led=1" "/boot/config.txt" ]; then
                echo -e "${cyanclair}La désactivation de la led de la caméra est déja active dans /boot/config.txt ${neutre}"
        else
        	echo "disable_camera_led=1" | sudo tee -a /boot/config.txt
        fi

	echo -e "${vertclair}\nMise à jour des paquets dépendants si nécessaire ${neutre}"
        apt -y install python-pip python-dev libssl-dev libcurl4-openssl-dev libjpeg-dev libz-dev
        apt -y install ffmpeg libmariadb3 libpq5 libmicrohttpd12

        echo -e "${vertclair}\ntéléchargement de Motioneye ${neutre}"
	if [ -e /home/pi/pi_buster* ]; 	then
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

#        if [ -d "/etc/apache2" ]; then
#                echo -e "${cyanclair}Le répertoire d'installation d'Apache2 /etc/apache2 existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}"
#                rm -r /etc/apache2
#        fi
        apt -y install apache2

	echo -e "${vertclair}suppression si nécessaire de la page par défaut d'Apache2 ${neutre}"
	if [ -f "/var/www/html/index.html" ]; then
		rm /var/www/html/index.html
	fi

	boucle=true
	while $boucle;do
        	echo -e "${vertclair}\nSécuristion d'Apache2. ${neutre}"
	        if [ -d "/var/www/passwd" ]; then
        	        echo -e "${cyanclair}Le répertoire de mots de passe /var/www/passwd existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}"
                	rm -r /var/www/passwd
	        fi
	        echo -e "${vertclair}\nCréation du répertoire de mot de passe sécurisé /var/wwww/passwd ${neutre}"
	        cd /var/www/
	        mkdir passwd
	        echo -e -n "${jauneclair}\nSaisir le nom de l'utilisateur principal pour Apache2 : ${neutre}"
	        read username
	        htpasswd -c /var/www/passwd/passwords "$username"
		erreur=$?
#		echo -e "L'erreur est $erreur"
		if [ "$erreur" = 0 ]; then
			boucle=false
		else
			echo -e "${rougeclair}Erreur. Recommencer ${neutre}"
		fi
	done

        echo -e "${vertclair}\nModification du fichier /etc/apache2/apache2.conf pour sécuriser l'accès à Apache2 ${neutre}"
        if [ grep -q "AuthName \"ACCES PROTEGE\"" "/etc/modules"]; then
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
                L12='\n#</Directory>'
                sed -i '/'"$L1"'/ c\'"$L2"''"$L3"''"$L4"''"$L5"''"$L6"''"$L7"''"$L8"''"$L9"''"$L10"''"$L11"''"$L12"'' /etc/apache2/apache2.conf
        fi

	echo -e "${vertclair}Redémarrage du service Apache2 ${neutre}"
	/etc/init.d/apache2 restart
    fi

### ===============================================================
### Installation de Fail2ban
### ===============================================================

    if [[ $CHOIX =~ "Fail2ban" ]]; then
        echo -e "${bleuclair}\nInstallation de Fail2ban ${neutre}"

        if [ -d "/etc/fail2ban" ]; then
                echo -e "${cyanclair}Le répertoire d'installation de Fail2ban /etc/fail2ban existe déja. ${neutre}"
                echo -e "${cyanclair}Désinstallation du logiciel avant la nouvelle installation  ${neutre}"
		rm -r /etc/fail2ban
 		apt -y --purge remove fail2ban
         fi
        apt -y install fail2ban


	echo -e "${vertclair}Sauvegarde des fichiers de configuration des prisons de Fail2ban${neutre}"
	echo -e "${vertclair}/etc/fail2ban/jail.conf -> /etc/fail2ban/jail.copy ${neutre}"
	echo -e "${vertclair}/etc/fail2ban/fail2ban.conf -> /etc/fail2ban/fail2ban.copy ${neutre}"
 	cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.copy
	cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.copy

        #Téléchargement du fichier personnalisable de configuration des prisons
        echo -e "${vertclair}\nTéléchargement du fichier de configuration des prisons (à personnaliser) ${neutre}"
        if [ -e /etc/fail2ban/jail.d/custom.conf ]; then
                echo -e "${cyanclair}\nLe fichier /etc/fail2ban/jail.d/custom.conf existe déja ${neutre}"
                echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
                rm /etc/fail2ban/jail.d/custom.conf
        fi
        wget -P /etc/fail2ban/jail.d/ https://raw.githubusercontent.com/KELLERStephane/KELLER-Stephane-Tests2maths/master/7%20-%20Raspberry%20Pi/custom.conf
	chown pi:pi /etc/fail2ban/jail.d/custom.conf
	#installation de Postfix pour envoi des mails d'alerte
	echo -e "${vertclair}\nInstallation de Postfix si nécessaire pour l'envoi des mails d'alerte ${neutre} ${neutre}"
	apt install postfix

	#Saisi adresse mail pour envoi des mails d'alerte
        boucle=true
        while $boucle;do
		mail1=$(whiptail --title "Adresse mail" --inputbox "Saisir l'adresse mail pour les messages de Fail2ban : ?" 10 60 3>&1 1>&2 2>&3)
 		exitstatus=$?
		if [ $exitstatus = 0 ]; then
		    	mail2=$(whiptail --title "Mail" --inputbox "Resaisir l'adresse mail : ?" 10 60 3>&1 1>&2 2>&3)
			exitstatus=$?
			if [ "$mail1" = "$mail2" ]; then
				echo -e "${rougelclair}Adresse mail correcte ${neutre}"
				boucle=false
			else
				whiptail --title "Erreur" --msgbox "Adresses mail différente. Recommencer" 8 78
			fi
		else
			echo -e "${rougeclair}Erreur ${neutre}"
		fi
        done

        echo -e "${vertclair}Sauvegarde du fichier de configuration personnalisable de Fail2ban ${neutre}"
        echo -e "${vertclair}/etc/fail2ban/jail.d/custom.conf -> /etc/fail2ban/jail.d/custom.copy ${neutre}"
	cp /etc/fail2ban/jail.d/custom.conf /etc/fail2ban/jail.d/custom.copy
        echo -e "${vertclair}Ajout de l'adresse dans le fichier de configuration personnalisable de Fail2ban ${neutre}"
        L1='destemail='
        L2='#destemail='
        L3='\ndestemail='
        sed -i '/'"$L1"'/ c\'"$L2"''"$L3"''"$repmaila"'' /etc/fail2ban/jail.d/custom.conf

	#Démarrage du service Postfix
	echo -e "${vertclair}Démarrage du service Postfix ${neutre}"
	service postfix reload

	#Modification du fichier sendmail-common.local pour éviter le surplus d'information dans les mails
        echo -e "${vertclair}\nPour éviter le surplus d'information dans les mails ${neutre}"
        echo -e "${vertclair}Création du fichier /etc/fail2ban/action.d/sendmail-common.local ${neutre}"
        echo -e "[Definition]\naction start =\naction stop =" | sudo tee –a /etc/fail2ban/action.d/sendmail-common.local

	#Modification du fichier iptables-multiport.conf pour créer un fichier d'IP banni
        if [ -e /etc/fail2ban/action.d/iptables-multiport.copy ] ; then
             echo -e "${cyanclair}\nLe fichier /etc/fail2ban/action.d/iptables-multiport.copy existe déja ${neutre}"
             echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
             rm /etc/fail2ban/action.d/iptables-multiport.copy
        fi
	cp /etc/fail2ban/action.d/iptables-multiport.conf /etc/fail2ban/action.d/iptables-multiport.copy
        L1='actionban = '
        L2='\nmadate=$(date)'
        L3='\nactionban = <iptables> -I fail2ban-<name> 1 -s <ip> -j <blocktype>'
        L4='\n            if ! grep -Fq <ip> /var/log/ipbannies.log; then echo "fail2ban-<name> <ip> %(madate)s" | sudo tee -a /var/log/ipbannies.log; fi '
        sed -i '/'"$L1"'/ c\'"$L2"''"$L3"''"$L4"'' /etc/fail2ban/action.d/iptables-multiport.conf
        echo -e "${rougeclair}Pour visualiser le fichier d'IP bannies : ${neutre}"
        echo -e "${rougeclair}sudo nano  /var/log/ipbannies.log ${neutre}"

	#Démarrage automatique de Fail2ban
        echo -e "${vertclair}\nDémarrer Fail2ban automatiquement lors du démarrage du système ${neutre}"
	sudo systemctl enable fail2ban

	#Téléchargement si nécessaire du script jails.sh
        echo -e "${vertclair}\nTéléchargment si nécessaire du script jails.sh pour l'affichage ${neutre}"
        echo -e "${vertclair}des prisons et du nombre de bannis dans : ${neutre}"

        if [ -d "/home/pi/script" ]; then
                echo -e "${cyanclair}Le répertoire /home/pi/script existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}"
                rm -r /home/pi/script
        fi

	mkdir /home/pi/script
	wget -P /home/pi/script/ https://raw.githubusercontent.com/KELLERStephane/KELLER-Stephane-Tests2maths/master/7%20-%20Raspberry%20Pi/jails.sh
	chown pi:pi  /home/pi/script/jails.sh
	chmod +x /home/pi/script/jails.sh
	echo -e "${vertclair}\nCréation d'un raccourci vers le bureau ${neutre}"
	if [ -h "/home/pi/jails.sh" ]; 	then
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
	chown pi:pi  /home/pi/script/banip.sh
	chmod +x /home/pi/script/banip.sh
        if [ -h "/home/pi/banip.sh" ]; then
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

    if [[ $CHOIX =~ "Fail2map" ]]; then
        echo -e "${bleuclair}\nInstallation de Fail2map (nécessite Fail2ban) ${neutre}"

        echo -e "${vertclair}\nTéléchargement de Fail2map ${neutre}"
	if [ -d "/var/www/html/fail2map" ]; then
		echo -e "${cyanclair}Le répertoire /var/www/html/fail2map existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}"
		rm -r /var/www/html/fail2map
 	fi
        git clone https://github.com/mvonthron/fail2map /var/www/html/fail2map
        echo -e "${vertclair}Modification de la géolocalisation ${neutre}"
        echo -e "${vertclair}Sauvegarde du fichier ${neutre}"

        echo -e "${vertclair}/var/www/html/fail2map/fail2map.py -> /var/www/html/fail2map/fail2map.copy ${neutre}"
        cp /var/www/html/fail2map/fail2map.py /var/www/html/fail2map/fail2map.copy

	version=$(python --version 2>&1 | cut -c1-8)
	echo -e "${vertclair}\nVersion de Python par défaut : ${neutre}"
	echo -e $version
	if [[ $version =~ "Python 3" ]]; then
	        echo -e "${vertclair}Modification du fichier /var/www/html/fail2map/fail2map.py ${neutre}"
	        L1='import urllib2'
	        L2='#import urllib2'
	        L3='\nimport urllib.request'
	        sed -i '/'"$L1"'/ c\'"$L2"''"$L3"'' /var/www/html/fail2map/fail2map.py
	fi

        L4='GEOIP_API = "http:\/\/www.telize.com\/geoip\/%s"'
        L5='#GEOIP_API = "http:\/\/www.telize.com\/geoip\/%s"'
        L6='\nGEOIP_API = "http:\/\/ip-api.com\/json\/%s"'
        sed -i '/'"$L4"'/ c\'"$L5"''"$L6"'' /var/www/html/fail2map/fail2map.py

        if [[ $version =~ "Python 3" ]]; then
	        L7='    req ='
	        L8='\n    #req = urllib2.urlopen(GEOIP_API % ipaddr)'
	        L9='\n    req = urllib.request.urlopen(GEOIP_API % ipaddr)'
	        sed -i '/'"$L7"'/ c\'"$L8"''"$L9"'' /var/www/html/fail2map/fail2map.py
	fi

        sed -i "s/longitude/lon/g" /var/www/html/fail2map/fail2map.py
        sed -i "s/latitude/lat/g" /var/www/html/fail2map/fail2map.py

	#Modification du fichier fail2map-action.conf pour placer IP sur la carte
        echo -e "${vertclair}Modification du fichier /var/www/html/fail2map/fail2map-action.conf ${neutre}"
        cp /var/www/html/fail2map/fail2map-action.conf /var/www/html/fail2map/fail2map-action.copy
        L1='fail2map = *'
        L2='#fail2map = cd **FAIL2MAP PATH** && python fail2map.py'
        L3='\nfail2map = cd /var/www/html/fail2map && python fail2map.py'
        sed '/'"$L1"'/ c\'"$L2"''"$L3"'' /var/www/html/fail2map/fail2map-action.conf>/home/pi/fail2map-action.conf
        mv /home/pi/fail2map-action.conf /var/www/html/fail2map/fail2map-action.conf

        echo -e "${vertclair}Copie du fichier /var/www/html/fail2map/fail2map-action.conf -> /etc/fail2ban/action.d/fail2map-action.conf ${neutre}"
	if [ -e /etc/fail2ban/actions.d/fail2map-action.conf ]; then
		echo -e "${cyanclair}\nLe fichier /etc/fail2ban/action.d/fail2map-action.conf existe déja ${neutre}"
		echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
		rm /etc/fail2ban/action.d/fail2map-action.conf
	fi
        cp /var/www/html/fail2map/fail2map-action.conf /etc/fail2ban/action.d/fail2map-action.conf

	#Effacement du fichier exemple IP puis création fichier vierge d'IP
        echo -e "${vertclair}Suppression du fichier d'exemple de localisation /var/www/html/fail2map/places.geojson ${neutre}"
        rm /var/www/html/fail2map/places.geojson
        echo -e "${vertclair}Création d'un fichier vide localisation /var/www/html/fail2map/places.geojson ${neutre}"
        echo "" | sudo tee -a /var/www/html/fail2map/places.geojson
        echo -e "${vertclair}Modification des droits du fichier /var/www/html/fail2map/places.geojson en -rwxr-xr-x ${neutre}"
        chmod 755 /var/www/html/fail2map/places.geojson

	#Modification de la carte par défaut pour Fail2map
        echo -e "${vertclair}Changement de la carte par défaut en modifiant le fichier /var/www/html/fail2map/js/map.js ${neutre}"
        sudo sed '/'"$L1"'/ c\'"$L2"''"$L3"'' /var/www/html/fail2map/js/maps.js >>/home/pi/maps.js
        L1="baseLayer = *"
        L2="//    baseLayer = L.tileLayer.provider('Thunderforest.Landscape', {"
        L3="\n\tbaseLayer = L.tileLayer.provider('Esri.NatGeoWorldMap', {"
        sed '/'"$L1"'/ c\'"$L2"''"$L3"'' /var/www/html/fail2map/js/maps.js >/home/pi/maps.js
        mv /home/pi/maps.js /var/www/html/fail2map/js/maps.js
    fi

### ===============================================================
### Installation de Domoticz
### ===============================================================

    if [[ $CHOIX =~ "Domoticz" ]]; then
        echo -e "${bleuclair}\nInstallation de Domoticz ${neutre}"
        curl -L install.domoticz.com | bash
    fi

    echo -e "${vertclair}Création du fichier log /var/log/domoticz.log ${neutre}"
    cp /etc/init.d/domoticz.sh /etc/init.d/domoticz.copy
    L1='#DAEMON_ARGS="$DAEMON_ARGS -log \/tmp\/domoticz.txt'
    L2='#DAEMON_ARGS="$DAEMON_ARGS -log \/tmp\/domoticz.txt'
    L3='\nDAEMON_ARGS="$DAEMON_ARGS -log /var/log/domoticz.log"'
    sed -i '/'"$L1"'/ c\'"$L2"''"$L3"'' /etc/init.d/domoticz.sh

    echo -e "${vertclair}Téléchargement du fichier de configuration Fail2ban ${neutre}"
    echo -e "${vertclair}pour domoticz dans /etc/fail2ban/filter.d/domoticz.conf ${neutre}"
    wget -P /etc/fail2ban/filter.d/ https://raw.githubusercontent.com/KELLERStephane/KELLER-Stephane-Tests2maths/master/7%20-%20Raspberry%20Pi/domoticz.conf
    chown pi:pi /etc/fail2ban/filter.d/domoticz.conf
    if [ -e !/etc/fail2ban/jail.d/custom.conf ] ; then
	echo -e "${cyanclair}\nLe fichier /etc/fail2ban/jail.d/custom.conf n'existe pas ! ${neutre}"
	echo -e "${vertclair}\nTéléchargement du fichier de configuration des prisons (à personnaliser) ${neutre}"
	wget -P /etc/fail2ban/jail.d/ https://raw.githubusercontent.com/KELLERStephane/KELLER-Stephane-Tests2maths/master/7%20-%20Raspberry%20Pi/custom.conf
	chown pi:pi /etc/fail2ban/jail.d/custom.conf
    echo -e "${cyanclair}\nCr&ation de la prison domoticz dans le fichier /etc/fail2ban/jail.d/custom.conf ${neutre}"
    L1='[domoticz]'
    L2='\nenabled  = true'
    L3='\nport = 8080,443'
    L4='\nfilter  = domoticz'
    L5='\nlogpath = /var/log/domoticz.log'
    echo -e $L1 $L2 $L3 $L4 $L5 >>/etc/fail2ban/jail.d/custom.conf
    fi



### ===============================================================
### GPIO
### ===============================================================

    if [[ $CHOIX =~ "GPIO" ]]; then
        echo -e "${bleuclair}\nInstallation de wiringpi pour l'utilisation des GPIO (nécessite Fail2ban) ${neutre}"
        echo -e "${rougeclair}\nNe pas oublier d'activer les GPIO avec sudo raspi-config ${neutre}"
	cd /tmp
	wget https://project-downloads.drogon.net/wiringpi-latest.deb
	sudo dpkg -i wiringpi-latest.deb && rm wiringpi-latest.deb
        echo -e "${rougeclair}\nExecuter la commande gpio readall pour voir la configuration des broches ${neutre}"
    fi

### ===============================================================
### DHT22
### ===============================================================

    if [[ $CHOIX =~ "DHT22" ]]; then
        echo -e "${bleuclair}\nInstallation du capteur DHT22 (nécessite Domoticz) ${neutre}"
        echo -e "${rougeclair}\nNe pas oublier d'activer les GPIO avec sudo raspi-config ${neutre}"
        echo -e "${rougeclair}\Ne pas oublier d'activer I2C avec sudo raspi-config ${neutre}"

        if [ -d "/home/pi/script/Adafruit_Python_DHT" ]; then
                echo -e "${cyanclair}Le répertoire d'installation /home/pi/script/Adafruit_Python_DHT existe déja. Suppression du répertoire avant la nouvelle installation ${neutre}"
                rm -r /home/pi/script/Adafruit_Python_DHT
        fi
        if [ -d "/home/pi/script/Adafruit_Python_SSD1306" ]; then
                echo -e "${cyanclair}Le répertoire d'installation /home/pi/script/Adafruit_Python_SSD1306 existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}"
                rm -r /home/pi/script/Adafruit_Python_SSD1306
        fi
        if [ -e /home/pi/script/dht22.py ] ; then
             echo -e "${cyanclair}\nLe fichier /home/pi/script/dht22.py existe déja ${neutre}"
             echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
             rm /home/pi/script/dht22.py
        fi
        if [ -e /home/pi/script/Minecraftia-Regular.ttf ] ; then
             echo -e "${cyanclair}\nLe fichier /home/pi/script/Minecraftia-Regular.ttf existe déja ${neutre}"
             echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
             rm /home/pi/script/Minecraftia-Regular.ttf
        fi

        cd /home/pi/script

	version=$(python --version 2>&1 | cut -c1-8)
	echo -e "${vertclair}\nVersion de Python par défaut : ${neutre}"
	echo -e $version
	if [[ $version =~ "Python 3" ]]; then
		#installation si Python3
		sudo apt install -y python3-dev
		sudo apt install -y python-imaging python-smbus i2c-tools
		sudo apt install -y python-smbus i2c-tools
		sudo apt install -y python3-pil
		sudo apt install -y python3-pip
		sudo apt install -y python3-setuptools
		sudo apt install -y python3-rpi.gpio
		python3 -m pip install --upgrade pip setuptools wheel
		pip3 install Adafruit_DHT
		cd /home/pi/script/Adafruit_Python_DHT
		python3 setup.py install
		cd /home/pi/script/Adafruit_Python_SSD1306
		sudo python3 setup.py install
	else:
		#installation si Python2
		apt install python-pip
		python -m pip install --upgrade pip setuptools wheel
		sudo pip install Adafruit_DHT
		cd /home/pi/script/Adafruit_Python_DHT
		python setup.py install
                cd /home/pi/script/Adafruit_Python_SSD1306
                sudo python setup.py install
	fi

	#Téléchargement des bibliothèques et des fichiers
#	echo -e "${bleuclair}\nInstallation des bilbiothèques AdaFruit pour le capteur DHT22 (nécessite Domoticz) ${neutre}"
#        git clone https://github.com/adafruit/Adafruit_Python_DHT.git
#        git clone https://github.com/adafruit/Adafruit_Python_SSD1306.git
#	echo -e "${vertclair}\nTéléchargement du fichier dht22.py et de la police de caractère ${neutre}"
#	wget https://raw.githubusercontent.com/KELLERStephane/KELLER-Stephane-Tests2maths/master/7%20-%20Raspberry%20Pi/dht22.py
#	chown pi:pi dht22.py
#	wget https://github.com/KELLERStephane/KELLER-Stephane-Tests2maths/blob/master/7%20-%20Raspberry%20Pi/Minecraftia-Regular.ttf
#	chown pi:pi Minecraftia-Regular.ttf
#	chmod +x /home/pi/script/dht22.py

	#Saisie des paramètres pour le fichier dht22.py
#	adresse=$(hostname -I | cut -d' ' -f1)
#	echo -e "${vertclair}\nAdresse IP = ${neutre}"
#	echo -e $adresse
#	echo -e "${vertclair}Ajout de l'adresse IP dans le fichier dht22.py ${neutre}"
#        L1='domoticz_ip ='
#	L2='domoticz_ip = '
#	L3=$adresse
#	sed -i '/'"$L1"'/ c\'"$L2"''"$L3"'' /home/pi/script/dht22.py

#	user=$(who 2>&1 | cut -c1-2)
#        echo -e "${vertclair}\nUser = ${neutre}"
#        echo -e $user
#        echo -e "${vertclair}Ajout user dans le fichier dht22.py ${neutre}"
#        L4='user ='
#        L5='user = '
#        L6=$user
#        sed -i '/'"$L4"'/ c\'"$L5"''"$L6"'' /home/pi/script/dht22.py

#	boucle=true
#	while $boucle;do
#
#		MDP=$(whiptail --title "Paramètres pour dht22.py" --inputbox "Saisir mot de passe pi : " 10 60 3>&1 1>&2 2>&3)
#	 	exitstatus=$?
#		if [ $exitstatus = 0 ]; then
#		        L1='password ='
#	        	L2='password ='
#	        	L3=$MDP
#		       	sed -i '/'"$L1"'/ c\'"$L2"''"$L3"'' /home/pi/script/dht22.py
#			boucle=false
#		else
#		    	echo "Tu as annulé... Recommence :-("
#		fi
#	done

	crontab -u root -l > /tmp/toto.txt # export de la crontab
	grep "dht22.py" /tmp/toto.txt
#	test=$?
#	echo $test
	if [[ $? = 0 ]];then
		echo "OK"
	else
		echo "NOK"
	fi


#        grep 'dht22.py' toto.txt retval=$? if [ "$retval" = 0 ] then echo "OK" else echo "NOK" fi
	echo $retval


#	if [[ "$var"=0 ]]; then
#		echo -e "${vertclair}\nModification de la crontab : ${neutre}"
#		echo "#affichage de la temp+hum toutes les 10 mn chaque jour" >> /tmp/toto.txt # ajout de la ligne dans le fichier temporaire
#	        echo "*/10 * * * * sudo /home/pi/script/dht22.py" >> /tmp/toto.txt # ajout de la ligne dans le fichier temporaire
#		crontab /tmp/toto.txt # import de la crontab
#		rm /tmp/toto.txt # le fichier temporaire ne sert plus à rien
#	fi

#	echo -e "${vertclair}\nTest module i2c : ${neutre}"
#	lsmod | grep i2c_
#	echo -e "${vertclair}\nVérification de l'adresse du périphérique i2c : ${neutre}"
#	i2cdetect -y 1
#	echo -e "${vertclair}\nTest du capteur de température : ${neutre}"
#	cd /home/pi/script/
#	sudo ./AdafruitDHT.py 22 17
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
