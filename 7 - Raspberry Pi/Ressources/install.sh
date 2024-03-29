#!/bin/bash
# coding: utf-8

### ===============================================================
### Script d'installation du Raspberry et des logiciels tiers
### Stéphane KELLER – Lycée Agricole Louis Pasteur
### José De Castro
### https://github.com/KELLERStephane/KELLER-Stephane-Tests2maths
### ===============================================================

### ===============================================================
### Github lien d'origine
### ===============================================================

lien_github="https://github.com/KELLERStephane/KELLER-Stephane-Tests2maths/blob/master/7%20-%20Raspberry%20Pi"
lien_github_raw="https://github.com/KELLERStephane/KELLER-Stephane-Tests2maths/raw/master/7%20-%20Raspberry%20Pi/Ressources"
lien_github_zip="https://github.com/KELLERStephane/KELLER-Stephane-Tests2maths/raw/master/7%20-%20Raspberry%20Pi/Ressources/"

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
### Récuparation et affichage du nom de l'utilisateur courant
### Déplacement dans le répertoire de l'utilisateur courant
### ===============================================================

utilisateur=`cat /etc/passwd | grep "home/" | grep -v "nologin" | cut -d ":" -f1`
echo -e "${jauneclair}L'utilisateur est $utilisateur \n ${neutre}"
cd /home/$utilisateur

### ===============================================================
### Choix des options d'installation
### ===============================================================

boucle_principale=true
while $boucle_principale;do
    CHOIX=$(NEWT_COLORS='
    root=,blue
    checkbox=white,brightblue
    shadow=,black
    ' \
    whiptail --title "Menu d'installation du Raspberry" --checklist \
    "\nScript réalisé par :\n- KELLER Stéphane (Lycée Agricole Louis Pasteur)\n- José De Castro\nhttps://github.com/KELLERStephane/KELLER-Stephane-Tests2maths\n\nQue soutaitez-vous installer ?" 23 72 10 \
    "Debug" "Interruption à la fin de chaque installation " OFF \
    "MAJ" "Mise a jour du systeme " OFF \
    "Fail2ban" "Protection du systeme via auto-bannissement " OFF \
    "Fail2map" "Affichage des ip sur une carte " OFF \
    "Webmin" "Administration du système en mode WEB " OFF \
    "Motioneye" "Logiciel de vidéosurveillance " OFF \
    "Apache2" "Serveur web Apache2 " OFF \
    "GPIO" "Wiringpi pour l'utilisation des GPIO " OFF \
    "Domoticz" "Logiciel de domotique Domoticz " OFF \
    "Capteurs" "Installation et tests des capteurs" OFF 3>&1 1>&2 2>&3)

    exitstatus=$?

    if [[ $exitstatus = 0 ]]; then
        echo -e -n "${jauneclair}\t =======================================  \n ${neutre}"
        echo -e -n "${jauneclair}\t Les logiciels suivants seront installés  \n ${neutre}"
        echo -e -n "${jauneclair}\t $CHOIX                                   \n ${neutre}"
        echo -e -n "${jauneclair}\t =======================================  \n ${neutre}"

        ### ===============================================================
        ### Mise à jour du système
        ### ===============================================================

        if [[ $CHOIX =~ "MAJ" ]]; then
            echo -e "${bleuclair}\nMise à jour des paquets si nécessaire ${neutre}"
            apt update && apt -y upgrade

            echo -e "${bleuclair}\nInstallation d'Aptitude si nécessaire ${neutre} ${neutre}"
            apt install -y aptitude

            echo -e "${bleuclair}\nInstallation de wget si nécessaire ${neutre}"
            apt install -y wget

            echo -e "${bleuclair}\nInstallation de git si nécessaire ${neutre}"
            apt install -y git

            echo -e "${bleuclair}\nInstallation du gestionnaire et éditeur de fichier mcedit si nécessaire ${neutre}"
            apt install -y mc

            echo -e "${bleuclair}\nInstallation de locate si nécessaire et indexation des fichiers ${neutre}"
            apt install -y locate && updatedb

            echo -e "${bleuclair}\nInstallation de PIP si nécessaire et indexation des fichiers ${neutre}"
            apt-get install -y libopenjp2-7-devapt && updatedb
            apt-get install -y python3-pil && updatedb
			
            echo -e "${bleuclair}\nInstallation du protocole de synchronisation de l'heure si nécessaire ${neutre}"
            aptitude install ntp -y
            /etc/init.d/ntp start
            if [ -f /etc/ntp.com ] ; then
                 echo -e "${cyanclair}\nLe fichier /etc/ntp.com existe déjà ${neutre}"
                 echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
                 rm /etc/ntp.com*
            fi
            echo -e "${vertclair}Création du fichier /etc/ntp.com ${neutre}"
            L1='server 0.fr.pool.ntp.org'
            echo -e $L1>/etc/ntp.com

            if [[ $CHOIX =~ "Debug" ]]; then
                echo -e "${violetclair}\nFin des mises à jour. Appuyer sur Entrée pour poursuivre l'Installation ${neutre}"
            read
            fi
        fi

        ### ===============================================================
        ### Installation de Fail2ban
        ### ===============================================================

        if [[ $CHOIX =~ "Fail2ban" ]]; then
            echo -e "${bleuclair}\nInstallation de Fail2ban ${neutre}"

            if [ -d "/etc/fail2ban" ]; then
                echo -e "${cyanclair}Le répertoire d'installation de Fail2ban /etc/fail2ban existe déjà. ${neutre}"
                echo -e "${cyanclair}Désinstallation du logiciel avant la nouvelle installation  ${neutre}"
                rm -r /etc/fail2ban
                apt -y --purge remove fail2ban
            fi
            apt install -y fail2ban

            echo -e "${vertclair}Sauvegarde des fichiers de configuration des prisons de Fail2ban${neutre}"
            echo -e "${vertclair}/etc/fail2ban/jail.conf -> /etc/fail2ban/jail.copy ${neutre}"
            echo -e "${vertclair}/etc/fail2ban/fail2ban.conf -> /etc/fail2ban/fail2ban.copy ${neutre}"
            cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.copy
            cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.copy

            #Création du fichier personnalisable de configuration des prisons
            echo -e "${vertclair}\nCréation du fichier personnalisable de configuration des prisons ${neutre}"
            if [ -f /etc/fail2ban/jail.d/custom.conf ]; then
                echo -e "${cyanclair}\nLe fichier /etc/fail2ban/jail.d/custom.conf existe déjà ${neutre}"
                echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
                rm /etc/fail2ban/jail.d/custom.conf*
            fi
            L1='[DEFAULT]'
            L2='\n#adresses non bannissables ; IP locales : 192.168.0.0/24'
            L3='\nignoreip = 127.0.0.1/8 192.168.0.0/24'
            L4='\n#temps en s de bannissement ; -1 pour infi ; 600 par défaut'
            L5='\nbantime = -1'
            L6='\n#intervalle de scrutation en s dans les fichiers de log ; 600 par défaut'
            L7='\nfindtime = 3600'
            L8="\n#Nombre maxi d'essais de login ; 6 par défaut"
            L9='\nmaxretry = 3'
            L10='\naction = %(action_mw)s'
            L11='\n         fail2map-action'
            L12='\n\ndestemail ='
            L13='\n\n[recidive]'
            L14='\nenabled = true'
            L15="\n#Nombre maxi d'essais de login ; 5  par défaut"
            L16='\nmaxretry = 1'
            L17='\n#intervalle de scrutation en s dans les fichiers de log ; 604800 : 1 semaine'
            L18='\nfindtime = 604800'
            L19='\n#temps en s de bannissement ; -1 pour infini ; 86400  : 1 jour par défaut'
            L20='\nbantime = -1'
            echo -e $L1 $L2  $L3 $L4 $L5 $L6 $L7 $L8 $L9 $L10 $L11 $L12 $L13 $L14 $L15 $L16 $L17 $L18 $L19 $L20>/etc/fail2ban/jail.d/custom.conf
            chown $utilisateur:$utilisateur /etc/fail2ban/jail.d/custom.conf

            #installation de Postfix pour envoi des mails d'alerte
            echo -e "${vertclair}\nInstallation de Postfix si nécessaire pour l'envoi des mails d'alerte ${neutre} ${neutre}"
            apt install -y postfix

            #Saisis adresse mail pour envoi des mails d'alerte
            boucle=true
            while $boucle;do
                mail_a=$(whiptail --title "Adresse mail" --inputbox "Saisir l'adresse mail pour les messages de Fail2ban : ?" 10 60 3>&1 1>&2 2>&3)
                exitstatus=$?
                if [ $exitstatus = 0 ]; then
                    mail_b=$(whiptail --title "Mail" --inputbox "Resaisir l'adresse mail : ?" 10 60 3>&1 1>&2 2>&3)
                    exitstatus=$?
                    if [ "$mail_a" = "$mail_b" ]; then
                        echo -e "${rougelclair}Adresse mail correcte ${neutre}"
                        boucle=false
                    else
                        whiptail --title "Erreur" --msgbox "Adresses mail différente. Recommencer" 8 78
                    fi
                else
                    echo -e "${rougeclair}Erreur ${neutre}"
                fi
            done

            if [ ! -d "/etc/fail2ban" ]; then
                echo -e "${cyanclair}\nFail2ban n'est pas installé ${neutre}"
                echo -e "${cyanclair}Poursuite de l'installation ${neutre}"
            else
                echo -e "${cyanclair}Fail2ban existe ${neutre}"
                if [ -f "/etc/fail2ban/jail.d/postfix.conf" ]; then
                    echo -e "${cyanclair}\nLe fichier /etc/fail2ban/jail.d/postfix.conf existe déjà ${neutre}"
                    echo -e "${cyanclair}Poursuite de l'installation ${neutre}"
                else
                    echo -e "${cyanclair}Création de la prison dans /etc/fail2ban/jail.d/postfix.conf ${neutre}"
                    L1='[postfix]'
                    L2='\nenabled = true'
                    L3='\nport = smtp,ssmtp'
                    L4='\nfilter = postfix'
                    L5='\nlogpath  = /var/log/mail.log'
                    echo -e $L1 $L2 $L3 $L4 $L5 >> /etc/fail2ban/jail.d/postfix.conf
                    chown $utilisateur:$utilisateur /etc/fail2ban/jail.d/postfix.conf
                fi

                #Ajout de l'adresse mail dans le fichier de configuration personnalisable de Fail2ban
                echo -e "${vertclair}Sauvegarde du fichier de configuration personnalisable de Fail2ban ${neutre}"
                echo -e "${vertclair}/etc/fail2ban/jail.d/custom.conf -> /etc/fail2ban/jail.d/custom.copy ${neutre}"
                cp /etc/fail2ban/jail.d/custom.conf /etc/fail2ban/jail.d/custom.copy
                echo -e "${vertclair}Ajout de l'adresse dans le fichier de configuration personnalisable de Fail2ban ${neutre}"
                L1='destemail ='
                L2='destemail = '
                sed -i '/'"$L1"'/ c\'"$L2"''"$mail_a"'' /etc/fail2ban/jail.d/custom.conf
            fi

            #Démarrage du service Postfix
            echo -e "${vertclair}Démarrage du service Postfix ${neutre}"
            service postfix reload

            #Création du fichier sendmail-common.local pour éviter le surplus d'information dans les mails
            echo -e "${vertclair}\nPour éviter le surplus d'information dans les mails ${neutre}"
            echo -e "${vertclair}Création du fichier /etc/fail2ban/action.d/sendmail-common.local ${neutre}"
            L1='[Definition]'
            L2='\naction start ='
            L3='\naction stop ='
            echo -e $L1 $L2 $L3>/etc/fail2ban/action.d/sendmail-common.local

            #Modification du fichier iptables-multiport.conf pour créer un fichier d'IP banni
            if [ -f /etc/fail2ban/action.d/iptables-multiport.copy ]; then
                echo -e "${cyanclair}\nLe fichier /etc/fail2ban/action.d/iptables-multiport.copy existe déjà ${neutre}"
                echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
                rm /etc/fail2ban/action.d/iptables-multiport.copy*
            fi
            cp /etc/fail2ban/action.d/iptables-multiport.conf /etc/fail2ban/action.d/iptables-multiport.copy
            L1='actionban = '
            L2='\nmadate=$(date)'
            L3='\nactionban = <iptables> -I fail2ban-<name> 1 -s <ip> -j <blocktype>'
            L4='\n            if ! grep -Fq <ip> /var/log/ipbannies.log; then echo "fail2ban-<name> <ip> %(madate)s" | sudo tee -a /var/log/ipbannies.log; fi '
            sed -i '/'"$L1"'/ c\'"$L2"''"$L3"''"$L4"'' /etc/fail2ban/action.d/iptables-multiport.conf
            echo -e "${rougeclair}Pour visualiser le fichier d'IP bannies : ${neutre}"
            echo -e "${rougeclair}sudo nano /var/log/ipbannies.log ${neutre}"

            #Démarrage automatique de Fail2ban
            echo -e "${vertclair}\nDémarrage automatique du service Fail2ban lors du démarrage du système ${neutre}"
            systemctl enable fail2ban

            #Téléchargement si nécessaire du script jails.sh
            echo -e "${vertclair}\nTéléchargment si nécessaire du script jails.sh pour l'affichage ${neutre}"
            echo -e "${vertclair}des prisons et du nombre de bannis dans : ${neutre}"

            if [ -d "/home/$utilisateur/script" ]; then
                echo -e "${cyanclair}Le répertoire /home/$utilisateur/script existe déjà. Suppression du répertoire avant la nouvelle installation  ${neutre}"
                rm -r /home/$utilisateur/script
            fi

            mkdir /home/$utilisateur/script
            wget -P /home/$utilisateur/script/ $lien_github_raw/jails.sh
            chown $utilisateur:$utilisateur  /home/$utilisateur/script/jails.sh
            chmod +x /home/$utilisateur/script/jails.sh
            echo -e "${vertclair}\nCréation d'un raccourci vers le bureau ${neutre}"
            if [ -h "/home/$utilisateur/jails.sh" ]; then
                cd /home/$utilisateur
                rm jails.sh*
            fi
            ln -s /home/$utilisateur/script/jails.sh /home/$utilisateur/
            echo -e "${rougelair}Pour la liste des prisons et le nombre de bannis : ${neutre}"
            echo -e "${rougeclair}cd /home/$utilisateur ${neutre}"
            echo -e "${rougeclair}sudo ./jails.sh ${neutre}"

            #téléchargement si nécessaire du script banip
            echo -e "${vertclair}\nTéléchargement si nécessaire du script banip.sh ${neutre}"
            echo -e "${vertclair}pour bannir ou débannir une adresse IP : ${neutre}"
            echo -e "${vertclair}/home/$utilisateur/script/jails.sh ${neutre}"
            wget -P /home/$utilisateur/script/ $lien_github_raw/banip.sh
            chown $utilisateur:$utilisateur  /home/$utilisateur/script/banip.sh
            chmod +x /home/$utilisateur/script/banip.sh
            if [ -h "/home/$utilisateur/banip.sh" ]; then
                cd /home/$utilisateur
                rm banip.sh*
                unlink /home/$utilisateur/script/banip.sh
            fi
            echo -e "${vertclair}\nCréation d'un raccourci vers le bureau ${neutre}"
            ln -s /home/$utilisateur/script/banip.sh /home/$utilisateur/
            echo -e "${rougeclair}Pour bannir ou débannir une adresse IP : ${neutre}"
            echo -e "${rougeclair}cd /home/$utilisateur ${neutre}"
            echo -e "${rougeclair}sudo ./banip.sh ${neutre}"

            if [[ $CHOIX =~ "Debug" ]]; then
                echo -e "${violetclair}\nFin de l'installation de Fail2ban. Appuyer sur Entrée pour poursuivre l'Installation ${neutre}"
                read
            fi
        fi

        ### ===============================================================
        ### Installation de Fail2map
        ### ===============================================================

        if [[ $CHOIX =~ "Fail2map" ]]; then
            echo -e "${bleuclair}\nInstallation de Fail2map (nécessite Fail2ban) ${neutre}"

            echo -e "${vertclair}\nTéléchargement de Fail2map ${neutre}"
            if [ -d "/var/www/html/fail2map" ]; then
                echo -e "${cyanclair}Le répertoire /var/www/html/fail2map existe déjà. Suppression du répertoire avant la nouvelle installation  ${neutre}"
                rm -r /var/www/html/fail2map
            fi
            git clone https://github.com/mvonthron/fail2map /var/www/html/fail2map
            echo -e "${vertclair}Modification de la géolocalisation ${neutre}"
            echo -e "${vertclair}Sauvegarde du fichier ${neutre}"

            echo -e "${vertclair}/var/www/html/fail2map/fail2map.py -> /var/www/html/fail2map/fail2map.copy ${neutre}"
            cp /var/www/html/fail2map/fail2map.py /var/www/html/fail2map/fail2map.copy

            version=$(python --version 2>&1 | cut -c1-8)
            echo -e -n "${vertclair}\nVersion de Python par défaut : ${neutre}"
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
            sed '/'"$L1"'/ c\'"$L2"''"$L3"'' /var/www/html/fail2map/fail2map-action.conf>/home/$utilisateur/fail2map-action.conf
            mv /home/$utilisateur/fail2map-action.conf /var/www/html/fail2map/fail2map-action.conf

            echo -e "${vertclair}Copie du fichier /var/www/html/fail2map/fail2map-action.conf -> /etc/fail2ban/action.d/fail2map-action.conf ${neutre}"
            if [ -f /etc/fail2ban/actions.d/fail2map-action.conf ]; then
                echo -e "${cyanclair}\nLe fichier /etc/fail2ban/action.d/fail2map-action.conf existe déjà ${neutre}"
                echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
                rm /etc/fail2ban/action.d/fail2map-action.conf*
            fi
            cp /var/www/html/fail2map/fail2map-action.conf /etc/fail2ban/action.d/fail2map-action.conf

            #Effacement du fichier exemple IP puis création fichier vierge d'IP
            echo -e "${vertclair}Suppression du fichier d'exemple de localisation /var/www/html/fail2map/places.geojson ${neutre}"
            rm /var/www/html/fail2map/places.geojson*
            echo -e "${vertclair}Création d'un fichier vide localisation /var/www/html/fail2map/places.geojson ${neutre}"
            echo "" | sudo tee -a /var/www/html/fail2map/places.geojson
            echo -e "${vertclair}Modification des droits du fichier /var/www/html/fail2map/places.geojson en -rwxr-xr-x ${neutre}"
            chmod 755 /var/www/html/fail2map/places.geojson

            #Modification de la carte par défaut pour Fail2map
            echo -e "${vertclair}Changement de la carte par défaut en modifiant le fichier /var/www/html/fail2map/js/map.js ${neutre}"
            sed '/'"$L1"'/ c\'"$L2"''"$L3"'' /var/www/html/fail2map/js/maps.js>/home/$utilisateur/maps.js
            L1="baseLayer = *"
            L2="//    baseLayer = L.tileLayer.provider('Thunderforest.Landscape', {"
            L3="\n\tbaseLayer = L.tileLayer.provider('Esri.NatGeoWorldMap', {"
            sed '/'"$L1"'/ c\'"$L2"''"$L3"'' /var/www/html/fail2map/js/maps.js >/home/$utilisateur/maps.js
            mv /home/$utilisateur/maps.js /var/www/html/fail2map/js/maps.js

            if [[ $CHOIX =~ "Debug" ]]; then
                echo -e "${violetclair}\nFin de l'installation de Fail2map. Appuyer sur Entrée pour poursuivre l'Installation ${neutre}"
                read
            fi
        fi

        ### ===============================================================
        ### Installation de Webmin
        ### ===============================================================

        if [[ $CHOIX =~ "Webmin" ]]; then
            if [ -d "/etc/webmin2" ]; then
                echo -e "${cyanclair}Webmin est déja installé. Désinstallation de Webmin avant la nouvelle installation ${neutre}"
                apt -y purge webmin
            fi
            ### Installation de l interface WEB du gestionnaire systeme si nécessaire
            echo -e -n "${bleuclair}\nInstallation/MAJ de la dernière version de WEBMIN.${neutre}"
            ### installer les dépendances
            aptitude -y install libnet-ssleay-perl openssl libauthen-pam-perl libio-pty-perl apt-show-versions
            ### telecharger la derniere version de Webmin
            wget -q --show-progress http://www.webmin.com/download/deb/webmin-current.deb --no-check-certificate
            ### installer le paquet puis le supprimer
            dpkg --install webmin-current.deb && rm -f webmin-current.deb*

            if [ ! -d "/etc/fail2ban" ]; then
                echo -e "${cyanclair}\nFail2ban n'est pas installé ${neutre}"
                echo -e "${cyanclair}Poursuite de l'installation ${neutre}"
            else
                echo -e "${cyanclair}\nFail2ban existe ${neutre}"
                if [ -f "/etc/fail2ban/jail.d/webmin.conf" ]; then
                    echo -e "${cyanclair}\nLe fichier /etc/fail2ban/jail.d/webmin.conf existe déjà ${neutre}"
                    echo -e "${cyanclair}Poursuite de l'installation ${neutre}"
                else
                    echo -e "${cyanclair}Création de la prison dans /etc/fail2ban/jail.d/webmin.conf ${neutre}"
                    L1='[webmin-auth]'
                    L2='\nenabled = true'
                    echo -e $L1 $L2 >/etc/fail2ban/jail.d/webmin.conf
                    chown $utilisateur:$utilisateur /etc/fail2ban/jail.d/webmin.conf
                fi
            fi

            if [[ $CHOIX =~ "Debug" ]]; then
                echo -e "${violetclair}\nFin de l'installation de Webmin. Appuyer sur Entrée pour poursuivre l'Installation ${neutre}"
                read
            fi
        fi

        ### ===============================================================
        ### Installation de Motioneye
        ### ===============================================================

        if [[ $CHOIX =~ "Motioneye" ]]; then
            echo -e "${bleuclair}\nInstallation de Motioneye avec le module de caméra CSI OV5647 pour le Rapsberry Pi ${neutre}"
            echo -e "${rougeclair}Ne pas oublier d'activer la caméra avec sudo raspi-config ${neutre}"

            echo -e "${bleuclair}\nInstallation de Python2 et mise à jour si nécessaire ${neutre}"
            apt install -y·python2
            apt --upgrade python2
            #installation des paquets pour Python2
            echo -e "${vertclair}\nInstallation de pip, dev, pil, setuptools, wheel, requests pour python2 si nécessaire ${neutre}"
            apt install -y python-pip
            apt install -y python-dev
            apt install -y python-setuptools
            python -m pip install --upgrade pip
            python -m pip install --upgrade Pillow
            python -m pip install --upgrade matplotlib
            python -m pip install --upgrade pip setuptools wheel
            python -m pip install requests

            if [ -d "/etc/motioneye" ]; then
                echo -e "${cyanclair}Le répertoire d'installation /etc/motioneye existe déjà. Suppression du répertoire avant la nouvelle installation  ${neutre}"
                rm -r /etc/motioneye
            fi

            if [ -d "/var/lib/motioneye" ]; then
                echo -e "${cyanclair}Le répertoire média /var/lib/motioneye existe déjà. Suppression du répertoire avant la nouvelle installation  ${neutre}"
                rm -r /var/lib/motioneye
            fi

            echo -e "${vertclair}\nInstallation du module bcm2835-v4l2 pour la caméra CSI OV5647 ${neutre}"
            grep -i "bcm2835-v4l2" "/etc/modules" >/dev/null
            if [ $? = 0 ]; then
                echo -e "${cyanclair}Le module bcm2835-v4l2 est déjà déclaré dans /etc/modules ${neutre}"
                else
                echo -e "${cyanclair}Déclaration du module bcm2835-v4l2 dans /etc/modules ${neutre}"
                echo -e "\nbcm2835-v4l2" >> /etc/modules
            fi

            echo -e "${vertclair}\nDésactivation de la led de la caméra CSI OV5647 pour le Rapsberry Pi ${neutre}"
            grep -i "disable_camera_led=1" "/boot/config.txt" >/dev/null
            if [ $? = 0 ]; then
                echo -e "${cyanclair}La désactivation de la led de la caméra est déjà active dans /boot/config.txt ${neutre}"
            else
                echo -e "${cyanclair}Désactivation de la led de la caméra CSI OV5647 /boot/config.txt ${neutre}"
                echo -e "\ndisable_camera_led=1" >> /boot/config.txt
            fi

            echo -e "${vertclair}\nMise à jour des paquets dépendants si nécessaire ${neutre}"
            apt install -y python-pip python-dev libssl-dev libcurl4-openssl-dev libjpeg-dev libz-dev
            apt install -y ffmpeg libmariadb3 libpq5 libmicrohttpd12

            echo -e "${vertclair}\nTéléchargement de Motioneye ${neutre}"
            if [ -f /home/$utilisateur/pi_buster* ];  then
                echo -e "${cyanclair}\nLe fichier de téléchargement pour Motioneye existe déjà ${neutre}"
                echo -e "${cyanclair}Effacement du fichier puis téléchargement du nouveau fichier ${neutre}"
                rm /home/$utilisateur/pi_buster*
            fi
            wget https://github.com/Motion-Project/motion/releases/download/release-4.2.2/pi_buster_motion_4.2.2-1_armhf.deb
            echo -e "${vertclair}\nInstallation de Motioneye ${neutre}"
            dpkg -i pi_buster_motion_4.2.2-1_armhf.deb && rm -f pi_buster_motion_4.2.2-1_armhf.deb*
            pip install motioneye

            mkdir -p /etc/motioneye
            cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf

            mkdir -p /var/lib/motioneye
            cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
            systemctl daemon-reload
            systemctl enable motioneye
            systemctl start motioneye

            if [[ $CHOIX =~ "Debug" ]]; then
                echo -e "${violetclair}\nFin de l'installation de Motioneye. Appuyer sur Entrée pour poursuivre l'Installation ${neutre}"
                read
            fi
        fi

        ### ===============================================================
        ### Installation d'Apache
        ### ===============================================================

        if [[ $CHOIX =~ "Apache2" ]]; then
            echo -e "${bleuclair}\nInstallation d'Apache ${neutre}"

            if [ -d "/etc/apache2" ]; then
                echo -e "${cyanclair}Le répertoire /etc/apache2 existe déjà. Désinstallation avant la nouvelle installation ${neutre}"
                apt -y purge apache2
                if [ -d "/var/www/passwd" ]; then
                    echo -e "${cyanclair}Le répertoire de mots de passe /var/www/passwd existe déjà. Suppression du répertoire avant la nouvelle installation  ${neutre}"
                    rm -r /var/www/passwd
                fi
            fi
            apt install -y apache2

            echo -e "${vertclair}suppression si nécessaire de la page par défaut d'Apache2 ${neutre}"
            if [ -f "/var/www/html/index.html" ]; then
                rm /var/www/html/index.html*
            fi

            boucle1=true
            while $boucle1;do
                echo -e "${vertclair}\nSécurisation d'Apache2. ${neutre}"
                echo -e "${vertclair}\nCréation du répertoire de mot de passe sécurisé /var/wwww/passwd ${neutre}"
                cd /var/www/
                mkdir passwd
                boucle2=true
                while $boucle2;do
                    username=$(whiptail --title "Paramètres pour Apache2" --inputbox "\nSaisir le nom d'utilisateur principal pour Apache 2 : " 10 60 3>&1 1>&2 2>&3)
                    exitstatus=$?
                    if [ $exitstatus = 0 ]; then
                        boucle2=false
                    else
                        echo "Tu as annulé... Recommence :-("
                    fi
                done
                echo -e "${vertclair}Saisi du mot de passe pour Apache2 ${neutre}"
                htpasswd -c /var/www/passwd/passwords "$username"
                erreur=$?
