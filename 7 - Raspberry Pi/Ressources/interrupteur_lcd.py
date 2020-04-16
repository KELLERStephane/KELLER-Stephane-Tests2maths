#!/usr/bin/python
# coding: utf-8

###################################################################
### Paramètrage de l'écran LCD pour l'affichage ponctuel de     ###
### la température et de l'humidité à l'aide d'un interrupteur  ###
###################################################################

import RPi.GPIO as GPIO
import time,sys
from os import chdir, getcwd
from sys import version


if sys.platform == 'uwp':
    import winrt_smbus as smbus
    bus = smbus.SMBus(1)
else:
    import smbus
    import RPi.GPIO as GPIO
    rev = GPIO.RPI_REVISION
    if rev == 2 or rev == 3:
        bus = smbus.SMBus(1)
    else:
        bus = smbus.SMBus(0)

#Numéro de GPIO (BCM)
BCM = 

# this device has two I2C addresses
DISPLAY_RGB_ADDR = 0x62
DISPLAY_TEXT_ADDR = 0x3e

# set backlight to (R,G,B) (values from 0..255 for each)
def setRGB(r,g,b):
    bus.write_byte_data(DISPLAY_RGB_ADDR,0,0)
    bus.write_byte_data(DISPLAY_RGB_ADDR,1,0)
    bus.write_byte_data(DISPLAY_RGB_ADDR,0x08,0xaa)
    bus.write_byte_data(DISPLAY_RGB_ADDR,4,r)
    bus.write_byte_data(DISPLAY_RGB_ADDR,3,g)
    bus.write_byte_data(DISPLAY_RGB_ADDR,2,b)

# send command to display (no need for external use)
def textCommand(cmd):
    bus.write_byte_data(DISPLAY_TEXT_ADDR,0x80,cmd)

# configuration de la broche BCM en entrée
GPIO.setmode(GPIO.BCM)
# GPIO (BCM) set up as input. It is pulled up to stop false signals
GPIO.setup(BCM, GPIO.IN, pull_up_down=GPIO.PUD_UP)

if version[0] == '2':
	print "Attente de l'appui sur l'interrupteur"
else:
	print("Attente de l'appui sur l'interrupteur")
# maintenant, le programme ne fera rien jusqu'au front descendant sur le GPIO BCM
#C'est pourquoi nous avons utilisé le pullup pour maintenir le signal haut et éviter une fausse interruption
#Pendant ce temps d'attente, votre ordinateur ne gaspille pas de ressources en interrogeant une touche
#Appuyez sur votre bouton lorsque vous êtes prêt à déclencher une interruption sur front descendant

try:
	GPIO.wait_for_edge(BCM, GPIO.FALLING)
	### Ouverture et affichage du fichier data.txt pour récupérer la température et l'humidité
	chdir("/home/pi/script")
	with open('data.txt','r') as fichier:
		li = fichier.readlines()	# lecture dans le fichier avec la méthode readlines()
		ind_temp_deb = li[0].index("rature :")
		ind_temp_fin = li[0].index("\n")
		temp = li[0][ind_temp_deb+9:ind_temp_fin]
		ind_humid_deb = li[1].index("\xc3\xa9 :")
		humid = li[1][ind_humid_deb+5:ind_humid_deb+7]
	if version[0] == '2':
		print 'Température = {0:0.1f}°C  Humidité = {1:0.1f}%'.format(float(temp), float(humid))
	else:
		print('Température = {0:0.1f}°C  Humidité = {1:0.1f}%'.format(float(temp), float(humid)))

	#Affichage des valeurs sur l'écran
    ### Ouverture et affichage du fichier data.txt pour récupérer la température et l'humidité
    chdir("/home/pi/script")
    with open('data.txt','r') as fichier:
        li = fichier.readlines()    # lecture dans le fichier avec la méthode readlines()
        ind_temp_deb = li[0].index("rature :")
        ind_temp_fin = li[0].index("\n")
        temp = li[0][ind_temp_deb+9:ind_temp_fin]
        ind_humid_deb = li[1].index("\xc3\xa9 :")
        humid = li[1][ind_humid_deb+5:ind_humid_deb+7]

    if version[0] == '2':
        print 'Température = {0:0.1f}°C  Humidité = {1:0.1f}%'.format(float(temp), float(humid))
    else:
        print('Température = {0:0.1f}°C  Humidité = {1:0.1f}%'.format(float(temp), float(humid)))

    temp, humid = str(temp), str(humid)
    if len(temp)==2:
        temp += '  '

    setRGB(0,128,64)
    setText("TEMP : {}     HUMID : {}%".format(temp,humid))
    time.sleep(2)

except KeyboardInterrupt:
        if version[0] == '2':
                print "Fin de l'interruption"
        else:
                print("Fin de l'interruption")
	GPIO.cleanup()       # nettoie GPIO à la sortie CTRL + C


setRGB(0,0,0)
GPIO.cleanup()           # nettoie GPIO à la sortie normale
#system("/home/pi/script/interrupteur.py &")
