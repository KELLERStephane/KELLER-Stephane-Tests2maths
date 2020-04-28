#!/usr/bin/python3
# coding: utf-8

###################################################################
### Paramètrage de l'écran LCD pour l'affichage ponctuel de     ###
### la température et de l'humidité à l'aide d'un interrupteur  ###
###################################################################

import RPi.GPIO as GPIO
import time,sys
from os import chdir, getcwd

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
BCM = 13

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

# set display text \n for second line(or auto wrap)
def setText(text):
    textCommand(0x01) # clear display
    time.sleep(.05)
    textCommand(0x08 | 0x04) # display on, no cursor
    textCommand(0x28) # 2 lines
    time.sleep(.05)
    count = 0
    row = 0
    for c in text:
        if c == '\n' or count == 16:
            count = 0
            row += 1
            if row == 2:
                break
            textCommand(0xc0)
            if c == '\n':
                continue
        count += 1
        bus.write_byte_data(DISPLAY_TEXT_ADDR,0x40,ord(c))

# configuration de la broche BCM en entrée
GPIO.setmode(GPIO.BCM)
# GPIO (BCM) set up as input. It is pulled up to stop false signals
GPIO.setup(BCM, GPIO.IN, pull_up_down=GPIO.PUD_UP)

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
        li = fichier.readlines()    # lecture dans le fichier avec la méthode readlines()
        ind_temp_deb = li[0].index("rature :")
        ind_temp_fin = li[0].index("\n")
        temp = li[0][ind_temp_deb+9:ind_temp_fin]
        humid = li[1][-2:]

    print('Température = {0:0.1f}°C  Humidité = {1:0.1f}%'.format(float(temp), float(humid)))

    temperature = float(temp)
    if temperature >= 33:
        print("Extrêmement chaud")
        r, g, b = 255, 0, 0
    elif 30 <= temperature < 33:
        print("Très chaud")
        r, g, b = 255, 128, 0
    elif 27 <= temperature < 30:
        print("Chaud")
        r, g, b = 255, 153, 0
    elif 24 <= temperature < 27:
        print("Assez chaud")
        r, g, b = 76, 153, 0
    elif 21 <= temperature < 24:
        print("Normal")
        r, g, b = 0, 153, 0
    elif 18 <= temperature < 21:
        print("Frais")
        r, g, b = 51, 153, 255
    elif 15 <= temperature < 18:
        print("Froid")
        r, g, b = 0, 0, 255
    elif 12 <= temperature < 15:
        print("Très froid")
        r, g, b = 153, 51, 255
    else:
        print("Glacial")
        r, g, b = 51, 0, 51

    temp, humid = str(temp), str(humid)
    if len(temp)==2:
        temp += '  '
    setRGB(r, g, b)
    setText("TEMP : {}     HUMID : {}%".format(temp,humid))
    time.sleep(2)

except KeyboardInterrupt:
    print("Fin de l'interruption")

setRGB(0, 0, 0)
setText("")
GPIO.cleanup()           # nettoie GPIO à la sortie normale
