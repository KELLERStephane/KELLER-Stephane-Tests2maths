#!/usr/bin/env python
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

__version__ = "0.0.1"

from moonssk import angle
from moonssk import jj2date
from moonssk import calcul_Ci
from moonssk import lunar_phase
from moonssk import between_dates