#               echo -e "L'erreur est $erreur"
                if [ "$erreur" = 0 ]; then
                    boucle1=false
                else
                    echo -e "${rougeclair}Erreur. Recommencer ${neutre}"
                fi
            done

            echo -e "${vertclair}\nSécurisisation de l'accès à Apache2 ${neutre}"
            grep -i "AuthType Basic" "/etc/modules" >/dev/null
            if [ $? = 0  ]; then
                echo -e "${cyanclair}Le fichier /etc/apache2/apache2.conf a déjà été modifié ${neutre}"
            echo -e "${cyanclair}Poursuite de l'installation ${neutre}"
            else
                echo -e "${vertclair}Sauvegarde du fichier /etc/apache2/apache2.conf dans /etc/apache2/apache2.copy ${neutre}"
                echo -e "${vertclair}\nModification du fichier /etc/apache2/apache2.conf ${neutre}"
                cp /etc/apache2/apache2.conf /etc/apache2/apache2.copy
                L1='#<\/Directory>'
                L2='#</Directory>'
                L3='\n\n\<Directory /var/www/html>'
                L4='\n\tAuthType Basic'
                L5='\n\tAuthName "ACCES PROTEGE"'
                L6='\n\t# (Following line optional)'
                L7='\n\tAuthBasicProvider file'
                L8='\n\tAuthUserFile "/var/www/passwd/passwords"'
                L9='\n\tRequire valid-user'
                L10='\n\t# tri horaire décroissant'
                L11='\n\tIndexOrderDefault Descending Date'
                L12='\n</Directory>'
                sed -i '/'"$L1"'/ c\'"$L2"''"$L3"''"$L4"''"$L5"''"$L6"''"$L7"''"$L8"''"$L9"''"$L10"''"$L11"''"$L12"'' /etc/apache2/apache2.conf
            fi

            if [ ! -d "/etc/fail2ban" ]; then
                echo -e "${cyanclair}\nFail2ban n'est pas installé ${neutre}"
                echo -e "${cyanclair}Poursuite de l'installation ${neutre}"
            else
                echo -e "${cyanclair}\nFail2ban existe ${neutre}"
                if [ -f "/etc/fail2ban/jail.d/apache.conf" ]; then
                    echo -e "${cyanclair}\nLe fichier /etc/fail2ban/jail.d/apache.conf existe déjà ${neutre}"
                    echo -e "${cyanclair}Poursuite de l'installation ${neutre}"
                else
                    echo -e "${cyanclair}Création de la prison dans /etc/fail2ban/jail.d/apache.conf ${neutre}"
                    L1='[apache-auth]'
                    L2='\nenabled = true'
                    L3='\n\n[apache-badbots]'
                    L4='\nenabled = true'
                    L5='\n\n[apache-noscript]'
                    L6='\nenabled = true'
                    L7='\n\n[apache-overflows]]'
                    L8='\nenabled = true'
                    L9='\n\n[apache-nohome]'
                    L10='\nenabled = true'
                    L11='\n\n[apache-botsearch]'
                    L12='\nenabled = true'
                    L13='\n\n[apache-fakegooglebot]'
                    L14='\nenabled = true'
                    L15='\n\n[apache-modsecurity]'
                    L16='\nenabled = true'
                    L17='\n\n[apache-shellshock]'
                    L18='\nenabled = true'
                    echo -e $L1 $L2  $L3 $L4 $L5 $L6 $L7 $L8 $L9 $L10 $L11 $L12 $L13 $L14 $L15 $L16 $L17 $L18 >/etc/fail2ban/jail.d/apache.conf
                    chown $utilisateur:$utilisateur /etc/fail2ban/jail.d/apache.conf
                fi
            fi

            if [[ $CHOIX =~ "Debug" ]]; then
                echo -e "${violetclair}\nFin de l'installation d'Apache2. Appuyer sur Entrée pour poursuivre l'Installation ${neutre}"
                read
            fi
        fi

        ### ===============================================================
        ### GPIO
        ### ===============================================================

        if [[ $CHOIX =~ "GPIO" ]]; then
            echo -e "${bleuclair}\nInstallation de wiringpi pour l'utilisation des GPIO (nécessite Fail2ban) ${neutre}"
            echo -e "${rougeclair}Ne pas oublier d'activer les GPIO avec sudo raspi-config ${neutre}"
            echo -e "${vertclair}\nTéléchargement et installation de wiringpi si nécessaire ${neutre}"
			cd /temp
			wget https://project-downloads.drogon.net/wiringpi-latest.deb
			dpkg -i wiringpi-latest.deb
            echo -e "${rougeclair}\nExecuter la commande gpio readall pour voir la configuration des broches ${neutre}"

            if [[ $version =~ "Python 3" ]]; then
                #installation si Python3
                echo -e "${vertclair}\nTéléchargement et installation de RPi.GPIO pour python3 si nécessaire ${neutre}"
                apt install -y python3-pip
				apt install -y python3-rpi.gpio
                python3 -m pip install RPi.GPIO
            else
                #installation si Python2
                echo -e "${vertclair}\nTéléchargement et installation de RPi.GPIO pour python2 si nécessaire ${neutre}"
                apt install -y python-pip
				apt install -y python-rpi.gpio
                python -m pip install RPi.GPIO
            fi


            if [[ $CHOIX =~ "Debug" ]]; then
                echo -e "${violetclair}\nFin de l'installation de GPIO. Appuyer sur Entrée pour poursuivre l'Installation ${neutre}"
                read
            fi
        fi

        ### ===============================================================
        ### Installation de Domoticz
        ### ===============================================================

        if [[ $CHOIX =~ "Domoticz" ]]; then
            echo -e "${bleuclair}\nInstallation de Domoticz ${neutre}"
            sudo bash -c "$(curl -sSfL https://install.domoticz.com)"

            echo -e "${vertclair}Création du fichier log /var/log/domoticz.log ${neutre}"
            cp /etc/init.d/domoticz.sh /etc/init.d/domoticz.copy
            L1='#DAEMON_ARGS="$DAEMON_ARGS -log \/tmp\/domoticz.txt'
            L2='#DAEMON_ARGS="$DAEMON_ARGS -log \/tmp\/domoticz.txt'
            L3='\nDAEMON_ARGS="$DAEMON_ARGS -log /var/log/domoticz.log"'
            sed -i '/'"$L1"'/ c\'"$L2"''"$L3"'' /etc/init.d/domoticz.sh

            echo -e "${vertclair}Téléchargement du filtre Domoticz pour Fail2ban ${neutre}"
            echo -e "${vertclair}pour domoticz dans /etc/fail2ban/filter.d/domoticz.conf ${neutre}"
            if [ -f /etc/fail2ban/filter.d/domoticz.conf ] ; then
                echo -e "${cyanclair}\nLe fichier /etc/fail2ban/filter.d/domoticz.conf existe déjà ${neutre}"
                echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
                rm /etc/fail2ban/filter.d/domoticz.conf*
            fi
            wget -P /etc/fail2ban/filter.d/ $lien_github_raw/domoticz.conf
            chown $utilisateur:$utilisateur /etc/fail2ban/filter.d/domoticz.conf

            if [ ! -d "/etc/fail2ban" ]; then
                echo -e "${cyanclair}\nFail2ban n'est pas installé ${neutre}"
                echo -e "${cyanclair}Poursuite de l'installation ${neutre}"
            else
                echo -e "${cyanclair}Fail2ban existe ${neutre}"
                if [ -f "/etc/fail2ban/jail.d/domoticz.conf" ]; then
                    echo -e "${cyanclair}\nLe fichier /etc/fail2ban/jail.d/domoticz.conf existe déjà ${neutre}"
                    echo -e "${cyanclair}Poursuite de l'installation ${neutre}"
                else
                    echo -e "${cyanclair}Création de la prison dans /etc/fail2ban/jail.d/domoticz.conf ${neutre}"
                    L1='[domoticz]'
                    L2='\nenabled  = true'
                    L3='\nport = 8080,443'
                    L4='\nfilter = domoticz'
                    L5='\nlogpath = /var/log/domoticz.log'
                    echo -e $L1 $L2 $L3 $L4 $L5 >> /etc/fail2ban/jail.d/domoticz.conf
                    chown $utilisateur:$utilisateur /etc/fail2ban/jail.d/domoticz.conf
                fi
            fi

            if [[ $CHOIX =~ "Debug" ]]; then
                echo -e "${violetclair}\nFin de l'installation de Domoticz. Appuyer sur Entrée pour poursuivre l'Installation ${neutre}"
                read
            fi
        fi

        ### ===============================================================
        ### INSTALLATION DES CAPTEURS
        ### ===============================================================

        if [[ $CHOIX =~ "Capteurs" ]]; then
            boucle_capteur=true
            while $boucle_capteur;do

                CHOIX_CAPTEUR=$(NEWT_COLORS='
                root=,black
                checkbox=white,black
                shadow=,blue
                ' \
                whiptail --title "Menu d'installation des capteurs Raspberry" --checklist \
                "\nScript réalisé par :\n- KELLER Stéphane (Lycée Agricole Louis Pasteur)\n- José De Castro\nhttps://github.com/KELLERStephane/KELLER-Stephane-Tests2maths\n\nQuels capteurs soutaitez-vous installer ?" 24 72 10 \
                "Debug" "Interruption à la fin de chaque installation " OFF \
                "GrovePi" "GrovePI de Dexter Industries " OFF \
                "DHT22" "Capteur de température et d'humidité DHT22 " OFF \
                "DS18B20" "Capteur de température DS18B20 " OFF \
                "AM2315" "Capteur de température et d'humidité AM2315 " OFF \
                "Kuman" "Affichage données DHT22 sur écran Kuman " OFF \
                "LCD" "Affichage données DHT22 sur écran LCD RGB Backlight" OFF \
                "SPI" "Affichage données DHT22 sur écran bus SPI " OFF \
                "Tests" "Tests des capteurs" OFF \
                "DEL" "Désinstallation des capteurs et programmes associés" OFF 3>&1 1>&2 2>&3)

                exitstatus=$?

                #installation des paquets pour Python3
                echo -e "${vertclair}\nInstallation de pip, dev, pil, setuptools, wheel, requests pour python3 si nécessaire ${neutre}"
                apt install -y python3-pip
                apt install -y python3-dev
                apt install -y python3-setuptools
                python3 -m pip install --upgrade pip
                python3 -m pip install --upgrade Pillow
                python3 -m pip install --upgrade matplotlib
                python3 -m pip install --upgrade pip setuptools wheel
                python3 -m pip install requests
 
                echo -e "${bleuclair}\nInstallation de Python3 et mise à jour si nécessaire ${neutre}"
                apt install -y python3
                apt --upgrade python3
