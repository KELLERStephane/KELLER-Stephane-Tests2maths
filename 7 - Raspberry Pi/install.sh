#!/bin/bash

### ===============================================================
### Script d'installation du Raspberry et des logiciels tiers
### Stéphane KELLER – Lycée Agricole Louis Pasteur
### ===============================================================

boucle=true
while "$boucle";do
        echo "Installation de Webmin (o/n) : "
        read repwebwin
        if [ $repwebwin = "o" ] || [ $repwebwin = "O" ]
        then
                echo "Webmin sera installé"
                boucle=false
        fi
        if [ $repwebwin = "n" ] || [ $repwebwin = "N" ]
        then
                echo "Webmin ne sera pas installé"
                boucle=false
        fi
done

boucle=true
while "$boucle";do
        echo "Installation de Motioneye (o/n) : "
        read repmotioneye
        if [ $repmotioneye = "o" ] || [ $repmotioneye = "O" ]
        then
                echo "Motioneye sera installé"
                boucle=false
        fi
        if [ $repmotioneye = "n" ] || [ $repmotioneye = "N" ]
        then
                echo "Motioneye ne sera pas installé"
                boucle=false
        fi
done

boucle=true
while "$boucle";do
        echo "Installation d'Apache2 (o/n) : "
        read repapache
        if [ $repapache = "o" ] || [ $repapache = "O" ]
        then
                echo "Apache2 sera installé"
                boucle=false
        fi
        if [ $repwebwin = "n" ] || [ $repwebwin = "N" ]
        then
                echo "Apache2 ne sera pas installé"
                boucle=false
        fi
done

boucle=true
while "$boucle";do
        echo "Installation de Domoticz (o/n) : "
        read repdomoticz
        if [ $repdomoticz = "o" ] || [ $repdomoticz = "O" ]
        then
                echo "Domoticz sera installé"
                boucle=false
        fi
        if [ $repdomoticz = "n" ] || [ $repdomoticz = "N" ]
        then
                echo "Domoticz ne sera pas installé"
                boucle=false
        fi
done

boucle=true
while "$boucle";do
        echo "Installation de Fail2ban (o/n) : "
        read repfail2ban
        if [ $repfail2ban = "o" ] || [ $repfail2ban = "O" ]
        then
                echo "Fail2ban sera installé"
                boucle=false
        fi
        if [ $repfail2ban = "n" ] || [ $repfail2ban = "N" ]
        then
                echo "Fail2ban ne sera pas installé"
                boucle=false
        fi
done

### mises à jour
echo -e "\nMise à jour des paquets"
apt update && apt -y upgrade  && aptitude update
apt update && apt -y upgrade

# installer wget (si nécessaire)
echo -e "\nInstallation de wget si nécessaire"
apt -y install wget

# puis fixer le probleme de transport sur HTTPS
#apt -y install ca-certificates apt-transport-https
#wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
# enfin on inscrit le dépot dans sources.list pour les prochaines mises à jour
#echo "deb https://packages.sury.org/php/ buster main" | sudo tee /etc/apt/sources.list.d/php.list

### installer "aptitude" (gestionnaire de paquets)
echo -e "\nInstallation d'Aptitude si nécessaire" 
apt -y install aptitude

### installer "mc" (gestionnaire de fichiers + editeur mcedit)
echo -e "\nInstallation du gestionnaire et éditeur de fichier mcedit"
apt -y install mc

### Installation d'une commande de recherche de fichiers (« locate ») :
###...et tant qu'on y est, on déclenche de suite l'indexation des fichiers pour préparer une future recherche:
echo -e "\nInstallation de locate et indexation des fichiers"
apt -y install locate && updatedb

### Mise a jour automatique de l'heure
echo -e "\nMise à jour automatique de l'heure"
aptitude install ntp -y
/etc/init.d/ntp start
echo "server 0.fr.pool.ntp.org" | sudo tee -a /etc/ntp.com

### Edition de la table crontab en root
echo "#redémarrage automatique chaque jour a 4H00 :" | sudo tee -a /var/spool/cron/crontabs/root
echo "#0 4 * * * reboot" | sudo tee -a /var/spool/cron/crontabs/root
echo "# Purger les fichiers téléchargés chaque jour le matin a 5H00" | sudo tee -a /var/spool/cron/crontabs/root
echo "0 5 * * * aptitude -y clean" | sudo tee -a /var/spool/cron/crontabs/root
echo "#mise a jour automatique sans confirmation chaque jour le matin a 6H00 :" | sudo tee -a /var/spool/cron/crontabs/root
echo "0 6 * * * aptitude update && aptitude upgrade -y" | sudo tee -a /var/spool/cron/crontabs/root

### ===============================================================
### Installation de Webmin
### ===============================================================

if [ $repwebmin = "o" ] || [$repwebmin = "O" ]
then
	echo -e "\nInstallation de Webmin"
	aptitude -y install libnet-ssleay-perl openssl libauthen-pam-perl libio-pty-perl apt-show-versions python
	wget http://www.webmin.com/download/deb/webmin-current.deb --no-check-certificate
	dpkg --install webmin-current.deb && rm -f webmin-current.deb
fi

### ===============================================================
### Installation de Motioneye
### ===============================================================

if [ $repmotioneye = "o" ] || [$repmotioneye = "O" ]
then
	echo "\nInstallation de Motioneye"
        echo "bcm2835_v4l2" | sudo tee -a /etc/modules
        echo -e "\ndisable_camera_led=1" | sudo tee -a /boot/config.txt
        apt -y install ffmpeg libmariadb3 libpq5 libmicrohttpd12
        wget https://github.com/Motion-Project/motion/releases/download/release-4.2.2/pi_buster_motion_4.2.2-1_armhf.deb
        dpkg -i pi_buster_motion_4.2.2-1_armhf.deb
        apt install python-pip python-dev libssl-dev libcurl4-openssl-dev libjpeg-dev libz-dev
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

if [ $repapache = "o" ] || [ $repapache = "O" ]
then
        echo -e "\nInstallation d'Apache"
        aptitude install apache2 -y
fi

### ===============================================================
### Installation de Domoticz
### ===============================================================

if [ $repdomoticz = "o" ] || [ $repdomoticz = "O" ]
then
        echo -e "\nInstallation de Domoticz" 
	curl -L install.domoticz.com | bash
fi

### ===============================================================
### Installation de Fail2ban
### ===============================================================

if [ $repfail2ban = "o" ] || [ $repfail2ban = "O" ]
then
        echo -e "\nInstallation de Fail2ban"
        aptitude install fail2ban -y
fi
