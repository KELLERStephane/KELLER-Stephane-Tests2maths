#!/bin/bash
# coding: utf-8

###Récuparation du nom de l'utilisateur courant
utilisateur=`cat /etc/passwd | grep "home/" | grep -v "nologin" | cut -d ":" -f$
echo -e "${jauneclair}L'utilisateur est $utilisateur \n ${neutre}"
cd /home/$utilisateur

#téléchargement du fichier d'installation du raspberry
wget https://raw.githubusercontent.com/KELLERStephane/KELLER-Stephane-Tests2mat$
chmod +x install.sh

#attente de l'appui sur la touche entrée
echo -e "${violetclair}\nFin du téléchargement. Appuyer sur Entrée pour poursui$
read

./install.sh
