#!/usr/bin/python3
# -*- coding: utf-8 -*-

from setuptools import setup, find_packages

# notez qu'on import la lib
# donc assurez-vous que l'importe n'a pas d'effet de bord
import lune

# Ceci n'est qu'un appel de fonction. Mais il est trèèèèèèèèèèès long
# et il comporte beaucoup de paramètres
setup(

    # le nom de votre bibliothèque, tel qu'il apparaitre sur pypi
    name='lune',

    # la version du code
    version=lune.__version__,

    # Liste les packages à insérer dans la distribution
    # plutôt que de le faire à la main, on utilise la foncton
    # find_packages() de setuptools qui va cherche tous les packages
    # python recursivement dans le dossier courant.
    # C'est pour cette raison que l'on a tout mis dans un seul dossier:
    # on peut ainsi utiliser cette fonction facilement
    packages=find_packages(),

    # votre pti nom
    author="KELLER Stephane",

    # Votre email, sachant qu'il sera publique visible, avec tous les risques
    # que ça implique.
    author_email="stephane.keller@yahoo.com",

    # Une description courte
    description="From a date given in parameter, the algorithm returns dates for the new moon ; the first quarter ; the full moon and the last quarter",

    # Une description longue, sera affichée pour présenter la lib
    # Généralement on dump le README ici
    long_description=open('README.md').read(),

    # Vous pouvez rajouter une liste de dépendances pour votre lib
    # et même préciser une version. A l'installation, Python essayera de
    # les télécharger et les installer.
    #
    # Ex: ["gunicorn", "docutils >= 0.3", "lxml==0.5a7"]
    #
    # Dans notre cas on en a pas besoin, donc je le commente, mais je le
    # laisse pour que vous sachiez que ça existe car c'est très utile.

    # Active la prise en compte du fichier MANIFEST.in
    include_package_data=True,

    # Une url qui pointe vers la page officielle de votre lib
    url='https://github.com/KELLERStephane/KELLER-Stephane-Tests2maths/tree/master/7%20-%20Raspberry%20Pi/Ressources/lune',

    # Il est d'usage de mettre quelques metadata à propos de sa lib
    # Pour que les robots puissent facilement la classer.
    # La liste des marqueurs autorisées est longue:
    # https://pypi.python.org/pypi?%3Aaction=list_classifiers.
    #
    # Il n'y a pas vraiment de règle pour le contenu. Chacun fait un peu
    # comme il le sent. Il y en a qui ne mettent rien.
    classifiers=[
        "Programming Language :: Python",
        "Development Status :: 6 - Mature",
        "License :: OSI Approved",
        "Natural Language :: English",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3.7",
        "Topic :: Education",
    ],


    # C'est un système de plugin, mais on s'en sert presque exclusivement
    # Pour créer des commandes, comme "django-admin".
    # Par exemple, si on veut créer la fabuleuse commande "proclame-sm", on
    # va faire pointer ce nom vers la fonction proclamer(). La commande sera
    # créé automatiquement.
    # La syntaxe est "nom-de-commande-a-creer = package.module:fonction".
    entry_points = {
        'console_scripts': [
            'lunar = lune.phase:lunar_phase',
        ],
    },

    # A fournir uniquement si votre licence n'est pas listée dans "classifiers"
    # ce qui est notre cas
    license="WTFPL",

    # Il y a encore une chiée de paramètres possibles, mais avec ça vous
    # couvrez 90% des besoins

)
