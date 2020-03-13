#!/bin/bash

### ===============================================================
### Script d'installation du Raspberry et des logiciels tiers
### Stéphane KELLER – Lycée Agricole Louis Pasteur
### ===============================================================

### ===============================================================
### Définition des couleurs
### ===============================================================

noir='\e[0;30m'
gris='\e[1;30m'
rougefonce='\e[0;31m'
rougeclair='\e[1;31m'
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
echo -e "https://github.com/KELLERStephane/KELLER-Stephane-Tests2maths ${neutre}"

### ===============================================================
### Choix des options d'installation
### ===============================================================

boucle=true
while "$boucle";do
        echo -e -n "${bleuclair}\nInstallation de Webmin (o/n) : ${neutre}"
        read repwebmin
        if [ "$repwebmin" = "o" ] || [ "$repwebmin" = "O" ]
        then
                echo -e "${jaune}Webmin sera installé ${neutre}"
                boucle=false
        fi
        if [ "$repwebmin" = "n" ] || [ "$repwebmin" = "N" ]
        then
                echo -e "${jaune}Webmin ne sera pas installé ${neutre}"
                boucle=false
        fi
done

boucle=true
while "$boucle";do
        echo -e -n "${bleuclair}\nInstallation de Motioneye (o/n) : ${neutre}"
        read repmotioneye
        if [ "$repmotioneye" = "o" ] || [ "$repmotioneye" = "O" ]
        then
                echo -e "${jaune}Motioneye sera installé ${neutre}"
                boucle=false
        fi
        if [ "$repmotioneye" = "n" ] || [ "$repmotioneye" = "N" ]
        then
                echo -e "${jaune}Motioneye ne sera pas installé ${neutre}"
                boucle=false
        fi
done

boucle=true
while "$boucle";do
        echo -e -n "${bleuclair}\nInstallation d'Apache2 (o/n) : ${neutre}"
        read repapache
        if [ "$repapache" = "o" ] || [ "$repapache" = "O" ]
        then
                echo -e "${jaune}Apache2 sera installé ${neutre}"
                boucle=false
        fi
        if [ "$repapache" = "n" ] || [ "$repapache" = "N" ]
        then
                echo -e "${jaune}Apache2 ne sera pas installé ${neutre}"
                boucle=false
        fi
done

boucle=true
while "$boucle";do
        echo -e -n "${bleuclair}\nInstallation de Domoticz (o/n) : ${neutre}"
        read repdomoticz
        if [ "$repdomoticz" = "o" ] || [ "$repdomoticz" = "O" ]
        then
                echo -e "${jaune}Domoticz sera installé ${neutre}"
                boucle=false
        fi
        if [ "$repdomoticz" = "n" ] || [ "$repdomoticz" = "N" ]
        then
                echo -e "${jaune}Domoticz ne sera pas installé ${neutre}"
                boucle=false
        fi
done

boucle=true
while "$boucle";do
        echo -e -n "${bleuclair}\nInstallation de Fail2ban (o/n) : ${neutre}"
        read repfail2ban
        if [ "$repfail2ban" = "o" ] || [ "$repfail2ban" = "O" ]
        then
                echo -e "${jaune}Fail2ban sera installé ${neutre}"
                boucle=false
        fi
        if [ "$repfail2ban" = "n" ] || [ "$repfail2ban" = "N" ]
        then
                echo -e "${jaune}Fail2ban ne sera pas installé ${neutre}"
                boucle=false
        fi
done

boucle=true
while "$boucle";do
        echo -e -n "${bleuclair}\nInstallation de Fail2map (nécessite d'abord Fail2ban) (o/n) : ${neutre}"
        read repfail2map
        if [ "$repfail2map" = "o" ] || [ "$repfail2map" = "O" ]
        then
                echo -e "${jaune}Fail2map sera installé ${neutre}"
                boucle=false
        fi
        if [ "$repfail2map" = "n" ] || [ "$repfail2map" = "N" ]
        then
                echo -e "${jaune}Fail2map ne sera pas installé ${neutre}"
                boucle=false
        fi
