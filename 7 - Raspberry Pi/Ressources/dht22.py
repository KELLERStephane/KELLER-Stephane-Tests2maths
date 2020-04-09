#!/usr/bin/python
# coding: utf-8

# basé sur le script Adafruit et adapté pour Domoticz
from os import system
from sys import version
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
domoticz_idx = 9

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
    if version[0] == '2':
	print "Requete = ", requete
    else:
	print("Requete = ", requete)
    r=requests.get(requete,auth=HTTPBasicAuth(user,password))
    if  r.status_code != 200:
	if version[0] == '2':
		print "Erreur API Domoticz"
	else:
        	print("Erreur API Domoticz")

humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)

if humidity is not None and temperature is not None:

    if version[0] == '2':
		print 'Température = {0:0.1f}°C  Humidité = {1:0.1f}%'.format(temperature, humidity)
    else:
		print('Température = {0:0.1f}°C  Humidité = {1:0.1f}%'.format(temperature, humidity))

    #Conversion des valeurs en srting
    temp1 = int(temperature)
    temp2 = int(10 * (round(temperature%1,1)))
    if temp2 != 0:
        temp = str(temp1) + '.' + str(temp2)
    else:
        temp = str(temp1)
    humid = str(int(humidity))
    #Sauvegarde température et humidité dans un fichier data.txt
    system("cd /home/pi/script")
    # Ecriture du fichier data.txt en mode write 'w'
    li = ["Température : ", temp, "\n", "Humidité : ", humid]
    with open('data.txt','w') as fichier:
        for el in li:
	    fichier.write(el)
    system("chown pi:pi data.txt")

    # l URL Domoticz pour le widget virtuel
    url='/json.htm?type=command&param=udevice&idx='+str(domoticz_idx)
    url+='&nvalue=0&svalue='
    url+=str('{0:0.1f};{1:0.1f};2').format(temperature, humidity)
    if version[0] == '2':
		print "url =", url
    else:
		print("url =", url)
    maj_widget(url)

else:
    if version[0] == '2':
		print 'Problème avec la lecture du DHT. Try again!'
    else:
		print('Problème avec la lecture du DHT. Try again!')
    sys.exit(1)
