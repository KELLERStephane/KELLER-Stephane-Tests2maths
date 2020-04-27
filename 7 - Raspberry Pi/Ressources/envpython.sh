#!/bin/bash
# coding: utf-8

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

echo -e "${bleuclair}\nInstallation de python et de ses modules si nécessaire ${neutre}"
#apt -y install python3
echo -e "${vertclair}\nModification da la version par défaut de python en python3 si nécessaire ${neutre}"
update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
update-alternatives --install /usr/bin/python python /usr/bin/python3.7 2
echo -e "${vertclair}\nChoix de la version de Python par défaut : ${neutre}"
#echo 1 pour Python 2 par défaut et echo 2 pour Python 3 par défaut
echo 1 | sudo update-alternatives --config python
echo -e -n "${vertclair}\nLa version de Python par défaut est : ${neutre}"
python --version

ver=$(python -c"import sys; print(sys.version_info.major)")
if [ $ver -eq 3 ]; then
    #installation des paquets pour Python3
    echo -e "${vertclair}\nInstallation de pip, dev, pil, setuptools, wheel, requests pour python3 si nécessaire ${neutre}"
    apt -y install python3-pip
    apt install -y python3-dev
    apt install -y python3-pil
    apt install -y python3-setuptools
    python3 -m pip install --upgrade pip setuptools wheel
    python3 -m pip install requests
elif [ $ver -eq 2 ]; then
    #installation des paquets pour Python2
    echo -e "${vertclair}\nInstallation de pip, dev, pil, setuptools, wheel, requests pour python2 si nécessaire ${neutre}"
    apt -y install python-pip
    apt install -y python-dev
    apt install -y python-pil
    apt install -y python-setuptools
    python -m pip install --upgrade pip setuptools wheel
    python -m pip install requests
    pip install --user virtualenv virtualenvwrapper

    grep -i "/usr/bin/python" "/home/pi/.profile" >/dev/null
    if [ $? = 0 ];then
        echo -e "${vertclair}\nLe fichier /home/pi/.profile a déja été modifié ${neutre}"
    else
	wget -P /home/pi/script $lien_github_raw/python_startup_script.py
        echo -e "${vertclair}\nModification du fichier /home/pi/.profile ${neutre}"
        PYV2=`python -c "import sys;t='python{v[0]}.{v[1]}'.format(v=list(sys.version_info[:2]));sys.stdout.write(t)";`
	path_python2=`echo "which $PYV2"`
	echo -e "${bleuclair}\nLe chemin de Python2 est `$path_python2` ${neutre}"
        PYV3=`python3 -c "import sys;t='python{v[0]}.{v[1]}'.format(v=list(sys.version_info[:2]));sys.stdout.write(t)";`
        path_python3=`echo "which $PYV3"`
        echo -e "${bleuclair}\nLe chemin de Python3 est `$path_python3` ${neutre}"

        L1='\nexport WORKON_HOME=/home/pi/.virtualenvs'
        L2='\nmkdir -p $WORKON_HOME'

        L3="\nexport VIRTUALENVWRAPPER_PYTHON=/usr/bin/$PYV2"
        L4='\nsource /usr/local/bin/virtualenvwrapper.sh'
        L5='\nexport VIRTUALENVWRAPPER_ENV_BIN_DIR=bin'
        L6='\nexport PYTHONSTARTUP=/home/pi/script/python_startup_script.py'
        echo -e $L1$L2$L3$L4$L5$L6>> /home/pi/.profile # ajout des lignes dans le fichier
        echo -e "${bleuclair}\nFichier /home/pi/.profile modifié ${neutre}"
        source /home/pi/.profile

        echo -e "${bleuclair}\nCréation environnement Python2 ${neutre}"
        mkvirtualenv python2env -p `$path_python2`
        echo -e "${bleuclair}\nCréation environnement Python3 ${neutre}"
        mkvirtualenv python3env -p `$path_python3`
	workon python3env

        echo -e "${rougeclair}\nPour activer un environnement Python, ${neutre}"
        echo -e "${rougeclair}dans n'importe quelle fenêtre de terminal, entrez : ${neutre}"
#        echo -e "${rougeclair}source /home/pi/.profile ${neutre}"
        echo -e "${rougeclair}workon python2env pour l'environnement pour Python2 ${neutre}"
        echo -e "${rougeclair}workon python3env pour l'environnement pour Python3 ${neutre}"

        echo -e "${rougeclair}\nPour désactiver l'environnment Python3, ${neutre}"
        echo -e "${rougeclair}dans n'importe quelle fenêtre de terminal, entrez : ${neutre}"
        echo -e "${rougeclair}deactivate ${neutre}"
      fi
else
    echo -e "${vertclair}\nVersion de Python inconnue ${neutre}"
fi

