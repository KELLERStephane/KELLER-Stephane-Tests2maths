### =====================================================================
### Script STEPHANE
### =====================================================================

### mises à jour
apt update && apt -y upgrade

# installer wget (si nécessaire)
apt -y install wget
# puis fixer le probleme de transport sur HTTPS
#apt -y install ca-certificates apt-transport-https
#wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
# enfin on inscrit le dépot dans sources.list pour les prochaines mises à jour
#echo "deb https://packages.sury.org/php/ buster main" | sudo tee /etc/apt/sources.list.d/php.list

### installer "mc" (gestionnaire de fichiers + editeur mcedit)
apt -y install mc

### =====================================================================
### installer webmin
apt -y install aptitude
aptitude -y install libnet-ssleay-perl openssl libauthen-pam-perl libio-pty-perl apt-show-versions python
wget http://www.webmin.com/download/deb/webmin-current.deb --no-check-certificate
dpkg --install webmin-current.deb && rm -f webmin-current.deb

### Installation d'une commande de recherche de fichiers (« locate ») :
###...et tant qu'on y est, on déclenche de suite l'indexation des fichiers pour préparer une future recherche:
apt -y install locate && updatedb

