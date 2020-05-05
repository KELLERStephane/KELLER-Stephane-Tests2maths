#!/usr/bin/python3
# -*- coding: utf-8 -*-

"""From a date given in parameter,
the algorithm returns dates for :
- the new moon;
- the first quarter;
- the full moon;
- last quarter

Author : Keller Stéphane.
Enseignant de mathématiques, physique chimie, informatique et SNT.
Lycée agricole Louis Pasteur - Marmilhat.  B.P. 116 - 63 370 Lempdes
stephane.keller@yahoo.com
https://github.com/KELLERStephane/KELLER-Stephane-Tests2maths
"""

__version__ = "1.0"

from moons.moonssk import angle
from moons.moonssk import jj2date
from moons.moonssk import calcul_Ci
from moons.moonssk import lunar_phase
from moons.moonssk import between_dates
