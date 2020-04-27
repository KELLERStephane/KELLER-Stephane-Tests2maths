#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Compatibilité Python 3
from __future__ import unicode_literals, print_function, absolute_import

# Quelques modules de la lib standard
import sys
import os
import json
import re
import subprocess
from pprint import pprint
from datetime import datetime, timedelta

# Modules additionnels potentiellement présents
try:
    import requests
except ImportError:
    pass

# Environnement virtuel ?
env = os.environ.get('VIRTUAL_ENV')
if env:

    # Affiche le nom de l'environnement virtuel dans le prompt
    env_name = os.path.basename(env)
    sys.ps1 = '({0}) {1} '.format(env_name, getattr(sys, 'ps1', '>>>'))

    # Affiche la liste des modules qui ont été installés avec pip
    print("\nVirtualenv '{}' contains:".format(env_name))
    cmd = subprocess.check_output(
        [env + "/bin/pip", "freeze"],
        stderr=subprocess.STDOUT
    )
    try:
        cmd = cmd.decode('utf8')
    except:
        pass

    modules = [
        "'{}'".format(m.split('==')[0])  # exemple: u'Django==1.8.4' => u'Django'
        for m in cmd.strip().split("\n")
    ]
    print(', '.join(sorted(modules)) + '\n')


print('Use Python startup script : {}\n'.format(os.environ.get('PYTHONSTARTUP')))