#                echo -e "${vertclair}\nModification da la version par défaut de python en python3 si nécessaire ${neutre}"
#                update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
#                update-alternatives --install /usr/bin/python python /usr/bin/python3.7 2
                echo -e "${vertclair}\nChoix de la version de Python par défaut : ${neutre}"
                #echo 1 pour Python 2 par défaut et echo 2 pour Python 3 par défaut
                echo 1 | sudo update-alternatives --config python
                echo -e -n "${vertclair}\nLa version de Python par défaut est : ${neutre}"
                python --version
                apt-get install libatlas-base-dev
            
                ver=$(python -c"import sys; print(sys.version_info.major)")

                if [[ $exitstatus = 0 ]]; then
                    echo -e -n "${jauneclair}\t =======================================  \n ${neutre}"
                    echo -e -n "${jauneclair}\t Les capteurs suivants seront installés   \n ${neutre}"
                    echo -e -n "${jauneclair}\t $CHOIX_CAPTEUR                           \n ${neutre}"
                    echo -e -n "${jauneclair}\t =======================================  \n ${neutre}"

                    ### ===============================================================
                    ### SHIELD GROVEPI
                    ### ===============================================================

                    if [[ $CHOIX_CAPTEUR =~ "GrovePi" ]]; then
                        echo -e "${bleuclair}\nInstallation des capteurs GrovePi ${neutre}"
                        echo -e "${rougeclair}Le shield GrovePi doit être monté sur le Raspberry ${neutre}"
                        echo -e "${rougeclair}Ne pas oublier d'activer 1-Wire avec sudo raspi-config ${neutre}"
                        echo -e "${rougeclair}Ne pas oublier d'activer i2C avec sudo raspi-config ${neutre}"
                        echo -e "${rougeclair}Ne pas oublier d'activer les GPIO avec sudo raspi-config ${neutre}"

                        #Téléchargement et installation du Grovepi
                        curl -kL dexterindustries.com/update_grovepi | sudo -u $utilisateur bash
                    fi

                    ### ===============================================================
                    ### CAPTEUR DE TEMPERATURE DHT22
                    ### Récupération des paramètres suivants :
                    ###     => adresse IP du Raspberry
                    ###     =>·identifiant Domoticz
                    ###     =>·mot de passe de Domoticz
                    ###     =>·idx du capteur DHT22 pour Domoticz
                    ###     =>·numéro de GPIO sur lequel est relié le·capteur·DHT22
                    ### ===============================================================

                    if [[ $CHOIX_CAPTEUR =~ "DHT22" ]]; then
                        echo -e "${bleuclair}\nInstallation du capteur de température et d'humidité DHT22 ${neutre}"
                        echo -e "${rougeclair}Domoticz et GPIO doivent être installés et le capteur relié au Raspberry ${neutre}"
                        echo -e "${rougeclair}Il faut connaître et renseigner : ${neutre}"
                        echo -e "${rougeclair}- l'IDX du capteur dht22 dans domoticz ; ${neutre}"
                        echo -e "${rougeclair}- le numéro GPIO BCM sur lequel est relié le capteur. ${neutre}"
                        echo -e "${rougeclair}Ne pas oublier d'activer les GPIO avec sudo raspi-config ${neutre}" 

                        if [ -d "/home/$utilisateur/script/Adafruit_Python_DHT" ]; then
                            echo -e "${cyanclair}\nLe répertoire d'installation /home/$utilisateur/script/Adafruit_Python_DHT existe déjà. Suppression du répertoire avant la nouvelle installation ${neutre}"
                            rm -r /home/$utilisateur/script/Adafruit_Python_DHT
                        fi
                        if [ -f "/home/$utilisateur/script/dht22.py" ] ; then
                            echo -e "${cyanclair}\nLe fichier /home/$utilisateur/script/dht22.py existe déjà ${neutre}"
                            echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
                            rm /home/$utilisateur/script/dht22.py*
                        fi

                        cd /home/$utilisateur/script
                        #Téléchargement des bibliothèques et des fichiers
                        echo -e "${bleuclair}\nInstallation des bilbiothèques AdaFruit pour le capteur DHT22 (nécessite Domoticz) ${neutre}"
                        git clone https://github.com/adafruit/Adafruit_Python_DHT.git
                        chown $utilisateur:$utilisateur /home/$utilisateur/script/Adafruit_Python_DHT

                        version=$(python --version 2>&1 | cut -c1-8)
                        echo -e -n "${vertclair}\nVersion de Python par défaut : ${neutre}"
                        echo -e $version
                        if [[ $version =~ "Python 3" ]]; then
                            #installation si Python3
                            cd /home/$utilisateur/script/Adafruit_Python_DHT
                            python3 setup.py install
                        else
                            #installation si Python2
                            cd /home/$utilisateur/script/Adafruit_Python_DHT
                            python setup.py install
                        fi

                        echo -e "${vertclair}\nTéléchargement du fichier dht22.py ${neutre}"
                        wget -P /home/$utilisateur/script $lien_github_raw/dht22.py
                        chown $utilisateur:$utilisateur /home/$utilisateur/script/dht22.py
                        chmod +x /home/$utilisateur/script/dht22.py

                        #Saisie des paramètres pour le fichier dht22.py
                        adresse=$(hostname -I | cut -d' ' -f1)
                        echo -e -n "${vertclair}Adresse IP = ${neutre}"
                        echo -e $adresse
                        echo -e "${vertclair}Ajout de l'adresse IP dans le fichier dht22.py ${neutre}"
                        L1="domoticz_ip ="
                        L2="domoticz_ip = '"
                        L3=$adresse
                        L4="'"
                        sed -i '/'"$L1"'/ c\'"$L2"''"$L3"''"$L4"'' /home/$utilisateur/script/dht22.py

                        #Saisie des paramètres de domoticz pour affichage température et humidité sur domoticz
                        boucle=true
                        while $boucle;do
                            USER=$(whiptail --title "Paramètres pour dht22.py" --inputbox "\nSaisir l'identifiant domoticz : " 10 60 3>&1 1>&2 2>&3)
                            exitstatus=$?
                            if [ $exitstatus = 0 ]; then
                                L1="user ="
                                L2="user = '"
                                L3=$USER
                                L4="'"
                                sed -i '/'"$L1"'/ c\'"$L2"''"$L3"''"$L4"'' /home/$utilisateur/script/dht22.py
                                boucle=false
                            else
                                echo "Tu as annulé... Recommence :-("
                            fi
                        done
                        echo -e "${vertclair}Ajout de l'identifiant dans le fichier dht22.py ${neutre}"

                        boucle=true
                        while $boucle;do
                            MDP=$(whiptail --title "Paramètres pour dht22.py" --passwordbox "\nSaisir votre mot de passe pour domoticz" 10 60 3>&1 1>&2 2>&3)
                            exitstatus=$?
                            if [ $exitstatus = 0 ]; then
                                L1="password ="
                                L2="password = '"
                                L3=$MDP
                                L4="'"
                                sed -i '/'"$L1"'/ c\'"$L2"''"$L3"''"$L4"'' /home/$utilisateur/script/dht22.py
                                boucle=false
                            else
                                echo "Vous avez annulez"
                            fi
                        done
                        echo -e "${vertclair}Ajout du mot de passe dans le fichier dht22.py ${neutre}"

                        boucle=true
                        while $boucle;do
                            IDX=$(whiptail --title "Paramètres pour dht22.py" --inputbox "\nSaisir l'IDX du dispositif dht22 : " 10 60 3>&1 1>&2 2>&3)
                            exitstatus=$?
                            if [ $exitstatus = 0 ]; then
                                L1="domoticz_idx ="
                                L2="domoticz_idx = "
                                L3=$IDX
                                sed -i '/'"$L1"'/ c\'"$L2"''"$L3"'' /home/$utilisateur/script/dht22.py
                                boucle=false
                            else
                                echo "Tu as annulé... Recommence :-("
                            fi
                        done
                        echo -e "${vertclair}Ajout de l'IDX dans le fichier dht22.py ${neutre}"

                        boucle=true
                        while $boucle;do
                            PIN=$(whiptail --title "Paramètres pour dht22.py" --inputbox "\nSaisir le numéro de GPIO (BCM) sur lequel est relié le dht22 sur le rapsberry : " 10 60 3>&1 1>&2 2>&3)
                            exitstatus=$?
                            if [ $exitstatus = 0 ]; then
                                L1="pin ="
                                L2="pin = "
                                L3=$PIN
                                sed -i '/'"$L1"'/ c\'"$L2"''"$L3"'' /home/$utilisateur/script/dht22.py
                                boucle=false
                            else
                                echo "Tu as annulé... Recommence :-("
                            fi
                        done
                        echo -e "${vertclair}Ajout du numéro de GPIO (BCM) dans le fichier dht22.py ${neutre}"

                        #Modification de la crontab pour mise à jour de température et humidité toutes les 10 minutes
                        crontab -u root -l > /tmp/toto.txt # export de la crontab
                        grep -i "dht22.py" "/tmp/toto.txt" >/dev/null
                        if [ $? = 0 ];then
                            echo -e "${vertclair}\nLa crontab a déja été modifiée ${neutre}"
                        else
                            echo -e "${vertclair}\nModification de la crontab ${neutre}"
                            echo -e "\n#DHT22 Affichage de la température et de l'humidité toutes les 10 mn chaque jour" >> /tmp/toto.txt # ajout de la ligne dans le fichier temporaire
                            echo -e "*/10 * * * * cd /home/$utilisateur/script && python dht22.py" >> /tmp/toto.txt # ajout de la ligne dans le fichier temporaire
                            crontab /tmp/toto.txt # import de la crontab
                            rm /tmp/toto.txt* # le fichier temporaire ne sert plus à rien
                        fi

                        if [[ $CHOIX_CAPTEUR =~ "Debug" ]]; then
                            echo -e "${violetclair}\nFin de l'installation du capteur DHT22. Appuyer sur Entrée pour poursuivre l'Installation ${neutre}"
                            read
                        fi
                    fi

                    ### ===============================================================
                    ### CAPTEUR DE TEMPERATURE DS18B20
                    ### Récupération·des·paramètres·suivants :
                    ###    => numéro de GPIO sur lequel est relié le capteur DS18B20
                    ### ===============================================================

                    if [[ $CHOIX_CAPTEUR =~ "DS18B20" ]]; then
                        echo -e "${bleuclair}\nInstallation du capteur de température DS18B20 ${neutre}"
                        echo -e "${rougeclair}Domoticz et GPIO doivent être installés et le capteur relié au Raspberry ${neutre}"
                        echo -e "${rougeclair}Il faut connaître et renseigner  le numéro ${neutre}"
                        echo -e "${rougeclair}GPIO BCM sur lequel est relié le capteur. ${neutre}"
                        echo -e "${rougeclair}Ne pas oublier d'activer les GPIO avec sudo raspi-config ${neutre}"
                        echo -e "${rougeclair}Ne pas oublier d'activer bus 1-Wire avec sudo raspi-config ${neutre}"

                        #Modification du fichier /boot/config.txt en renseignant le numéro de GPIO BCM
                        boucle=true
                        while $boucle;do
                            BCM=$(whiptail --title "Paramètres pour le capteur DS18B20" --inputbox "\nSaisir le GPIO (BCM) pour le capteur DS18B20 : " 10 60 3>&1 1>&2 2>&3)
                            exitstatus=$?
                            if [ $exitstatus = 0 ]; then
                                echo -e "${vertclair}\nActivation du bus 1-Wire ${neutre}"
                                grep -i "dtoverlay=w1-gpio" "/boot/config.txt" >/dev/null
                                if [ $? = 0 ]; then
                                    echo -e "${vertclair}\nModification du fichier config.txt en modifiant le numéro de GPIO (BCM) ${neutre}"
                                    L1="dtoverlay=w1-gpio"
                                    L2="dtoverlay=w1-gpio,gpiopin="
                                    L3=$BCM
                                    sed -i '/'"$L1"'/ c\'"$L2"''"$L3"'' /boot/config.txt
                                else
                                    echo -e "${cyanclair}Modification du fichier /boot/config.txt en ajoutant le numéro de GPIO (BCM) ${neutre}"
                                    echo -e "\n#Capteur température DS18B20\ndtoverlay=w1-gpio,gpiopin=$BCM" >> /boot/config.txt
                                fi
                                boucle=false
                            else
                                echo "Tu as annulé... Recommence :-("
                            fi
                        done
                        echo -e "${vertclair}\nAjout du GPIO (BCM) dans le fichier /boot/config.txt ${neutre}"

                        #Modification du fichier /etc/modules en ajoutant les modules
                        echo -e "${vertclair}\nModification du fichier /etc/modules ${neutre}"
                        grep -i "w1-therm" "/etc/modules" >/dev/null
                        if [ $? = 0 ]; then
                            echo -e "${cyanclair}Le fichier /etc/modules a déjà été modifié ${neutre}"
                            echo -e "${cyanclair}Poursuite de l'installation ${neutre}"
                        else
                            echo -e "\nw1-therm\nw1-gpio" >> /etc/modules
                        fi
                        echo -e "${vertclair}\nExécution des modules ${neutre}"
                        modprobe w1-gpio
                        modprobe w1-therm

                        if [ -f "/home/$utilisateur/script/dht22.py" ] ; then
                            echo -e "${cyanclair}\nLe fichier /home/$utilisateur/script/ds18b20.py existe déjà ${neutre}"
                            echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
                            rm /home/$utilisateur/script/ds18b20.py*
                        fi
                        echo -e "${vertclair}\nTéléchargement du fichier ds18b20.py ${neutre}"
                        wget -P /home/$utilisateur/script $lien_github_raw/ds18b20.py
                        chown $utilisateur:$utilisateur /home/$utilisateur/script/ds18b20.py
                        chmod +x /home/$utilisateur/script/ds18b20.py

                        if [[ $CHOIX_CAPTEUR =~ "Debug" ]]; then
                            echo -e "${violetclair}\nFin de l'installation du capteur DS18B20. Appuyer sur Entrée pour poursuivre l'Installation ${neutre}"
                            read
                        fi
                    fi

                    ### ===============================================================
                    ### CAPTEUR DE TEMPERATURE AM2315
                    ### Récupération des paramètres suivants :
                    ###     => adresse IP du Raspberry
                    ###     =>·identifiant Domoticz
                    ###     =>·mot de passe de Domoticz
                    ###     =>·idx du capteur AM2315 pour Domoticz
                    ### ===============================================================

                    if [[ $CHOIX_CAPTEUR =~ "AM2315" ]]; then
                        echo -e "${bleuclair}\nInstallation du capteur de température et d'humidité AM2315 ${neutre}"
                        echo -e "${rougeclair}Domoticz et GPIO doivent être installés et le capteur relié au Raspberry ${neutre}"
                        echo -e "${rougeclair}Il faut connaître et renseigner : ${neutre}"
                        echo -e "${rougeclair}- l'IDX du capteur dht22 dans domoticz ; ${neutre}"
                        echo -e "${rougeclair}Ne pas oublier d'activer les GPIO avec sudo raspi-config ${neutre}" 
                        echo -e "${rougeclair}Ne pas oublier d'activer I2C avec sudo raspi-config ${neutre}"

                        version=$(python --version 2>&1 | cut -c1-8)
                        echo -e -n "${vertclair}\nVersion de Python par défaut : ${neutre}"
                        echo -e $version
                        if [[ $version =~ "Python 3" ]]; then
                            #installation si Python3
                            cd /home/$utilisateur/script/Adafruit_Python_DHT
                            pip install adafruit-circuitpython-am2320

                            if [ -f /home/$utilisateur/script/am2315.py ] ; then
                                echo -e "${cyanclair}\nLe fichier /home/$utilisateur/script/am2315.py existe déjà ${neutre}"
                                echo -e "${cyanclair}Effacement du fichier puis téléchargement du nouveau fichier ${neutre}"
                                rm /home/$utilisateur/script/am2315.py*
                            fi

                            echo -e "${vertclair}\nTéléchargement du fichier am2315.py ${neutre}"
                            wget -P /home/$utilisateur/script $lien_github_raw/am2315.py
                            chown $utilisateur:$utilisateur /home/$utilisateur/script/am2315.py
                            chmod +x /home/$utilisateur/script/am2315.py

                            #Saisie des paramètres pour le fichier am2315.py
                            adresse=$(hostname -I | cut -d' ' -f1)
                            echo -e -n "${vertclair}Adresse IP = ${neutre}"
                            echo -e $adresse
                            echo -e "${vertclair}Ajout de l'adresse IP dans le fichier am2315.py ${neutre}"
                            L1="domoticz_ip ="
                            L2="domoticz_ip = '"
                            L3=$adresse
                            L4="'"
                            sed -i '/'"$L1"'/ c\'"$L2"''"$L3"''"$L4"'' /home/$utilisateur/script/am2315.py

                            #Saisi des paramètres de domoticz pour affichage température et humidité sur domoticz
                            boucle=true
                            while $boucle;do
                                USER=$(whiptail --title "Paramètres pour am2315.py" --inputbox "\nSaisir l'identifiant domoticz : " 10 60 3>&1 1>&2 2>&3)
                                exitstatus=$?
                                if [ $exitstatus = 0 ]; then
                                    L1="user ="
                                    L2="user = '"
                                    L3=$USER
                                    L4="'"
                                    sed -i '/'"$L1"'/ c\'"$L2"''"$L3"''"$L4"'' /home/$utilisateur/script/am2315.py
                                    boucle=false
                                else
                                    echo "Tu as annulé... Recommence :-("
                                fi
                            done
                            echo -e "${vertclair}Ajout de l'identifiant dans le fichier am2315.py ${neutre}"

                            boucle=true
                            while $boucle;do
                                MDP=$(whiptail --title "Paramètres pour am2315.py" --passwordbox "\nSaisir votre mot de passe pour domoticz" 10 60 3>&1 1>&2 2>&3)
                                exitstatus=$?
                                if [ $exitstatus = 0 ]; then
                                    L1="password ="
                                    L2="password = '"
                                    L3=$MDP
                                    L4="'"
                                    sed -i '/'"$L1"'/ c\'"$L2"''"$L3"''"$L4"'' /home/$utilisateur/script/am2315.py
                                    boucle=false
                                else
                                    echo "Vous avez annulez"
                                fi
                            done
                            echo -e "${vertclair}Ajout du mot de passe dans le fichier am2315.py ${neutre}"

                            boucle=true
                            while $boucle;do
                                IDX=$(whiptail --title "Paramètres pour am2315.py" --inputbox "\nSaisir l'IDX du dispositif am2315 : " 10 60 3>&1 1>&2 2>&3)
                                exitstatus=$?
                                if [ $exitstatus = 0 ]; then
                                    L1="domoticz_idx ="
                                    L2="domoticz_idx = "
                                    L3=$IDX
                                    sed -i '/'"$L1"'/ c\'"$L2"''"$L3"'' /home/$utilisateur/script/am2315.py
                                    boucle=false
                                else
                                    echo "Tu as annulé... Recommence :-("
                                fi
                            done
                            echo -e "${vertclair}Ajout de l'IDX dans le fichier am2315.py ${neutre}"

                            #Modification de la crontab pour mise à jour de température et humidité toutes les 10 minutes
                            crontab -u root -l > /tmp/toto.txt # export de la crontab
                            grep -i "am2315.py" "/tmp/toto.txt" >/dev/null
                            if [ $? = 0 ];then
                                echo -e "${vertclair}\nLa crontab a déja été modifiée ${neutre}"
                            else
                                echo -e "${vertclair}\nModification de la crontab ${neutre}"
                                echo -e "#AM2315 Affichage de la température et de l'humidité toutes les 10 mn chaque jour" >> /tmp/toto.txt # ajout de la ligne dans le fichier temporaire
                                echo -e "*/10 * * * * cd /home/$utilisateur/script && python am2315.py" >> /tmp/toto.txt # ajout de la ligne dans le fichier temporaire
                                crontab /tmp/toto.txt # import de la crontab
                                rm /tmp/toto.txt* # le fichier temporaire ne sert plus à rien
                            fi

                        else
                            #installation si Python2
                            echo -e "${rougeclair}Ne fonctionne pas avec Python 2 ! ${neutre}"
                            exit
                        fi

                        if [[ $CHOIX_CAPTEUR =~ "Debug" ]]; then
                            echo -e "${violetclair}\nFin de l'installation du capteur AM2315. Appuyer sur Entrée pour poursuivre l'Installation ${neutre}"
                            read
                        fi
                    fi

                    ### ===============================================================
                    ### Ecran Kuman pour affichage données DHT22
                    ### ===============================================================

                    if [[ $CHOIX_CAPTEUR =~ "Kuman" ]]; then
                        CHOIX_KUMAN=$(whiptail --title "Menu d'installation de l'écran Kuman" --menu \
                        "\nScript réalisé par :\n- KELLER Stéphane (Lycée Agricole Louis Pasteur)\n- José De Castro\nhttps://github.com/KELLERStephane/KELLER-Stephane-Tests2maths\n\nAffichage de la température et de l'humidité sur l'écran\n\nQue soutaitez-vous installer ?" 18 72 2 \
                        "1" "Affichage permanent  "\
                        "2" "Affichage ponctuel via un interrupteur " 3>&1 1>&2 2>&3)

                        exitstatus=$?

                        if [[ $exitstatus = 0 ]]; then
                            echo -e -n "${jauneclair}\t =======================================  \n ${neutre}"
                            echo -e -n "${jauneclair}\t L'affichage sera le suivant              \n ${neutre}"
                            echo -e -n "${jauneclair}\t $CHOIX_CAPTEUR                           \n ${neutre}"
                            echo -e -n "${jauneclair}\t =======================================  \n ${neutre}"

                            echo -e "${bleuclair}\nInstallation de l'écran Kuman ${neutre}"
                            echo -e "${rougeclair}Domoticz, GPIO et DHT22 doivent être installés. ${neutre}"
                            echo -e "${rougeclair}Le capteur DHT22 et l'écran Kuman doivent être reliés correctement au Raspberry : ${neutre}"
                            echo -e "${rougeclair}Ne pas oublier d'activer les GPIO avec sudo raspi-config ${neutre}"
                            echo -e "${rougeclair}Ne pas oublier d'activer I2C avec sudo raspi-config ${neutre}"

                            if [ -d "/home/$utilisateur/script/Adafruit_Python_SSD1306" ]; then
                                echo -e "${cyanclair}Le répertoire d'installation /home/$utilisateur/script/Adafruit_Python_SSD1306 existe déjà. Suppression du répertoire avant la nouvelle installation ${neutre}"
                                rm -r /home/$utilisateur/script/Adafruit_Python_SSD1306
                            fi
                            if [ -f "/usr/share/fonts/truetype/Minecraftia/Minecraftia-Regular.ttf" ] ; then
                                echo -e "${cyanclair}\nLe répertoire /usr/share/fonts/truetype/Minecraftia existe déjà. Suppression du répertoire avant la nouvelle installation ${neutre}"
                                rm -r /usr/share/fonts/truetype/Minecraftia
                            fi
                            #Téléchargement et décompactage de la police pour l'écran
                            echo -e "${cyanclair}\nTéléchargement du fichier /usr/share/fonts/truetype/Minecraftia/Minecraftia-Regular.ttf ${neutre}"
                            mkdir /usr/share/fonts/truetype/Minecraftia >/dev/null
                            wget -P /usr/share/fonts/truetype/Minecraftia/ $lien_github_zip/minecraftia.zip
                            cd /usr/share/fonts/truetype/Minecraftia/
                            unzip -u minecraftia.zip
                            rm /usr/share/fonts/truetype/Minecraftia/minecraftia.zip*

                            #Téléchargement des bibliothèques et des fichiers
                            cd /home/$utilisateur/script
                            echo -e "${bleuclair}\nInstallation des bilbiothèques AdaFruit pour l'écran Kuman (nécessite Domoticz et DHT22) ${neutre}"
                            git clone https://github.com/adafruit/Adafruit_Python_SSD1306.git
                            chown $utilisateur:$utilisateur /home/$utilisateur/script/Adafruit_Python_SSD1306

                            apt·install·-y·python-smbus·i2c-tools
                            version=$(python --version 2>&1 | cut -c1-8)
                            echo -e -n "${vertclair}\nVersion de Python par défaut : ${neutre}"
                            echo -e $version
                            if [[ $version =~ "Python 3" ]]; then
                                #installation si Python3
                                cd /home/$utilisateur/script/Adafruit_Python_SSD1306
                                python3 setup.py install
                            else
                                #installation si Python2
                                cd /home/$utilisateur/script/Adafruit_Python_SSD1306
                                python setup.py install
                            fi

                            if [[ $CHOIX_KUMAN =~ "1" ]]; then
                                if [ -f "/home/$utilisateur/script/Kuman.py" ] ; then
                                    echo -e "${cyanclair}\nLe fichier /home/$utilisateur/script/Kuman.py existe déjà${neutre}"
                                    echo -e "${cyanclair}Effacement du fichier puis téléchargement du nouveau fichier ${neutre}"
                                    rm /home/$utilisateur/script/Kuman.py
                                fi
                                echo -e "${vertclair}\nTéléchargement du fichier kuman.py ${neutre}"
                                wget -P /home/$utilisateur/script $lien_github_raw/Kuman.py
                                chown $utilisateur:$utilisateur /home/$utilisateur/script/Kuman.py
                                chmod +x /home/$utilisateur/script/Kuman.py

                                if [ -f "/etc/systemd/system/interrupteur_kuman.service" ] ; then
                                    echo -e "${cyanclair}\nLe fichier /etc/systemd/system/interrupteur_kuman.service existe ${neutre}"
                                    echo -e "${cyanclair}et n'est plus nécessaire. Suppression du service ${neutre}"
                                    systemctl disable interrupteur_kuman.service
                                    rm /etc/systemd/system/interrupteur_kuman.service*
                                fi

                                #Modification de la crontab pour Affichage de la température et humidité toutes les 10 minutes
                                crontab -u root -l > /tmp/toto.txt # export de la crontab
                                grep -i "Kuman.py" "/tmp/toto.txt" >/dev/null
                                if [ $? = 0 ];then
                                    echo -e "${vertclair}\nLa crontab a déja été modifiée ${neutre}"
                                 else
                                    echo -e "${vertclair}\nModification de la crontab ${neutre}"
                                    echo -e "\n#Kuman Affichage permanent de la température et de l'humidité" >> /tmp/toto.txt # ajout de la ligne dans le fichier temporaire
                                    echo -e "*/10 * * * * cd /home/$utilisateur/script && python Kuman.py" >> /tmp/toto.txt # ajout de la ligne dans le fichier temporaire
                                    crontab /tmp/toto.txt # import de la crontab
                                    rm /tmp/toto.txt* # le fichier temporaire ne sert plus à rien
                                fi
                            fi

                            if [[ $CHOIX_KUMAN =~ "2" ]]; then
                                echo -e "${rougeclair}DHT22 et GPIO doivent être installés et l'interrupteur relié au Raspberry ${neutre}"
                                echo -e "${rougeclair}Il faut connaître et renseigner le numéro GPIO BCM ${neutre}"
                                echo -e "${rougeclair}sur lequel est relié l'interrupteur. ${neutre}"

                                #Ajout du service interrupteur_kuman
                                if [ -f "/etc/systemd/system/interrupteur_kuman.service" ] ; then
                                    echo -e "${cyanclair}\nLe fichier /etc/systemd/system/interrupteur_kuman.service existe déjà ${neutre}"
                                    echo -e "${cyanclair}Suppression du service puis téléchargement du nouveau fichier ${neutre}"
                                    systemctl stop interrupteur_kuman.service
                                    systemctl disable interrupteur_kuman.service
                                    rm /etc/systemd/system/interrupteur_kuman.service
                                fi
                                echo -e "${vertclair}\nTéléchargement du fichier interrupteur_kuman.service ${neutre}"
                                wget -P /etc/systemd/system $lien_github_raw/interrupteur_kuman.service
                                chown $utilisateur:$utilisateur /etc/systemd/system/interrupteur_kuman.service
                                echo -e "${vertclair}\nActivation et démarrage du service interrupteur.service ${neutre}"
                                systemctl enable interrupteur_kuman.service
                                systemctl start interrupteur_kuman.service

                                #Téléchargment du fichier interrupteur_kuman.py
                                if [ -f "/home/$utilisateur/script/interrupteur_kuman.py" ] ; then
                                    echo -e "${cyanclair}Le fichier /home/$utilisateur/script/interrupteur_kuman.py existe déjà ${neutre}"
                                    echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
                                    rm /home/$utilisateur/script/interrupteur_kuman.py*
                                fi
                                echo -e "${vertclair}\nTéléchargement du fichier interrupteur_kuman.py ${neutre}"
                                wget -P /home/$utilisateur/script $lien_github_raw/interrupteur_kuman.py
                                chown $utilisateur:$utilisateur /home/$utilisateur/script/interrupteur_kuman.py
                                chmod +x /home/$utilisateur/script/interrupteur_kuman.py

                                #Modification du fichier interrupteur_kuman.py en renseignant le numéro de GPIO BCM
                                echo -e "${vertclair}\nAjout du GPIO (BCM) dans le fichier interrupteur.py ${neutre}"

                                boucle=true
                                while $boucle;do
                                    BCM=$(whiptail --title "Paramètres pour l'interupteur" --inputbox "\nSaisir le GPIO (BCM) de l'interrupteur : " 10 60 3>&1 1>&2 2>&3)
                                    exitstatus=$?
                                    if [ $exitstatus = 0 ]; then
                                        echo -e "${vertclair}Modification du fichier interrupteur_kuman.py en ajoutant le numéro de GPIO (BCM) ${neutre}"
                                        L1="BCM ="
                                        L2="BCM = "
                                        L3=$BCM
                                        sed -i '/'"$L1"'/ c\'"$L2"''"$L3"'' /home/$utilisateur/script/interrupteur_kuman.py
                                        boucle=false
                                    else
                                        echo "Tu as annulé... Recommence :-("
                                    fi
                                done
                                echo -e "${vertclair}\nAjout du GPIO (BCM) dans le fichier interrupteur_kuman.py ${neutre}"

                                #Modification de la crontab pour supprimer affichage permanent de la température et humidité
                                crontab -u root -l > /tmp/toto.txt # export de la crontab
                                grep -i "Kuman.py" "/tmp/toto.txt" >/dev/null
                                if [ $? = 0 ];then
                                    echo -e "${vertclair}\nSuppression de l'affichage permanent dans la crontab ${neutre}"
                                    L1="#Kuman Affichage permanent de la température et de l'humidité"
                                    L2=''
                                    sed -i '/'"$L1"'/ c\'"$L2"'' /tmp/toto.txt
                                    L3='Kuman.py'
                                    L4=''
                                    sed -i '/'"$L3"'/ c\'"$L4"'' /tmp/toto.txt
                                    crontab /tmp/toto.txt # import de la crontab
                                    rm /tmp/toto.txt* # le fichier temporaire ne sert plus à rien
                                fi
                            fi

                            if [[ $CHOIX_CAPTEUR =~ "Debug" ]]; then
                                    echo -e "${violetclair}\nFin de l'installation de l'écran Kuman. Appuyer sur Entrée pour poursuivre l'Installation ${neutre}"
                                read
                            fi

                        fi
                    fi

                    ### ===============================================================
                    ### Ecran LCD RGB Backlight pour affichage données DHT22
                    ### ===============================================================

                    if [[ $CHOIX_CAPTEUR =~ "LCD" ]]; then
                        CHOIX_LCD=$(whiptail --title "Menu d'installation de l'écran LCD RGB Backlight" --menu \
                        "\nScript réalisé par :\n- KELLER Stéphane (Lycée Agricole Louis Pasteur)\n- José De Castro\nhttps://github.com/KELLERStephane/KELLER-Stephane-Tests2maths\n\nAffichage de la température et de l'humidité sur l'écran\n\nQue soutaitez-vous installer ?" 18 72 2 \
                        "1" "Affichage permanent  "\
                        "2" "Affichage ponctuel via un interrupteur " 3>&1 1>&2 2>&3)

                        exitstatus=$?

                        if [[ $exitstatus = 0 ]]; then
                            echo -e -n "${jauneclair}\t =======================================  \n ${neutre}"
                            echo -e -n "${jauneclair}\t L'affichage sera le suivant              \n ${neutre}"
                            echo -e -n "${jauneclair}\t $CHOIX_LCD                               \n ${neutre}"
                            echo -e -n "${jauneclair}\t =======================================  \n ${neutre}"

                            echo -e "${bleuclair}\nInstallation de l'écran LCD RGB Backlight ${neutre}"
                            echo -e "${rougeclair}Domoticz, GPIO et DHT22 doivent être installés. ${neutre}"
                            echo -e "${rougeclair}Le capteur DHT22 et l'écran LCD doivent être reliés correctement au Raspberry : ${neutre}"
                            echo -e "${rougeclair}Ne pas oublier d'activer les GPIO avec sudo raspi-config ${neutre}"
                            echo -e "${rougeclair}Ne pas oublier d'activer I2C avec sudo raspi-config ${neutre}"

                            #Téléchargement des bibliothèques et des fichiers
                            cd /home/$utilisateur/script
                            apt install -y python-smbus i2c-tools

                            ### ===============================================================
                            ### Affichage permanent données DHT22 sur écran LCD RGB Backlight
                            ### ===============================================================

                            if [[ $CHOIX_LCD =~ "1" ]]; then
                                if [ -f "/home/$utilisateur/script/lcd.py" ] ; then
                                    echo -e "${cyanclair}\nLe fichier /home/$utilisateur/script/lcd.py existe déjà${neutre}"
                                    echo -e "${cyanclair}Effacement du fichier puis téléchargement du nouveau fichier ${neutre}"
                                    rm /home/$utilisateur/script/lcd.py
                                fi
                                echo -e "${vertclair}\nTéléchargement du fichier lcd.py ${neutre}"
                                wget -P /home/$utilisateur/script $lien_github_raw/lcd.py
                                chown $utilisateur:$utilisateur /home/$utilisateur/script/lcd.py
                                chmod +x /home/$utilisateur/script/lcd.py

                                if [ -f "/etc/systemd/system/interrupteur_lcd.service" ] ; then
                                    echo -e "${cyanclair}\nLe fichier /etc/systemd/system/interrupteur_lcd.service existe ${neutre}"
                                    echo -e "${cyanclair}et n'est plus nécessaire. Suppression du service ${neutre}"
                                    systemctl stop interrupteur_lcd.service
                                    systemctl disable interrupteur_lcd.service
                                    rm /etc/systemd/system/interrupteur_lcd.service*
                                fi

                                #Modification de la crontab pour Affichage de la température et humidité toutes les 10 minutes
                                crontab -u root -l > /tmp/toto.txt # export de la crontab
                                grep -i "lcd.py" "/tmp/toto.txt" >/dev/null
                                if [ $? = 0 ];then
                                    echo -e "${vertclair}\nLa crontab a déja été modifiée ${neutre}"
                                 else
                                    echo -e "${vertclair}\nModification de la crontab ${neutre}"
                                    echo -e "\n#LCD Affichage permanent de la température et de l'humidité" >> /tmp/toto.txt # ajout de la ligne dans le fichier temporaire
                                    echo -e "*/10 * * * * cd /home/$utilisateur/script && python lcd.py" >> /tmp/toto.txt # ajout de la ligne dans le fichier temporaire
                                    crontab /tmp/toto.txt # import de la crontab
                                    rm /tmp/toto.txt* # le fichier temporaire ne sert plus à rien
                                fi
                            fi

                            ### ===============================================================
                            ### Affichage ponctuel données DHT22 sur écran LCD RGB Backlight
                            ### ===============================================================

                            if [[ $CHOIX_LCD =~ "2" ]]; then
                                echo -e "${rougeclair}DHT22 et GPIO doivent être installés et l'interrupteur relié au Raspberry ${neutre}"
                                echo -e "${rougeclair}Il faut connaître et renseigner le numéro GPIO BCM ${neutre}"
                                echo -e "${rougeclair}sur lequel est relié l'interrupteur. ${neutre}"

                                #Ajout du service interrupteur_lcd
                                if [ -f "/etc/systemd/system/interrupteur_lcd.service" ] ; then
                                    echo -e "${cyanclair}\nLe fichier /etc/systemd/system/interrupteur_lcd.service existe déjà ${neutre}"
                                    echo -e "${cyanclair}Suppression du service puis téléchargement du nouveau fichier ${neutre}"
                                    systemctl stop interrupteur_lcd.service
                                    systemctl disable interrupteur_lcd.service
                                    rm /etc/systemd/system/interrupteur_lcd.service
                                fi
                                wget -P /etc/systemd/system/ $lien_github_raw/interrupteur_lcd.service
                                echo -e "${cyanclair}Activation et démarrage du service /etc/systemd/system/interrupteur_lcd.service ${neutre}"
                                systemctl enable interrupteur_lcd.service
                                systemctl start interrupteur_lcd.service

                                #Téléchargement du fichier interrupteur_lcd.py
                                echo -e "${vertclair}\nTéléchargement du fichier interrupteur_lcd.py ${neutre}"
                                if [ -f "/home/$utilisateur/script/interrupteur_lcd.py" ] ; then
                                    echo -e "${cyanclair}Le fichier /home/$utilisateur/script/interrupteur_lcd.py existe déjà ${neutre}"
                                    echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
                                    rm /home/$utilisateur/script/interrupteur_lcd.py*
                                fi
                                echo -e "${vertclair}\nTéléchargement du fichier interrupteur_lcd.py ${neutre}"
                                wget -P /home/$utilisateur/script $lien_github_raw/interrupteur_lcd.py
                                chown $utilisateur:$utilisateur /home/$utilisateur/script/interrupteur_lcd.py
                                chmod +x /home/$utilisateur/script/interrupteur_lcd.py

                                #Modification du fichier interrupteur_lcd.py en renseignant le numéro de GPIO BCM
                                echo -e "${vertclair}\nAjout du GPIO (BCM) dans le fichier interrupteur_lcd.py ${neutre}"

                                boucle=true
                                while $boucle;do
                                    BCM=$(whiptail --title "Paramètres pour l'interupteur" --inputbox "\nSaisir le GPIO (BCM) de l'interrupteur : " 10 60 3>&1 1>&2 2>&3)
                                    exitstatus=$?
                                    if [ $exitstatus = 0 ]; then
                                        echo -e "${vertclair}Modification du fichier interrupteur_lcd.py en ajoutant le numéro de GPIO (BCM) ${neutre}"
                                        L1="BCM ="
                                        L2="BCM = "
                                        L3=$BCM
                                        sed -i '/'"$L1"'/ c\'"$L2"''"$L3"'' /home/$utilisateur/script/interrupteur_lcd.py
                                        boucle=false
                                    else
                                        echo "Tu as annulé... Recommence :-("
                                    fi
                                done
                                echo -e "${vertclair}\nAjout du GPIO (BCM) dans le fichier interrupteur_lcd.py ${neutre}"

                                #Modification de la crontab pour supprimer affichage permanent de la température et humidité
                                crontab -u root -l > /tmp/toto.txt # export de la crontab
                                grep -i "lcd.py" "/tmp/toto.txt" >/dev/null
                                if [ $? = 0 ];then
                                    echo -e "${vertclair}\nSuppression de l'affichage permanent dans la crontab ${neutre}"
                                    L1="#DHT22 Affichage permanent de la température et de l'humidité"
                                    L2=''
                                    sed -i '/'"$L1"'/ c\'"$L2"'' /tmp/toto.txt
                                    L3='lcd.py'
                                    L4=''
                                    sed -i '/'"$L3"'/ c\'"$L4"'' /tmp/toto.txt
                                    crontab /tmp/toto.txt # import de la crontab
                                    rm /tmp/toto.txt* # le fichier temporaire ne sert plus à rien
                                fi
                            fi

                            if [[ $CHOIX_CAPTEUR =~ "Debug" ]]; then
                                    echo -e "${violetclair}\nFin de l'installation de l'écran LCD RGB Backlight. Appuyer sur Entrée pour poursuivre l'Installation ${neutre}"
                                read
                            fi
                        fi
                    fi

                    ### ===============================================================
                    ### Ecran SPI pour affichage données DHT22 et AM2315
                    ### ===============================================================

                    if [[ $CHOIX_CAPTEUR =~ "SPI" ]]; then
                        CHOIX_SPI=$(whiptail --title "Menu d'installation de l'écran SPI" --menu \
                        "\nScript réalisé par :\n- KELLER Stéphane (Lycée Agricole Louis Pasteur)\n- José De Castro\nhttps://github.com/KELLERStephane/KELLER-Stephane-Tests2maths\n\nAffichage de la température et de l'humidité sur l'écran\n\nQue soutaitez-vous installer ?" 18 72 2 \
                        "1" "Affichage permanent  "\
                        "2" "Affichage ponctuel via un interrupteur " 3>&1 1>&2 2>&3)

                        exitstatus=$?

                        if [[ $exitstatus = 0 ]]; then
                            echo -e -n "${jauneclair}\t =======================================  \n ${neutre}"
                            echo -e -n "${jauneclair}\t L'affichage sera le suivant              \n ${neutre}"
                            echo -e -n "${jauneclair}\t $CHOIX_CAPTEUR                           \n ${neutre}"
                            echo -e -n "${jauneclair}\t =======================================  \n ${neutre}"

                            echo -e "${bleuclair}\nInstallation de l'écran SPI ${neutre}"
                            echo -e "${rougeclair}Domoticz, GPIO et DHT22 doivent être installés. ${neutre}"
                            echo -e "${rougeclair}Les capteurs DHT22 et AM2315 ainsiq que l'écran SPI doivent être reliés correctement au Raspberry : ${neutre}"
                            echo -e "${rougeclair}Ne pas oublier d'activer les GPIO avec sudo raspi-config ${neutre}"
                            echo -e "${rougeclair}Ne pas oublier d'activer SPI avec sudo raspi-config ${neutre}"

                            #Téléchargement des bibliothèques et des fichiers
                            if [ -d "/home/$utilisateur/script/Python_ST7735" ]; then
                                echo -e "${cyanclair}Le répertoire d'installation /home/$utilisateur/script/Python_ST7735 existe déjà. Suppression du répertoire avant la nouvelle installation ${neutre}"
                                rm -r /home/$utilisateur/script/Python_ST7735
                            fi
                            cd /home/$utilisateur/script/
                            echo -e "${bleuclair}\nInstallation des bilbiothèques pour l'écran SPI (nécessite Domoticz et DHT22) ${neutre}"
                            git clone https://github.com/cskau/Python_ST7735
                            cd /home/$utilisateur/script/Python_ST7735

                            if [ -f "/usr/share/fonts/truetype/Minecraftia/Minecraftia-Regular.ttf" ] ; then
                                echo -e "${cyanclair}\nLe répertoire /usr/share/fonts/truetype/Minecraftia existe déjà. Suppression du répertoire avant la nouvelle installation ${neutre}"
                                rm -r /usr/share/fonts/truetype/Minecraftia
                            fi

                            #Téléchargement et décompactage de la police pour l'écran
                            echo -e "${cyanclair}\nTéléchargement du fichier /usr/share/fonts/truetype/Minecraftia/Minecraftia-Regular.ttf ${neutre}"
                            mkdir /usr/share/fonts/truetype/Minecraftia >/dev/null
                            wget -P /usr/share/fonts/truetype/Minecraftia/ $lien_github_zip/minecraftia.zip
                            cd /usr/share/fonts/truetype/Minecraftia/
                            unzip -u minecraftia.zip
                            rm /usr/share/fonts/truetype/Minecraftia/minecraftia.zip*

                            #Téléchargement et décompactage des images météos
                            if [ -f "/home/$utilisateur/script/Python_ST7735/meteo_BVR/" ] ; then
                                echo -e "${cyanclair}\nLe répertoire /home/$utilisateur/script/Python_ST7735/meteo_BVR existe déjà. Suppression du répertoire avant la nouvelle installation ${neutre}"
                                rm -r /home/$utilisateur/script/Python_ST7735/meteo_BVR/      
                            fi
                            echo -e "${cyanclair}\nTéléchargement des images météos ${neutre}"
                             mkdir /home/$utilisateur/script/Python_ST7735/meteo_BVR  >/dev/null
                            cd /home/$utilisateur/script/Python_ST7735/meteo_BVR/
                            wget -P /home/$utilisateur/script/Python_ST7735/meteo_BVR/ $lien_github_zip/meteo_BVR.zip
                            unzip -u meteo_BVR.zip
                            rm -r /home/$utilisateur/script/Python_ST7735/meteo_BVR/meteo_BVR.zip*

                            #Téléchargement et décompactage des images lunaires pour l'écran
                            if [ -f "/home/$utilisateur/script/Python_ST7735/moons_BVR/" ] ; then
                                echo -e "${cyanclair}\nLe répertoire /home/$utilisateur/script/Python_ST7735/moons_BVR existe déjà. Suppression du répertoire avant la nouvelle installation ${neutre}"
                                rm -r /home/$utilisateur/script/Python_ST7735/moons_BVR/
                            fi
                            echo -e "${cyanclair}\nTéléchargement des images lunaires ${neutre}"
                            mkdir /home/$utilisateur/script/Python_ST7735/moons_BVR  >/dev/null
                            cd /home/$utilisateur/script/Python_ST7735/moons_BVR/
                            wget -P /home/$utilisateur/script/Python_ST7735/moons_BVR/ $lien_github_zip/moons_BVR.zip
                            unzip -u moons_BVR.zip
                            rm -r /home/$utilisateur/script/Python_ST7735/moons_BVR/moons_BVR.zip*

                            apt install -y build-essential python-dev python-smbus
                            version=$(python --version 2>&1 | cut -c1-8)
                            echo -e -n "${vertclair}\nVersion de Python par défaut : ${neutre}"
                            echo -e $version
                            if [[ $version =~ "Python 3" ]]; then
                                #installation si Python3
                                sudo pip3 install Adafruit_GPIO
                                cd /home/$utilisateur/script/Python_ST7735
                                python3 setup.py install
                                sudo pip3 install lune
                            else
                                #installation si Python2
                                sudo pip install Adafruit_GPIO
                                cd /home/$utilisateur/script/Python_ST7735
                                python setup.py install
                                sudo pip install lune
                            fi

                            ### ===============================================================
                            ### Affichage permanent données DHT22 et AM2315 sur écran SPI
                            ### ===============================================================

                            if [[ $CHOIX_SPI =~ "1" ]]; then
                                if [ -f "/home/$utilisateur/script/st7735.py" ] ; then
                                    echo -e "${cyanclair}\nLe fichier /home/$utilisateur/script/st7735.py existe déjà${neutre}"
                                    echo -e "${cyanclair}Effacement du fichier puis téléchargement du nouveau fichier ${neutre}"
                                    rm /home/$utilisateur/script/st7735.py
                                fi
                                echo -e "${vertclair}\nTéléchargement du fichier st7735.py ${neutre}"
                                wget -P /home/$utilisateur/script $lien_github_raw/st7735.py
                                chown $utilisateur:$utilisateur /home/$utilisateur/script/st7735.py
                                chmod +x /home/$utilisateur/script/st7735.py

                                if [ -f "/etc/systemd/system/interrupteur_spi.service" ] ; then
                                    echo -e "${cyanclair}\nLe fichier /etc/systemd/system/interrupteur_spi.service existe ${neutre}"
                                    echo -e "${cyanclair}et n'est plus nécessaire. Suppression du service ${neutre}"
                                    systemctl stop interrupteur_spi.service
                                    systemctl disable interrupteur_spi.service
                                    rm /etc/systemd/system/interrupteur_spi.service*
                                fi

                                #Modification de la crontab pour Affichage de la température et humidité toutes les 10 minutes
                                crontab -u root -l > /tmp/toto.txt # export de la crontab
                                grep -i "st7735.py" "/tmp/toto.txt" >/dev/null
                                if [ $? = 0 ];then
                                    echo -e "${vertclair}\nLa crontab a déja été modifiée ${neutre}"
                                 else
                                    echo -e "${vertclair}\nModification de la crontab ${neutre}"
                                    echo -e "\n#ST7735 Affichage permanent de la température et de l'humidité toutes les 10 mn chaque jour" >> /tmp/toto.txt # ajout de la ligne dans le fichier temporaire
                                    echo -e "*/10 * * * * cd /home/$utilisateur/script && python st7735.py" >> /tmp/toto.txt # ajout de la ligne dans le fichier temporaire
                                    crontab /tmp/toto.txt # import de la crontab
                                    rm /tmp/toto.txt* # le fichier temporaire ne sert plus à rien
                                fi
                            fi

                            ### ===============================================================
                            ### Affichage ponctuel données DHT22 et AM2315 sur écran SPI
                            ### ===============================================================

                            if [[ $CHOIX_SPI =~ "2" ]]; then
                                echo -e "${rougeclair}DHT22, AM2315 et GPIO doivent être installés et l'interrupteur relié au Raspberry ${neutre}"
                                echo -e "${rougeclair}Il faut connaître et renseigner le numéro GPIO BCM ${neutre}"
                                echo -e "${rougeclair}sur lequel est relié l'interrupteur. ${neutre}"

                                #Ajout du service interrupteur_spi
                                if [ -f "/etc/systemd/system/interrupteur_spi.service" ] ; then
                                    echo -e "${cyanclair}\nLe fichier /etc/systemd/system/interrupteur_spi.service existe déjà ${neutre}"
                                    echo -e "${cyanclair}Suppression du service puis téléchargement du nouveau fichier ${neutre}"
                                    systemctl stop interrupteur_spi.service
                                    systemctl disable interrupteur_spi.service
                                    rm /etc/systemd/system/interrupteur_spi.service
                                fi
                                wget -P /etc/systemd/system/ $lien_github_raw/interrupteur_spi.service
                                echo -e "${cyanclair}Activation et démarrage du service /etc/systemd/system/interrupteur_spi.service ${neutre}"
                                systemctl enable interrupteur_spi.service
                                systemctl start interrupteur_spi.service

                                #Téléchargement du fichier interrupteur_spi.py
                                echo -e "${vertclair}\nTéléchargement du fichier interrupteur_spi.py ${neutre}"
                                if [ -f "/home/$utilisateur/script/interrupteur_spi.py" ] ; then
                                    echo -e "${cyanclair}Le fichier /home/$utilisateur/script/interrupteur_spi.py existe déjà ${neutre}"
                                    echo -e "${cyanclair}Effacement du fichier puis création du nouveau fichier ${neutre}"
                                    rm /home/$utilisateur/script/interrupteur_spi.py*
                                fi
                                echo -e "${vertclair}\nTéléchargement du fichier interrupteur_spi.py ${neutre}"
                                wget -P /home/$utilisateur/script $lien_github_raw/interrupteur_spi.py
                                chown $utilisateur:$utilisateur /home/$utilisateur/script/interrupteur_spi.py
                                chmod +x /home/$utilisateur/script/interrupteur_spi.py

                                #Modification du fichier interrupteur_spi.py en renseignant le numéro de GPIO BCM
                                echo -e "${vertclair}\nAjout du GPIO (BCM) dans le fichier interrupteur_spi.py ${neutre}"

                                boucle=true
                                while $boucle;do
                                    BCM=$(whiptail --title "Paramètres pour l'interupteur" --inputbox "\nSaisir le GPIO (BCM) de l'interrupteur : " 10 60 3>&1 1>&2 2>&3)
                                    exitstatus=$?
                                    if [ $exitstatus = 0 ]; then
                                        echo -e "${vertclair}Modification du fichier interrupteur_spi.py en ajoutant le numéro de GPIO (BCM) ${neutre}"
                                        L1="BCM ="
                                        L2="BCM = "
                                        L3=$BCM
                                        sed -i '/'"$L1"'/ c\'"$L2"''"$L3"'' /home/$utilisateur/script/interrupteur_spi.py
                                        boucle=false
                                    else
                                        echo "Tu as annulé... Recommence :-("
                                    fi
                                done
                                echo -e "${vertclair}\nAjout du GPIO (BCM) dans le fichier interrupteur_spi.py ${neutre}"

                                #Modification de la crontab pour supprimer affichage permanent de la température et humidité
                                crontab -u root -l > /tmp/toto.txt # export de la crontab
                                grep -i "st7735.py" "/tmp/toto.txt" >/dev/null
                                if [ $? = 0 ];then
                                    echo -e "${vertclair}\nSuppression de l'affichage permanent dans la crontab ${neutre}"
                                    L1="#ST7735 Affichage permanent de la température et de l'humidité"
                                    L2=''
                                    sed -i '/'"$L1"'/ c\'"$L2"'' /tmp/toto.txt
                                    L3='st7735.py'
                                    L4=''
                                    sed -i '/'"$L3"'/ c\'"$L4"'' /tmp/toto.txt
                                    crontab /tmp/toto.txt # import de la crontab
                                    rm /tmp/toto.txt* # le fichier temporaire ne sert plus à rien
                                fi
                            fi

                            if [[ $CHOIX_CAPTEUR =~ "Debug" ]]; then
                                echo -e "${violetclair}\nFin de l'installation de l'écran SPI. Appuyer sur Entrée pour poursuivre l'Installation ${neutre}"
                                read
                            fi
                        fi
                    fi

                    ### ===============================================================
                    ### Désinstallation des capteurs et des programmes associés
                    ### ===============================================================

                    if [[ $CHOIX_CAPTEUR =~ "DEL" ]]; then
                        echo -e "${bleuclair}\nDésinstallation des capteurs et programmes associés ${neutre}"
                        boucle_efface=true
                        while $boucle_efface;do

                            CHOIX_DEL=$(NEWT_COLORS='
                            root=,blue
                            checkbox=white,brightblue
                            shadow=,black
                            ' \
                            whiptail --title "Menu de désinstallation des capteurs Raspberry" --checklist \
                            "\nScript réalisé par :\n- KELLER Stéphane (Lycée Agricole Louis Pasteur)\n- José De Castro\nhttps://github.com/KELLERStephane/KELLER-Stephane-Tests2maths\n\nQuels capteurs soutaitez-vous désinstaller ?" 22 72 8 \
                            "Debug" "Interruption à la fin de chaque installation " OFF \
                            "GrovePi" "GrovePI de Dexter Industries " OFF \
                            "DHT22" "Capteur de température et d'humidité DHT22 " OFF \
                            "DS18B20" "Capteur de température DS18B20 " OFF \
                            "AM2315" "Capteur de température et d'humidité AM2315 " OFF \
                            "Kuman" "Affichage données DHT22 sur écran Kuman " OFF \
                            "LCD" "Affichage données DHT22 sur écran LCD RGB Backlight" OFF \
                            "SPI" "Affichage données DHT22 sur écran bus SPI " OFF 3>&1 1>&2 2>&3)

                            exitstatus=$?

                            if [[ $exitstatus = 0 ]]; then
                                echo -e -n "${jauneclair}\t ==========================================  \n ${neutre}"
                                echo -e -n "${jauneclair}\t Les capteurs suivants seront désinstallés   \n ${neutre}"
                                echo -e -n "${jauneclair}\t $CHOIX_DEL                                  \n ${neutre}"
                                echo -e -n "${jauneclair}\t ==========================================  \n ${neutre}"

                                ### ===============================================================
                                ### DESINSTALLATION SHIELD GROVEPI
                                ### ===============================================================

                                if [[ $CHOIX_DEL =~ "GrovePi" ]]; then
                                    echo -e "${bleuclair}\nDésinstallation du shield GrovePi. ${neutre}"
                                    echo -e "${rougeclair}\nEn cours de construction. ${neutre}"

                                    if [[ $CHOIX_DEL =~ "Debug" ]]; then
                                        echo -e "${violetclair}\nFin de la désinstallation du shield GrovePi. Appuyer sur Entrée pour poursuivre. ${neutre}"
                                        read
                                    fi
                                fi

                                ### ===============================================================
                                ### DESINSTALLATION DU CAPTEUR DE TEMPERATURE DHT22
                                ### ===============================================================

                                if [[ $CHOIX_DEL =~ "DHT22" ]]; then
                                    echo -e "${bleuclair}\nDésinstallation du capteur de température et d'humidité DHT22. ${neutre}"
                                    if [ -d "/home/$utilisateur/script/Adafruit_Python_DHT" ]; then
                                        echo -e "${cyanclair}\nSuppression du répertoire d'installation /home/$utilisateur/script/Adafruit_Python_DHT. ${neutre}"
                                        rm -r /home/$utilisateur/script/Adafruit_Python_DHT
                                    fi
                                    if [ -f "/home/$utilisateur/script/dht22.py" ] ; then
                                        echo -e "${cyanclair}\nSuppression du fichier /home/$utilisateur/script/dht22.py ${neutre}" 
                                        rm /home/$utilisateur/script/dht22.py*
                                    fi
                                    if [ -f "/home/$utilisateur/script/data_dht22.txt" ] ; then
                                        echo -e "${cyanclair}\nSuppression du fichier /home/$utilisateur/script/data_dht22.txt ${neutre}"
                                        rm /home/$utilisateur/script/data_dht22.txt*
                                    fi

                                    #Modification de la crontab pour supprimer affichage de température et humidité toutes les 10 minutes
                                    crontab -u root -l > /tmp/toto.txt # export de la crontab
                                    grep -i "dht22.py" "/tmp/toto.txt" >/dev/null
                                    if [ $? = 0 ];then
                                        echo -e "${vertclair}\nModification de la crontab ${neutre}"
                                        L1="#DHT22 Affichage de la température et de l'humidité toutes les 10 mn chaque jour"
                                        L2=""
                                        sed -i '/'"$L1"'/ c\'"$L2"'' /tmp/toto.txt #suppression de la ligne L1 dans le fichier temporaire
                                        L3="python dht22.py"
                                        L4=""
                                        sed -i '/'"$L3"'/ c\'"$L4"'' /tmp/toto.txt #suppression de la ligne L3 dans le fichier temporaire
                                        crontab /tmp/toto.txt # import de la crontab
                                        rm /tmp/toto.txt* # le fichier temporaire ne sert plus à rien
                                    else
                                        echo -e "${vertclair}\nLa crontab a déja été modifiée ${neutre}"
                                    fi

                                    if [[ $CHOIX_DEL =~ "Debug" ]]; then
                                        echo -e "${violetclair}\nFin de la désinstallation du capteur de température et d'humidité DHT22. Appuyer sur Entrée pour poursuivre. ${neutre}"
                                        read
                                    fi
                                fi

                                ### ===============================================================
                                ### DESINSTALLATION DU CAPTEUR DE TEMPERATURE DS18B20
                                ### ===============================================================

                                if [[ $CHOIX_DEL =~ "DS18B20" ]]; then
                                    echo -e "${bleuclair}\nDésinstallation du capteur de température DS18B20. ${neutre}"
                                    if [ -f "/home/$utilisateur/script/ds18b20.py" ] ; then
                                        echo -e "${cyanclair}\nSuppression du fichier /home/$utilisateur/script/ds18b20.py ${neutre}"
                                        rm /home/$utilisateur/script/ds18b20.py*
                                    fi
                                    if [ -f "/home/$utilisateur/script/data_ds18b20.txt" ] ; then
                                        echo -e "${cyanclair}\nSuppression du fichier /home/$utilisateur/script/data_ds18b20.txt ${neutre}"
                                        rm /home/$utilisateur/script/data_ds18b20.txt*
                                    fi

                                    #Modification du fichier /boot/config.txt
                                    grep -i "dtoverlay=w1-gpio,gpiopin=" "/boot/config.txt" >/dev/null
                                    if [ $? = 0 ];then
                                        echo -e "${vertclair}\nModification du fichier /boot/config.txt ${neutre}"
                                        L1="dtoverlay=w1-gpio,gpiopin="
                                        L2="dtoverlay=w1-gpio"
                                        sed -i '/'"$L1"'/ c\'"$L2"'' /boot/config.txt #remplacement de la ligne L1 dans le fichier /boot/config.txt
                                    else
                                        echo -e "${vertclair}\nLe fichier /boot/config.txt a déja été modifié ${neutre}"
                                    fi

                                    #Modification du fichier /etc/modules
                                    grep -i "w1-therm" "/etc/modules" >/dev/null
                                    if [ $? = 0 ];then
                                        echo -e "${vertclair}\nModification du fichier /etc/modules ${neutre}"
                                        L1="w1-therm"
                                        L2=""
                                        sed -i '/'"$L1"'/ c\'"$L2"'' /etc/modules #remplacement de la ligne L1 dans le fichier /etc/modules
                                        L1="w1-gpio"
                                        L2=""
                                        sed -i '/'"$L1"'/ c\'"$L2"'' /etc/modules #remplacement de la ligne L1 dans le fichier /etc/modules
                                    else
                                        echo -e "${vertclair}\nLe fichier /etc/modules a déja été modifié ${neutre}"
                                    fi

                                    if [[ $CHOIX_DEL =~ "Debug" ]]; then
                                        echo -e "${violetclair}\nFin de la désinstallation du capteur de température DS18B20. Appuyer sur Entrée pour poursuivre. ${neutre}"
                                        read
                                    fi
                                fi

                                ### ===============================================================
                                ### DESINSTALLATION DU CAPTEUR DE TEMPERATURE AM2315
                                ### ===============================================================

                                if [[ $CHOIX_DEL =~ "AM2315" ]]; then
                                    echo -e "${bleuclair}\nDésinstallation du capteur de température et d'humidité AM2315. ${neutre}"
                                    if [ -f "/home/$utilisateur/script/am2315.py" ] ; then
                                        echo -e "${cyanclair}\nSuppression du fichier /home/$utilisateur/script/am2315.py ${neutre}"
                                        rm /home/$utilisateur/script/am2315.py*
                                    fi
                                    if [ -f "/home/$utilisateur/script/data_am2315.txt" ] ; then
                                        echo -e "${cyanclair}\nSuppression du fichier /home/$utilisateur/script/data_am2315.txt ${neutre}"
                                        rm /home/$utilisateur/script/data_am2315.txt*
                                    fi

                                    #Modification de la crontab pour supprimer affichage de température et humidité toutes les 10 minutes
                                    crontab -u root -l > /tmp/toto.txt # export de la crontab
                                    grep -i "am2315.py" "/tmp/toto.txt" >/dev/null
                                    if [ $? = 0 ];then
                                        echo -e "${vertclair}\nModification de la crontab ${neutre}"
                                        L1="#AM2315 Affichage de la température et de l'humidité toutes les 10 mn chaque jour"
                                        L2=""
                                        sed -i '/'"$L1"'/ c\'"$L2"'' /tmp/toto.txt #suppression de la ligne L1 dans le fichier temporaire
                                        L3="python am2315.py"
                                        L4=""
                                        sed -i '/'"$L3"'/ c\'"$L4"'' /tmp/toto.txt #suppression de la ligne L3 dans le fichier temporaire
                                        crontab /tmp/toto.txt # import de la crontab
                                        rm /tmp/toto.txt* # le fichier temporaire ne sert plus à rien
                                    else
                                        echo -e "${vertclair}\nLa crontab a déja été modifiée ${neutre}"
                                    fi

                                    if [[ $CHOIX_DEL =~ "Debug" ]]; then
                                        echo -e "${violetclair}\nFin de la désinstallation du capteur de température et d'humidité AM2315. Appuyer sur Entrée pour poursuivre. ${neutre}"
                                        read
                                    fi
                                fi

                                ### ===============================================================
                                ### DESINSTALLATION DE L'ECRAN KUMAN
                                ### ===============================================================

                                if [[ $CHOIX_DEL =~ "Kuman" ]]; then
                                    echo -e "${bleuclair}\nDésinstallation de l'écran Kuman. ${neutre}"

                                    if [ -d "/home/$utilisateur/script/Adafruit_Python_SSD1306" ]; then
                                        echo -e "${cyanclair}Suppression du répertoire d'installation /home/$utilisateur/script/Adafruit_Python_SSD1306. ${neutre}"
                                        rm -r /home/$utilisateur/script/Adafruit_Python_SSD1306
                                    fi
                                    if [ -f "/home/$utilisateur/script/Kuman.py" ] ; then
                                        echo -e "${cyanclair}\nSuppression du fichier /home/$utilisateur/script/Kuman.py ${neutre}"
                                        rm /home/$utilisateur/script/Kuman.py
                                    fi
                                    if [ -f "/etc/systemd/system/interrupteur_kuman.service" ] ; then
                                        echo -e "${cyanclair}\nSuppression du service /etc/systemd/system/interrupteur_kuman.service ${neutre}"
                                        systemctl disable interrupteur_kuman.service
                                        rm /etc/systemd/system/interrupteur_kuman.service*
                                    fi

                                    #Modification de la crontab pour supprimer affichage permanent de la température et humidité
                                    crontab -u root -l > /tmp/toto.txt # export de la crontab
                                    grep -i "Kuman.py" "/tmp/toto.txt" >/dev/null
                                    if [ $? = 0 ];then
                                        echo -e "${vertclair}\nSuppression de l'affichage permanent dans la crontab ${neutre}"
                                        L1="#Kuman Affichage permanent de la température et de l'humidité"
                                        L2=''
                                        sed -i '/'"$L1"'/ c\'"$L2"'' /tmp/toto.txt
                                        L3='Kuman.py'
                                        L4=''
                                        sed -i '/'"$L3"'/ c\'"$L4"'' /tmp/toto.txt
                                        crontab /tmp/toto.txt # import de la crontab
                                        rm /tmp/toto.txt* # le fichier temporaire ne sert plus à rien
                                    fi

                                    if [[ $CHOIX_DEL =~ "Debug" ]]; then
                                        echo -e "${violetclair}\nFin de la désinstallation de l'écran Kuman. Appuyer sur Entrée pour poursuivre. ${neutre}"
                                        read
                                    fi
                                fi

                                ### ===============================================================
                                ### DESINSTALLATION DE L'ECRAN LCD
                                ### ===============================================================

                                if [[ $CHOIX_DEL =~ "LCD" ]]; then
                                    echo -e "${bleuclair}\nDésinstallation de l'écran LCD. ${neutre}"
                                    echo -e "${rougeclair}\nEn cours de construction. ${neutre}"

                                    #Suppression du service interrupteur_lcd
                                    if [ -f "/etc/systemd/system/interrupteur_lcd.service" ] ; then
                                        echo -e "${cyanclair}\nSuppresson du fichier /etc/systemd/system/interrupteur_lcd.service ${neutre}"
                                        systemctl stop interrupteur_lcd.service
                                        systemctl disable interrupteur_lcd.service
                                        rm /etc/systemd/system/interrupteur_lcd.service
                                    fi
                                    if [ -f "/home/$utilisateur/script/interrupteur_lcd.py" ] ; then
                                        echo -e "${cyanclair}\nSuppression du fichier /home/$utilisateur/script/interrupteur_lcd.py ${neutre}"
                                        rm /home/$utilisateur/script/interrupteur_lcd.py*
                                    fi

                                    if [[ $CHOIX_DEL =~ "Debug" ]]; then
                                        echo -e "${violetclair}\nFin de la désinstallation de l'écran LCD. Appuyer sur Entrée pour poursuivre. ${neutre}"
                                        read
                                    fi
                                fi

                                ### ===============================================================
                                ### DESINSTALLATION DE L'ECRAN SPI
                                ### ===============================================================

                                if [[ $CHOIX_DEL =~ "SPI" ]]; then
                                    echo -e "${bleuclair}\nDésinstallation de l'écran SPI. ${neutre}"
                                    echo -e "${rougeclair}\nEn cours de construction. ${neutre}"


                                    if [[ $CHOIX_DEL =~ "Debug" ]]; then
                                        echo -e "${violetclair}\nFin de la désinstallation de l'écran SPI. Appuyer sur Entrée pour poursuivre. ${neutre}"
                                        read
                                    fi
                                fi


                            else
                                echo -e "${violetclair}\nFin de la désinstallation des capteurs. ${neutre}"
                                boucle_efface=false
                            fi
                        done
                    fi


                    ### ===============================================================
                    ### TEST DES CAPTEURS
                    ### ===============================================================

                    if [[ $CHOIX_CAPTEUR =~ "Tests" ]]; then
                        boucle_test=true
                        while $boucle_test;do
                            echo -e "${bleuclair}\nTests des capteurs : ${neutre}"
                            echo -e "${rougeclair}Les capteurs doivent être installés et reliés correctement au Raspberry ${neutre}"
                            echo -e "${rougeclair}Le Raspberry a été redémarré : ${neutre}"
                            echo -e "${rougeclair}GPIO, I2C, SPI et 1-wire doivent être activés si nécessaire avec sudo raspi-config ${neutre}"

                            cd /home/$utilisateur/script

                            CHOIX_TEST=$(NEWT_COLORS='
                            root=,blue
                            checkbox=white,black
                            ' \
                            whiptail --title "Menu de tests des capteurs" --checklist \
                            "\nScript réalisé par :\n- KELLER Stéphane (Lycée Agricole Louis Pasteur)\n- José De Castro\nhttps://github.com/KELLERStephane/KELLER-Stephane-Tests2maths\n\nQuel capteur soutaitez-vous tester ?" 23 72 9 \
                            "Debug" "Interruption à la fin de chaque installation " OFF \
                            "GrovePi" "Test du GrovePi de Dexter Industries " OFF \
                            "DHT22" "Test du capteur de température et d'humidité DHT22 " OFF \
                            "DS18B20" "Test du capteur de température DS18B20 " OFF \
                            "Kuman" "Test de l'écran Kuman " OFF \
                            "LCD" "Test de l'écran LCD RGB Backlight " OFF \
                            "SPI" "Test de l'écran bus SPI " OFF \
                            "IntKuman" "Test de l'interrupteur avec écran Kuman " OFF \
                            "IntLCD" "Test de l'interrupteur avec écran LCD" OFF 3>&1 1>&2 2>&3)

                            exitstatus=$?

                            if [[ $exitstatus = 0 ]]; then
                                echo -e -n "${jauneclair}\t =======================================  \n ${neutre}"
                                echo -e -n "${jauneclair}\t Les capteurs suivants seront testés      \n ${neutre}"
                                echo -e -n "${jauneclair}\t $CHOIX_TEST                              \n ${neutre}"
                                echo -e -n "${jauneclair}\t =======================================  \n ${neutre}"

                                ### ===============================================================
                                ### TEST DU SHILED GROVEPI
                                ### ===============================================================

                                if [[ $CHOIX_TEST =~ "GrovePi" ]]; then
                                    if [ ! -e /home/$utilisateur//Dexter/GrovePi/Troubleshooting ]; then
                                        echo -e "${vertclair}\nLe répertoire /home/$utilisateur/.........../GrovePi n'existe pas ${neutre}"
                                        echo -e "${vertclair}\nPoursuite des tests ${neutre}"
                                    else
                                        echo -e "${vertclair}\nTest de shield GrovePi ${neutre}"
                                        mkdir /home/$utilisateur/Desktop >/dev/null
                                        cd /home/$utilisateur/Dexter/GrovePi/Troubleshooting
                                        bash all_tests.sh
                                    fi
                                    if [[ $CHOIX_TEST =~ "Debug" ]]; then
                                        echo -e "${violetclair}\nFin du test du shield GrovePi. Appuyer sur Entrée pour poursuivre les tests ${neutre}"
                                        read
                                    fi

                                    if [[ $CHOIX_CAPTEUR =~ "Debug" ]]; then
                                        echo -e "${violetclair}\nFin de l'installation de GrovePi. Appuyer sur Entrée pour poursuivre l'Installation ${neutre}"
                                        read
                                    fi
                                fi

                                ### ===============================================================
                                ### TEST DU DHT22
                                ### ===============================================================

                                if [[ $CHOIX_TEST =~ "DHT22" ]]; then
                                    if [ ! -e /home/$utilisateur/script/dht22.py ]; then
                                        echo -e "${vertclair}\nLe fichier dht22.py n'existe pas ${neutre}"
                                        echo -e "${vertclair}\nPoursuite des tests ${neutre}"
                                    else
                                        echo -e "${vertclair}\nTest du capteur de température et d'humidité DHT22 ${neutre}"
                                        /home/$utilisateur/script/dht22.py
                                     fi
                                    if [[ $CHOIX_TEST =~ "Debug" ]]; then
                                        echo -e "${violetclair}\nFin du test du capteur de température et d'humidité DHT22. Appuyer sur Entrée pour poursuivre les tests ${neutre}"
                                        read
                                    fi
                                fi

                                ### ===============================================================
                                ### TEST DU DS18B20
                                ### ===============================================================

                                if [[ $CHOIX_TEST =~ "DS18B20" ]]; then
                                    if [ ! -e /home/$utilisateur/script/ds18b20.py ]; then
                                        echo -e "${vertclair}\nLe fichier ds18b20.py n'existe pas ${neutre}"
                                        echo -e "${vertclair}\nTéléchargement du fichier ds18b20.py ${neutre}"
                                    else
                                        echo -e "${vertclair}\nTest du capteur de température DS18B20 ${neutre}"
                                        /home/$utilisateur/script/ds18b20.py
                                    fi
                                    if [[ $CHOIX_TEST =~ "Debug" ]]; then
                                        echo -e "${violetclair}\nFin du test du capteur DS18B20. Appuyer sur Entrée pour poursuivre les tests ${neutre}"
                                        read
                                    fi
                                fi

                                ### ===============================================================
                                ### TEST DE L'ECRAN KUMAN
                                ### ===============================================================

                                if [[ $CHOIX_TEST =~ "Kuman" ]]; then
                                    echo -e "${vertclair}\nTest module i2c : ${neutre}"
                                    lsmod | grep i2c_
                                    echo -e "${vertclair}\nAffichage de l'adresse du (des) périphériques i2c : ${neutre}"
                                    i2cdetect -y 1
                                    if [ ! -e /home/$utilisateur/script/Kuman.py ]; then
                                        echo -e "${vertclair}\nLe fichier Kuman.py n'existe pas ${neutre}"
                                        echo -e "${vertclair}\nTéléchargement du fichier kuman.py ${neutre}"
                                        wget -P /home/$utilisateur/script $lien_github_raw/Kuman.py
                                        chown $utilisateur:$utilisateur /home/$utilisateur/script/Kuman.py
                                        chmod +x /home/$utilisateur/script/Kuman.py
                                    fi
                                    echo -e "${vertclair}\nTest de l'écran Kuman ${neutre}"
                                    /home/$utilisateur/script/Kuman.py
                                    if [[ $CHOIX_TEST =~ "Debug" ]]; then
                                        echo -e "${violetclair}\nFin du test de l'écran Kuman. Appuyer sur Entrée pour poursuivre les tests ${neutre}"
                                        read
                                    fi
                                fi

                                ### ===============================================================
                                ### TEST DE L'ECRAN LCD RGB Blacklight
                                ### ===============================================================

                                if [[ $CHOIX_TEST =~ "LCD" ]]; then
                                    echo -e "${vertclair}\nTest module i2c : ${neutre}"
                                    lsmod | grep i2c_
                                    echo -e "${vertclair}\nAffichage de l'adresse du (des) périphériques i2c : ${neutre}"
                                    i2cdetect -y 1
                                    if [ ! -e /home/$utilisateur/script/lcd.py ]; then
                                        echo -e "${vertclair}\nLe fichier lcd.py n'existe pas ${neutre}"
                                        echo -e "${vertclair}\nTéléchargement du fichier lcd.py ${neutre}"
                                        wget -P /home/$utilisateur/script $lien_github_raw/lcd.py
                                        chown $utilisateur:$utilisateur /home/$utilisateur/script/lcd.py
                                        chmod +x /home/$utilisateur/script/lcd.py
                                    fi
                                    echo -e "${vertclair}\nTest de l'écran LCD RGB Blacklight ${neutre}"
                                    /home/$utilisateur/script/lcd.py
                                    if [[ $CHOIX_TEST =~ "Debug" ]]; then
                                        echo -e "${violetclair}\nFin du test de l'écran LCD RGB Blacklight. Appuyer sur Entrée pour poursuivre les tests ${neutre}"
                                        read
                                    fi
                                fi

                                ### ===============================================================
                                ### TEST DE L'INTERRUPTEUR AVEC ECRAN KUMAN
                                ### ===============================================================

                                if [[ $CHOIX_TEST =~ "IntKuman" ]]; then
                                    if [ ! -e /home/$utilisateur/script/interrupteur_kuman.py ]; then
                                        echo -e "${vertclair}\nLe fichier interrupteur_kuman.py n'existe pas ${neutre}"
                                        echo -e "${vertclair}\nPoursuite des tests ${neutre}"
                                    else
                                        echo -e "${vertclair}\nTest de l'interrupteur avec l'écran Kuman ${neutre}"
                                        /home/$utilisateur/script/interrupteur_kuman.py
                                    fi
                                    if [[ $CHOIX_TEST =~ "Debug" ]]; then
                                        echo -e "${violetclair}\nFin du test de l'interrupteur. Appuyer sur Entrée poursuivre pour les tests ${neutre}"
                                        read
                                    fi
                                fi

                                ### ===============================================================
                                ### TEST DE L'INTERRUPTEUR AVEC ECRAN LCD RGB Blacklight
                                ### ===============================================================

                                if [[ $CHOIX_TEST =~ "IntLCD" ]]; then
                                    if [ ! -e /home/$utilisateur/script/interrupteur_lcd.py ]; then
                                        echo -e "${vertclair}\nLe fichier interrupteur_lcd.py n'existe pas ${neutre}"
                                        echo -e "${vertclair}\nPoursuite des tests ${neutre}"
                                    else
                                        echo -e "${vertclair}\nTest de l'interrupteur avec l'écran LCD ${neutre}"
                                        /home/$utilisateur/script/interrupteur_lcd.py
                                    fi
                                    if [[ $CHOIX_TEST =~ "Debug" ]]; then
                                        echo -e "${violetclair}\nFin du test de l'interrupteur. Appuyer sur Entrée pour poursuivre les tests ${neutre}"
                                        read
                                    fi
                                fi

                                ### ===============================================================
                                ### AUCUN CHOIX POUR LES TESTS
                                ### ===============================================================

                                if [[ $CHOIX_TEST =~ "" ]]; then
                                    echo -e "${violetclair}\nAucun test des capteurs. ${neutre}"
                                    exitstatus=1
                                    boucle_test=false
                                fi
                            else
                                echo -e "${violetclair}\nAnnulation du test des capteurs. ${neutre}"
                                boucle_test=false
                            fi
                        done
                    fi

                    ### ===============================================================
                    ### AUCUN CHOIX POUR LES CAPTEURS
                    ### ===============================================================

                    if [[ $CHOIX_CAPTEUR =~ "" ]]; then
                        echo -e "${violetclair}\nFin de l'installation des capteurs. ${neutre}"
                        exitstatus=1
                        boucle_capteur=false
                    fi
                else
                    echo -e "${violetclair}\nAnnulation de l'installation des capteurs. ${neutre}"
                    boucle_capteur=false
                fi
            done
        fi
    else
        echo -e "${violetclair}Annnulation de l'installation des logiciels. ${neutre}"
        boucle_principale=false
    fi
done

### ===============================================================
### Fin de l'installation
### ===============================================================

if [ -d "/etc/apache2" ]; then
    echo -e "${vertclair}Redémarrage du service Apache2 ${neutre}"
    /etc/init.d/apache2 restart
fi

if (whiptail --title "Redémarrage du Raspberry" --yesno "Voulez-vous redémarrer le raspberry.\n\nIl est obligatoire de le faire pour que les installations soient pris en compte." 10 60) then
    whiptail --title "Copyright" --msgbox "Script réalisé par KELLER Stéphane - Lycée Agricole Louis Pasteur\net José De Castro.\nhttps://github.com/KELLERStephane/KELLER-Stephane-Tests2maths\nCliquer sur Ok pour continuer." 10 70
    reboot
else
    echo -e "${bleuclair}\nAmusez vous bien. ${neutre}"
    whiptail --title "Copyright" --msgbox "Script réalisé par KELLER Stéphane - Lycée Agricole Louis Pasteur\net José De Castro.\nhttps://github.com/KELLERStephane/KELLER-Stephane-Tests2maths\nCliquer sur Ok pour continuer." 10 70
fi
