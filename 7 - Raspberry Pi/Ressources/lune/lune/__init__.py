#!/usr/bin/python3
# -*- coding: utf-8 -*-

"""From a date given in parameter,
the algorithm returns respectively dates for :
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

__version__ = "1.6.4"

from lune.phase import angle
from lune.phase import calcul_Ci
from lune.phase import calcul_phase
from lune.phase import jj2date
from lune.phase import lunar_phase
