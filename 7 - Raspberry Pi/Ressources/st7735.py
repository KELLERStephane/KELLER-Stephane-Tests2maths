#! /usr/bin/python3
# -*- coding: utf-8 -*-

from PIL import ImageFont
from PIL import Image
from PIL import ImageDraw

import matplotlib.image as mpimg
import numpy as np

import ST7735 as TFT
import Adafruit_GPIO as GPIO
import Adafruit_GPIO.SPI as SPI
import os
import random
import datetime, time, calendar
import lune

#définition de quelques couleurs
#mode (bleu, vert, rouge)
BLANC = (255, 255, 255)
NOIR = (0, 0, 0)
BLEU = (255, 0, 0)
VERT = (0, 255, 0)
ROUGE = (0, 0, 255)
VIOLET = (255, 0, 255)
TURQUOISE = (255, 255, 0)
JAUNE = (0, 255, 255)

#définition de quelques dimensions
largeur_ecran = 128
hauteur_ecran = 160
largeur_fond_noir = 128
hauteur_fond_noir = 100
largeur_lune  = 60
hauteur_lune = int(largeur_lune * 4/5)
largeur_meteo = 60
hauteur_meteo = int(largeur_lune * 4/5)
WIDTH = 128
HEIGHT = 160
SPEED_HZ = 4000000

#définition de quelques police
#police par défaut
#font = ImageFont.load_default()
taille_police_lune = 8
font_police_lune = ImageFont.truetype('Minecraftia-Regular.ttf', taille_police_lune)
taille_police_defaut = 11
font_defaut = ImageFont.truetype('Minecraftia-Regular.ttf', taille_police_defaut)
taille_police_param = 17
font_param = ImageFont.truetype('Minecraftia-Regular.ttf', taille_police_param)
taille_police_date = 14
font_date = ImageFont.truetype('Minecraftia-Regular.ttf', taille_police_date)

#hauteur des lignes d'affichage
mult_defaut = taille_police_defaut + 3
mult_param = taille_police_param + 3
mult_date = taille_police_date + 3
ligne1 = 0
ligne2 = mult_date
ligne3 = 2 * mult_date
ligne4 = 2 * mult_date + mult_defaut
ligne5 = 2 * mult_date + mult_defaut + mult_param
ligne6 = 2 * mult_date + 2 * mult_defaut + mult_param
ligne7 = 2 * mult_date + 2 * mult_defaut + 2 * mult_param
ligne8 = 140

#Raspberry Pi configuration.
DC = 24
RST = 25
SPI_PORT = 0
SPI_DEVICE = 0

#BeagleBone Black configuration.
#DC = 'P9_15'
#RST = 'P9_12'
#SPI_PORT = 1
#SPI_DEVICE = 0

#Create TFT LCD display class.
disp = TFT.ST7735(
    DC,
    rst=RST,
    spi=SPI.SpiDev(
    SPI_PORT,
    SPI_DEVICE,
    max_speed_hz=SPEED_HZ))

############################################################
###    fonctions : date_courante() ; jour_courant() ;    ### 
###    heure_courante() ; temp_int() ; temp_ext          ###
############################################################

def date_courante():
    an = str(time.localtime()[0])
    mois = str(time.localtime()[1])
    jour = str(time.localtime()[2])
#    an = an[-2:]
#    if int(an) < 10:
#        an = '0' + an
#    if int(mois) < 10:
#        mois = '0' + mois
    return jour + '/' + mois + '/' + an

def jour_courant():
    jour = str(time.localtime()[2])
    jour_sem = time.localtime()[6]
    li_jour=['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche']
    return li_jour[jour_sem]

def heure_courante():
    heure = str(time.localtime()[3])
    minute = str(time.localtime()[4])
    if int(heure) < 10:
        heure = '0' + heure
    if int(minute) < 10:
        minute = '0' + minute
    return heure + ':' + minute

def temp_int():
    ### Ouverture et affichage du fichier data.txt pour récupérer la température et l'humidité
    with open('/home/pi/script/data_dht22.txt','r') as fichier:
        li = fichier.readlines()    # lecture dans le fichier avec la méthode readlines()
        ind_temp_deb = li[0].index("rature :")
        ind_temp_fin = li[0].index("\n")
        temp = li[0][ind_temp_deb+9:ind_temp_fin]
        humid = li[1][-2:]
        print('Température = {0:0.1f}°C  Humidité = {1:0.1f}%'.format(float(temp), float(humid)))
        temp += '°C'
        humid += '%'
    return temp, humid

