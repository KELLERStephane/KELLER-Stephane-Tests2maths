# Stéphane KELLER - Lycée agricole Louis Pasteur
# https://github.com/KELLERStephane/KELLER-Stephane-Tests2maths
from random import randint
from pylab import *

def gain(n):
    li_de = [] #liste des lancers
    li_gain = [] #liste des gains successifs
    li_esp = [] #liste des espérances successives

    for i in range(n):
        li_de.append(randint(1,7)) #génération d'un lancer de dé
        li_gain.append(10*li_de.count(1)+20*li_de.count(2)+30*li_de.count(3)-30*(li_de.count(4)+li_de.count(5)+li_de.count(6)))
        li_esp.append(li_gain[i] / len(li_gain))       
        #affichages falcultatifs
#        print("li_de", li_de) 
#        print("li_gain", li_gain)
#        print("li_esp", li_esp)
    return li_esp

def graph(n):
    li = gain(n)
    x = [i+1 for i in range(len(li))] #tableau des abscisses
    plot(x, li) #placement des points
    show() #affichage du graphique

print(gain(100))
print(graph(100))