done

### ===============================================================
### Installayion du gestionnaire de paquets "aptitude" si nécessaire
### ===============================================================
echo -e "${vertclair}\nInstallation d'Aptitude si nécessaire ${neutre} ${neutre}"
apt -y install aptitude

### ===============================================================
### Mises à jour du système
### ===============================================================
echo -e "${vertclair}\nMise à jour des paquets si nécessaire ${neutre}"
apt update && apt -y upgrade  && aptitude update

### ===============================================================
### Installation de wget (si nécessaire)
### ===============================================================
echo -e "${vertclair}\nInstallation de wget si nécessaire ${neutre}"
apt -y install wget

### ===============================================================
### Installation de git (si nécessaire)
### ===============================================================
echo -e "${vertclair}\nInstallation de git si nécessaire ${neutre}"
apt -y install git

# puis fixer le probleme de transport sur HTTPS
#apt -y install ca-certificates apt-transport-https
#wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
# enfin on inscrit le dépot dans sources.list pour les prochaines mises à jour
#echo "deb https://packages.sury.org/php/ buster main" | sudo tee /etc/apt/sources.list.d/php.list

### ===============================================================
### Installation du gestionnaire et éditeur de fichiers  "mc" si nécessaire
### ===============================================================
echo -e "${vertclair}\nInstallation du gestionnaire et éditeur de fichier mcedit si nécessaire ${neutre}"
apt -y install mc

### ===============================================================
### Installation d'une commande de recherche de fichiers (« locate ») :
### et mise à jour de l'index des fichiers
### ===============================================================
echo -e "${vertclair}\nInstallation de locate si nécessaire et indexation des fichiers ${neutre}"
apt -y install locate && updatedb

### ===============================================================
### Mise a jour automatique de l'heure
### ===============================================================
echo -e "${vertclair}\nInstalltion du protocole de synchronisation de l'heure si nécessaire ${neutre}"

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

### ===============================================================
### Installation de Webmin
### ===============================================================

if [ "$repwebmin" = "o" ] || [ "$repwebmin" = "O" ]
then
	echo -e "${vertclair}\nInstallation de Webmin ${neutre}"
	aptitude -y install libnet-ssleay-perl openssl libauthen-pam-perl libio-pty-perl apt-show-versions python
	wget http://www.webmin.com/download/deb/webmin-current.deb --no-check-certificate
	dpkg --install webmin-current.deb && rm -f webmin-current.deb
fi

### ===============================================================
### Installation de Motioneye
### ===============================================================

if [ "$repmotioneye" = "o" ] || [ "$repmotioneye" = "O" ]
then
	echo -e "${vertclair}\nInstallation de Motioneye avec le module de caméra CSI OV5647 pour le Rapsberry Pi ${neutre}"
        if [ -d "/etc/motioneye" ]
	then
                echo -e "${cyanclair}Le répertoire d'installation /etc/motioneye existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}";
                rm -r /etc/motioneye
        fi

        if [ -d "/var/lib/motioneye" ]
	then
                echo -e "${cyanclair}Le répertoire média /var/lib/motioneye existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}";
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
                echo -e "${cyanclair}La désactivation de la led de la caméra est déja active dans /boot/config.txt ${neutre}";
        else
        	echo "disable_camera_led=1" | sudo tee -a /boot/config.txt
        fi

	echo -e "${vertclair}\nMise à jour des paquets dépendants si nécessaire ${neutre}"
        apt -y install python-pip python-dev libssl-dev libcurl4-openssl-dev libjpeg-dev libz-dev
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
        dpkg -i pi_buster_motion_4.2.2-1_armhf.deb
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

if [ "$repapache" = "o" ] || [ "$repapache" = "O" ]
then
        echo -e "${vertclair}\nInstallation d'Apache ${neutre}"

