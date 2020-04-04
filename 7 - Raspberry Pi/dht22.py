#!/usr/bin/python
# coding: utf-8

# basé sur le script Adafruit et adapté pour Domoticz
import os
import sys
import Adafruit_DHT
from requests.auth import HTTPBasicAuth
import requests
import time

###################################################################
###		Paramètres pour le DHT22 			###
###################################################################

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# les parametres de Domoticz
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

domoticz_ip = '192.168.0.40'
domoticz_port = '8080'
user = 'kontua'
password = 'toto'
domoticz_idx = 11

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# les paramètres du DHT
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#sensor est 11,22,ou 2302
# pin est le numero de GPIO BCM que vous avez cablée

sensor = 22
pin = 26

############# Fin des paramètres #################################

# le fomat pour la temp hum est celui ci
#/json.htm?type=command&param=udevice&idx=IDX&nvalue=0&svalue=TEMP;HUM;HUM_STAT

def maj_widget(val_url):
    requete='http://'+domoticz_ip+':'+domoticz_port+val_url
    #print requete
    r=requests.get(requete,auth=HTTPBasicAuth(user,password))
    if  r.status_code != 200:
          print("Erreur API Domoticz")

humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)

if humidity is not None and temperature is not None:

    print('Temp={0:0.1f}*  Humidity={1:0.1f}%'.format(temperature, humidity))
    # l URL Domoticz pour le widget virtuel
    url='/json.htm?type=command&param=udevice&idx='+str(domoticz_idx)
    url+='&nvalue=0&svalue='
    url+=str('{0:0.1f};{1:0.1f};2').format(temperature, humidity)
    #print url
    maj_widget(url)

else:
    print('Probleme avec la lecture du DHT. Try again!')
    sys.exit(1)

#Affichage des valeurs
temp1 = int(temperature)
temp2 = int(10 * (temperature%1))
if temp2 != 0:
    temp = str(temp1) + '.' + str(temp2)
else:
    temp = str(temp1)

humid = str(int(humidity))

#os.chdir("/home/pi/script")
#os.system("echo 'Le repertoire courant est : '")
#os.system("pwd")
#os.system("echo -n 'Date = ' && date +%D")
#os.system("echo -n 'Heure = ' && date +%H:%M")
#os.system("echo -n 'Température = '")
#print(temp)
#os.system("echo -n 'Humidité = '")
#print(humid)