def temp_ext():
    ### Ouverture et affichage du fichier data.txt pour récupérer la température et l'humidité
    with open('/home/pi/script/data_am2315.txt','r') as fichier:
        li = fichier.readlines()    # lecture dans le fichier avec la méthode readlines()
        ind_temp_deb = li[0].index("rature :")
        ind_temp_fin = li[0].index("\n")
        temp = li[0][ind_temp_deb+9:ind_temp_fin]
        humid = li[1][-2:]
        print('Température = {0:0.1f}°C  Humidité = {1:0.1f}%'.format(float(temp), float(humid)))
        temp += '°C'
        humid += '%'
    return temp, humid

############################################################

periode = date_courante()
print("Date =", periode)
jour = jour_courant()
print("Jour =", jour)
heure = heure_courante()
print("Heure =", heure)

#Initialize display.
disp.begin()
disp.clear(NOIR)

#periode = str(jour) + '/' + str(mois) + '/' + str(an)
#d = datetime.date(an, mois, jour)

#récupération des dates de l'état particulier de la lune
i_jour, i_mois, i_an = time.localtime()[2], time.localtime()[1], time.localtime()[0]
[JDE_NL, JDE_PQ, JDE_PL, JDE_DQ], [d_NL, d_PQ, d_PL, d_DQ] = lune.lunar_phase(i_jour, i_mois, i_an)
fichier, etat = lune.between_dates(periode, d_NL, d_PQ, d_PL, d_DQ)
#mise à jour des dates NL, PQ, PL et DQ
if etat == "Dernier quartier":
    [JDE_NL, JDE_PQ, JDE_PL, JDE_DQ], [d_NL, d_PQ, d_PL, d_DQ] = lune.lunar_phase(i_jour, i_mois, i_an)
    print("Date =", periode, fichier, etat)

#Création du fond noir
ecran = Image.new("RGB", (largeur_ecran, hauteur_ecran), NOIR)
draw =  ImageDraw.Draw(ecran)

#affichage du jour courant
draw.text((2, ligne1), jour, font=font_date, fill = VERT)

#pour les tests uniquements
draw.text((80, ligne1), str(time.localtime()[4]), font=font_date, fill = VERT)

#affichage de la date courante
draw.text((2, ligne2), periode, font=font_date, fill = VERT)

#affichage de la température intérieure et de l'humidité intérieure
temp, humid = temp_int()
draw.text((2, ligne3), "Intérieure", font=font_defaut, fill = TURQUOISE)
draw.text((2, ligne4), temp, font=font_param, fill = JAUNE)
draw.text((85, ligne4), humid, font=font_param, fill = JAUNE)

#affichage de la température extérieure et de l'humidité  extérieure
temp, humid = temp_ext()
draw.text((2, ligne5), "Extérieure", font=font_defaut, fill = TURQUOISE)
draw.text((2, ligne6), temp, font=font_param, fill = JAUNE)
draw.text((85, ligne6), humid, font=font_param, fill = JAUNE)

#affichage de l'état de la lune
draw.text((2, ligne7), etat, font = font_police_lune, fill = VERT)

#Affichage de la lune dans la zone de l'image de la lune
os.chdir('/home/pi/script/Python_ST7735/moons_bvr/')
A = mpimg.imread(fichier)  #A est de type numpy.ndarray
if A.dtype == np.float32: #si le résultat n'est pas un tableau d'entiers
    A = (A * 255).astype(np.uint8)
    img_moons = Image.fromarray(A)
#Resize the image and rotate it so matches the display.
img_moons = img_moons.resize((largeur_lune, hauteur_lune))
print("Dimensions de l'image, largeur =", img_moons.width, "hauteur =", img_moons.height)
ecran.paste(img_moons, (0, 115))
#disp.display(ecran)
#time.sleep(0.5)

#choix aléatoire d'une image météo
li = list('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
os.chdir('/home/pi/script/Python_ST7735/meteo_bvr/')
path_img_meteo = random.choice(li) + '.png'
print("path_img_meteo = ", path_img_meteo)
img_meteo = Image.open(path_img_meteo)
img_meteo = img_meteo.resize((largeur_meteo, hauteur_meteo))
#print("Dimensions de l'image, largeur =", img_meteo.width, "hauteur =", img_meteo.height)
ecran.paste(img_meteo, (64, 115))

disp.display(ecran)
time.sleep(0.5)

#Draw the image on the display hardware.
print('Drawing images')