#        if [ -d "/etc/apache2" ]
#        then
#                echo -e "${cyanclair}Le répertoire d'installation d'Apache2 /etc/apache2 existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}";
#                rm -r /etc/apache2
#        fi
        aptitude install apache2 -y

	echo -e "${vertclair}suppression si nécessaire de la page par défaut d'Apache2 ${neutre}"
	if [ -f "/war/www/html/index.html" ]
	then
		rm /var/www/html/index.html
	fi

        echo -e "${vertclair}\nSécuristion d'Apache2. ${neutre}"
        if [ -d "/var/www/passwd" ]
        then
                echo -e "${cyanclair}Le répertoire de mots de passe /var/www/passwd existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}";
                rm -r /var/www/passwd
        fi
        echo -e "${vertclair}\nCréation du répertoire de mot de passe sécurisé /var/wwww/passwd ${neutre}"
        cd /var/www/
        mkdir passwd
        echo -e -n "${vertclair}\nSaisir le nom de l'utilisateur principal pour Apache2 : ${neutre}"
        read username
        htpasswd -c /var/www/passwd/passwords "$username"

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

if [ "$repdomoticz" = "o" ] || [ "$repdomoticz" = "O" ]
then
        echo -e "${bleuclair}\nInstallation de Domoticz ${neutre}" 
	curl -L install.domoticz.com | bash
fi

### ===============================================================
### Installation de Fail2ban
### ===============================================================

if [ "$repfail2ban" = "o" ] || [ "$repfail2ban" = "O" ]
then
        echo -e "${bleuclair}\nInstallation de Fail2ban ${neutre}"

        if [ -d "/etc/fail2ban" ]
        then
                echo -e "${cyanclair}Le répertoire d'installation de Fail2ban /etc/fail2ban existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}";
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
	wget -P /etc/fail2ban/jail.d/ https://raw.githubusercontent.com/KELLERStephane/KELLER-Stephane-Tests2maths/master/7%20-%20Raspberry%20Pi/custom.conf
	boucle=true
	while "$boucle";do
	        echo -e "${bleuclair}\nSaisir l'adresse mail pour les messages de Fail2ban : ${neutre}"
	        read repmaila
	        echo -e "${bleuclair}\nResaisir l'adresse mail : ${neutre}"
	        read repmailb
	        if [ "$repmaila" = "$repmailb" ]
	        then
	                echo -e "${jaune}Adresse mail correcte ${neutre}"
	                boucle=false
	        else
	                echo -e "${jaune}Adresse mail différente. Recommencer"
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
                echo -e "${cyanclair}Le répertoire /home/pi/script existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}";
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
#		unlink /home/pi/script/jails.sh
	fi
	ln -s /home/pi/script/jails.sh /home/pi/
	echo -e "${rougeclair}Pour la liste des prisons et le nombre de bannis : ${neutre}"
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

if [ "$repfail2map" = "o" ] || [ "$repfail2map" = "O" ]
then
        echo -e "${bleuclair}\nInstallation de Fail2map (nécessite Fail2ban) ${neutre}"

        echo -e "${vertclair}\nTéléchargement de Fail2map ${neutre}"
	if [ -d "/var/www/html/fail2map" ]
	then
		echo -e "${cyanclair}Le répertoire /var/www/html/fail2map existe déja. Suppression du répertoire avant la nouvelle installation  ${neutre}";
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
### Copyright
### ===============================================================

echo -e "${jauneclair}\nScript d'installation automatique de Webmin, Motioneye, Apache2, fail2ban et Fail2map pour le Raspberry"
echo -e "Script réalisé par KELLER Stéphane - Lycée Agricole Louis Pasteur"
echo -e "https://github.com/KELLERStephane/KELLER-Stephane-Tests2maths ${neutre}"

### ===============================================================
### Fin de l'installation
### ===============================================================

echo -e "${blancclignotant}Appuyer une touche pour redémarrer le Raspberry ${neutre}"
read
reboot
