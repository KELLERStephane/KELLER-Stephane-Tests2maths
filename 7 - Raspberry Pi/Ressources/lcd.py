#!/usr/bin/python
# coding: utf-8

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

#Update the display without erasing the display
def setText_norefresh(text):
    textCommand(0x02) # return home
    time.sleep(.05)
    textCommand(0x08 | 0x04) # display on, no cursor
    textCommand(0x28) # 2 lines
    time.sleep(.05)
    count = 0
    row = 0
    while len(text) < 32: #clears the rest of the screen
        text += ' '
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

if __name__=="__main__":
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

