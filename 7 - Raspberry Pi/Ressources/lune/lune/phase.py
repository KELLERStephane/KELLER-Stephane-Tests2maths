#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""From a date given in parameter,
the algorithm returns dates for :
- the new moon;
- the first quarter;
- the full moon;
- last quarter

Author : Keller Stéphane.
Teacher of Mathematics, Physics, Chemistry, informatics and Digital science and technology.
Agricultural High School Louis Pasteur - Marmilhat.  B.P. 116 - 63 370 Lempdes
stephane.keller@yahoo.com
https://github.com/KELLERStephane/KELLER-Stephane-Tests2maths

Usage :
>>> from lune import phase
>>> phase.calcul_phase(year, month, day)
"""

from math import cos, sin, radians
import datetime, calendar

__all__ = ['angle', 'calcul_Ci', 'calcul_phase', 'jj2date', 'lunar_phase']

def angle(alpha):
    """Input: any alpha angle in degrees.
Output: the angle such that 0 <= alpha < 360"""
    n = 1 #Number of turns of the trigonometric circle to be added
    alpha2 = alpha
    while alpha <= 0:
        alpha = alpha2 + n * 360
        n += 1
    n = 1 #Number of turns of the trigonometric circle to be removed
    alpha2 = alpha
    while alpha > 360:
        alpha -= n * 360
        n += 1
    return alpha

def jj2date(JJ):
    """Input: one day Julian of the ephemerides.
Output: the date in the form (year, month, day)"""
    JJ += 0.5
    Z = int(JJ)
    F = JJ - Z
    if Z < 2299161:
        Y = Z
    else:
        alpha = int((Z - 1867216.25) / 36524.25)
        Y = Z + 1 + alpha - int(alpha / 4)
    B = Y + 1524
    C = int((B - 122.1) / 365.25)
    D = int(365.25 * C)
    E = int((B - D) /30.6001)
    JD = B - D - int(30.6001 * E) + F #decimal day calculation
    D = int(JD) #day calculation

    if (E < 13.5): #month calculation
        M = E - 1
    else:
        M = E - 13
    if (M > 2.5): #year calculation
        Y = C - 4716
    else:
        Y = C - 4715
    return "%04d/%02d/%02d" % (Y, M, D)

def calcul_Ci(k, T):
    """Input: the coefficients k and T ;
    (T is the time in Julian centuries since the epoch 2000.0).
Output: the list of the 1st group of the 14 corrections of the \☻
periodic terms for the new moon."""
    A1 = 299.77 + 0.107408 * k - 0.009173 * T**2
    A2 = 251.88 + 0.016321 * k
    A3 = 251.83 + 26.651886 * k
    A4 = 349.42 + 36.412478 * k
    A5 = 84.66 + 18.206239 * k
    A6 = 141.74 + 53.303771 * k
    A7 = 207.14 + 2.453732 * k
    A8 = 154.84 + 7.30686 * k
    A9 = 34.52 + 27.261239 * k
    A10 = 207.19 + 0.121824 * k
    A11 = 291.34 + 1.844379 * k
    A12 = 161.72 + 24.198154 * k
    A13 = 239.56 + 25.513099 * k
    A14 = 331.55 + 3.592518 * k
    li_A = [A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14]
    #for i in range(14):
    #    print("A",end = '')
    #    print(i+1, '=',li_A[i])

    #calculation of the 1st group of the 14 corrections of the periodic terms
    #for the new moon; sines are calculated in radian
    C1 = 0.000325 * sin(radians(A1))
    C2 = 0.000165 * sin(radians(A2))
    C3 = 0.000164 * sin(radians(A3))
    C4 = 0.000126 * sin(radians(A4))
    C5 = 0.00011 * sin(radians(A5))
    C6 = 0.000062 * sin(radians(A6))
    C7 = 0.00006 * sin(radians(A7))
    C8 = 0.000056 * sin(radians(A8))
    C9 = 0.000047 * sin(radians(A9))
    C10 = 0.000042 * sin(radians(A10))
    C11 = 0.00004 * sin(radians(A11))
    C12 = 0.000037 * sin(radians(A12))
    C13 = 0.000035 * sin(radians(A13))
    C14 = 0.000023 * sin(radians(A14))
    li_C = [C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14]
    SOM_C = sum(li_C)
    #for i in range(14):
    #    print("C",end = '')
    #    print(i+1, '=',li_C[i])
    return li_C, SOM_C

#calculation of the dates corresponding to the four main lunar phases:
#new moon (NM); first quarter (FQ)
#full moon (FM) and last quarter (LQ)
def calcul_phase(year, month, day):
    """Input: a date in the format (year, month, day).
    year, month, day are integers
    Output: the list of the four dates corresponding respectively to :
    - the new moon;
    - the first quarter;
    - the full moon;
    - the last quarter
    in the form Julian day and in the form (year, month, day)."""
    #print("Date parameter :", day, month, year)
    #calculation of the number of days since January 1st
    delta = (datetime.date(year, month, day) - datetime.date(year, 1, 1)).days
    #print("Since 1 January", year," =", delta, "days")
    #calculation of the number of days in the year
    nb_days_year = (datetime.date(year, 12, 31) - \
    datetime.date(year, 1, 1)).days + 1
    #print("Year =", year," =", nb_days_year, "days")
    li_JDE, li_date = [], []

    ###################################################################
    # Calculations for the new moon NM
    ###################################################################

    #print("\nCalculations for the new moon NM")

    #calculation of k
    year_plus_month = year + delta / nb_days_year
    #print("Year + month =",year + delta / nb_days_year)
    j = 12.3685 * (year_plus_month - 2000)
    k = round(j)
    #print("k =", j, "soit k =", k)
    #calculation of T
    T = k/1236.85
    #print("T = ", T)
    #calculation of E
    E = 1 - 0.002516 * T - 0.0000074 * T**2
    #print("E = ", E)
    #calculation of JDE
    JDE = 2451550.09765 + 29.530588853 * k + 0.0001337 * T**2 - \
    0.00000015 * T**3 + 0.00000000073 * T**4
    #print("JDE = ", JDE)
    #calculation of M : mean anomaly of the sun at the time of the Julian day
    M = 2.5534 + 29.10535670 * k - 0.0000014 * T**2 - 0.00000011 * T**3
    #print("M =", M, "=", angle(M), end = '')
    #print("°")
    #calculation of M' : mean anomaly of the moon at the time of the Julian day
    M_prime = 201.5643 + 385.81693528 * k + 0.0107438 * T**2 \
    + 0.00001239 * T**3 - 0.000000058 * T**4
    #print("M' =", M_prime, "=", angle(M_prime), end = '')
    #print("°")
    #calculation of F : argument of the latitude of the moon
    #at the time of day Julian
    F = 160.7108 + 390.67050274 * k - 0.0016341 * T**2 \
    - 0.00000227 * T**3 + 0.000000011 * T**4
    #print("F =", F, "=", angle(F), end = '')
    #print("°")
    #calculation of Omega
    OMEGA = 124.7746 - 1.5637558 * k + 0.0020691 * T**2 + 0.00000215 * T**3
    #print(chr(937),"=", OMEGA, "=", angle(OMEGA), end = '')
    #print("°")

    #calculation of the sum of the first group of the 14 corrections
    #of the periodic terms for the new moon
    li_C, SOM_C = calcul_Ci(k, T)
    #print("Sum of the first group of 14 corrections", end = ' ')
    #print("of the periodic terms for the new moon =", SOM_C)

    #calculation of the 25 periodic terms for the new moon (NM)
    NM1 = -0.40720 * sin(radians(M_prime))
    NM2 = 0.17241 * E * sin(radians(M))
    NM3 = 0.01608 * sin(radians(2 * M_prime))
    NM4 = 0.01039 * sin(radians(2 * F))
    NM5 = 0.00739 * E * sin(radians(M_prime - M))
    NM6 = -0.00514 * E * sin(radians(M_prime + M))
    NM7 = -0.00208 * E**2 * sin(radians(2 * M))
    NM8 = -0.00111 * sin(radians(M_prime - 2 * F))
    NM9 = -0.00057 * sin(radians(M_prime + 2 * F))
    NM10 = 0.00056 * E * sin(radians(2 * M_prime + M))
    NM11 = -0.00042 * sin(radians(3 * M_prime))
    NM12 = 0.00042 * E * sin(radians(M + 2 * F))
    NM13 = 0.00038 * E * sin(radians(M - 2 * F))
    NM14 = -0.00024 * E * sin(radians(2 * M_prime - M))
    NM15 = -0.00017 * sin(radians(OMEGA))
    NM16 = -0.00007 * sin(radians(M_prime + 2 * M))
    NM17 = 0.00004 * sin(radians(2 * M_prime - 2 * F))
    NM18 = 0.00004 * sin(radians(3 * M))
    NM19 = 0.00003 * sin(radians(M_prime + M - 2 * F))
    NM20 = 0.00003 * sin(radians(2 * M_prime + 2 * F))
    NM21 = 0.00003 * sin(radians(M_prime + M + 2 * F))
    NM22 = 0.00003 * sin(radians(M_prime - M + 2 * F))
    NM23 = -0.00002 * sin(radians(M_prime - M - 2 * F))
    NM24 = -0.00002 * sin(radians(3 * M_prime + M))
    NM25 = 0.00002 * sin(radians(4 * M_prime))
    li_NM = [NM1, NM2, NM3, NM4, NM5, NM6, NM7, NM8, NM9, NM10, NM11, NM12 \
    , NM13, NM14, NM15, NM16, NM17, NM18, NM19, NM20, NM21, NM22, NM23 \
    , NM24, NM25]
    #for i in range(25):
    #    print("NM",end = '')
    #    print(i+1, '=',li_NM[i])
    SOM_NM = sum(li_NM)
    #print("Sum of the first group of 25", end = ' ')
    #print("periodic terms for the new moon =", SOM_NM)

    JDE_NM = JDE + SOM_NM + SOM_C
    #print("JDE_NM = ", JDE_NM)
    #print("The day of the new moon is", jj2date(JDE_NM))
    li_JDE += [JDE_NM]
    li_date += [jj2date(JDE_NM)]

    ###################################################################
    # Calculations for the first quarter FQ
    ###################################################################

    #print("\nCalculations for the first quarter FQ")

    #calculation of k
    k += 0.25
    #print("k =", k)
    #calculation of T
    T = k/1236.85
    #print("T = ", T)
    #calculation of E
    E = 1 - 0.002516 * T - 0.0000074 * T**2
    #print("E = ", E)
    #calculation of JDE
    JDE = 2451550.09765 + 29.530588853 * k + 0.0001337 * T**2 - \
    0.00000015 * T**3 + 0.00000000073 * T**4
    #print("JDE = ", JDE)
    #calculation of M
    M = 2.5534 + 29.10535670 * k - 0.0000014 * T**2 - 0.00000011 * T**3
    #print("M =", M, "=", angle(M), end = '')
    #print("°")
    #calculation of M'
    M_prime = 201.5643 + 385.81693528 * k + 0.0107438 * T**2 \
    + 0.00001239 * T**3 - 0.000000058 * T**4
    #print("M' =", M_prime, "=", angle(M_prime), end = '')
    #print("°")
    #calculation of F
    F = 160.7108 + 390.67050274 * k - 0.0016341 * T**2 \
    - 0.00000227 * T**3 + 0.000000011 * T**4
    #print("F =", F, "=", angle(F), end = '')
    #print("°")
    #calculation of Omega
    OMEGA = 124.7746 - 1.5637558 * k + 0.0020691 * T**2 + 0.00000215 * T**3
    #print(chr(937),"=", OMEGA, "=", angle(OMEGA), end = '')
    #print("°")
    #Calculation of W only for the first and last quarter
    W = 0.00306 - 0.00038 * E * cos(radians(M)) + 0.00026 \
    * cos(radians(M_prime)) - 0.00002 * cos(radians(M_prime - M)) \
    + 0.00002 * cos(radians(M_prime + M)) + 0.00002 * cos(radians(2 * F))
    #print("W =", W)

    #calculation of the sum of the first group of the 14 corrections
    #of the periodic terms for the first quarter
    li_C, SOM_C = calcul_Ci(k, T)
    #print("Calculation of the sum of the first group of the 14 ", end = ' ')
    #print("Corrections of the periodic terms for the first quarter =", SOM_C)
    li_C, SOM_C = calcul_Ci(k, T)

    #calculation of the first 25 quarters (FQ)
    FQ1 = -0.62801 * sin(radians(M_prime))
    FQ2 = 0.17172 * E * sin(radians(M))
    FQ3 = -0.01183 * E * sin(radians(M_prime + M))
    FQ4 = 0.00862 * sin(radians(2 * M_prime))
    FQ5 = 0.00804 * sin(radians(2 * F))
    FQ6 = 0.00454 * E * sin(radians(M_prime - M))
    FQ7 = 0.00204 * E**2 * sin(radians(2 * M))
    FQ8 = -0.00180 * sin(radians(M_prime - 2 * F))
    FQ9 = -0.00070 * sin(radians(M_prime + 2 * F))
    FQ10 = -0.00040 * sin(radians(3 * M_prime))
    FQ11 = -0.00034 * E * sin(radians(2 * M_prime - M))
    FQ12 = 0.00032 * E * sin(radians(M + 2 * F))
    FQ13 = 0.00032 * E * sin(radians(M - 2 * F))
    FQ14 = -0.00028 * E**2 * sin(radians(M_prime + 2 * M))
    FQ15 = 0.00027 * E * sin(radians(2 * M_prime + M))
    FQ16 = -0.00017 * sin(radians(OMEGA))
    FQ17 = -0.00005 * sin(radians(M_prime - M - 2 * F))
    FQ18 = 0.00004 * sin(radians(2 * M_prime + 2 * F))
    FQ19 = -0.00004 * sin(radians(M_prime + M + 2 * F))
    FQ20 = 0.00004 * sin(radians(M_prime - 2 * M))
    FQ21 = 0.00003 * sin(radians(M_prime + M - 2 * F))
    FQ22 = 0.00003 * sin(radians(3 * M))
    FQ23 = 0.00002 * sin(radians(2 * M_prime - 2 * F))
    FQ24 = 0.00002 * sin(radians(M_prime - M + 2 * F))
    FQ25 = -0.00002 * sin(radians(3 * M_prime + M))
    li_FQ = [FQ1, FQ2, FQ3, FQ4, FQ5, FQ6, FQ7, FQ8, FQ9, FQ10, FQ11, FQ12, FQ13 \
    , FQ14, FQ15, FQ16, FQ17, FQ18, FQ19, FQ20, FQ21, FQ22, FQ23, FQ24, FQ25]
    SOM_FQ = sum(li_FQ)
    #for i in range(25):
    #    print("FQ",end = '')
    #    print(i+1, '=',li_FQ[i])
    #print("Sum 1st group of 14 corrections =", SOM_FQ)

    JDE_FQ = JDE + SOM_FQ + SOM_C + W
    #print("JDE_FQ = ", JDE_FQ)
    #print("The day of the first quarter is", jj2date(JDE_FQ))
    li_JDE += [JDE_FQ]
    li_date += [jj2date(JDE_FQ)]

    ###################################################################
    # Calculations for full moon FM
    ###################################################################

    #print("\nCalculations for full moon FM")

    #calculation of k
    k += 0.25
    #print("k =", k)
    #calculation of T
    T = k/1236.85
    #print("T = ", T)
    #calculation of E
    E = 1 - 0.002516 * T - 0.0000074 * T**2
    #print("E = ", E)
    #calculation of JDE
    JDE = 2451550.09765 + 29.530588853 * k + 0.0001337 * T**2 - \
    0.00000015 * T**3 + 0.00000000073 * T**4
    #print("JDE = ", JDE)
    #calculation of M
    M = 2.5534 + 29.10535670 * k - 0.0000014 * T**2 - 0.00000011 * T**3
    #print("M =", M, "=", angle(M), end = '')
    #print("°")
    #calculation of M'
    M_prime = 201.5643 + 385.81693528 * k + 0.0107438 * T**2 \
    + 0.00001239 * T**3 - 0.000000058 * T**4
    #print("M' =", M_prime, "=", angle(M_prime), end = '')
    #print("°")
    #calculation of F
    F = 160.7108 + 390.67050274 * k - 0.0016341 * T**2 \
    - 0.00000227 * T**3 + 0.000000011 * T**4
    #print("F =", F, "=", angle(F), end = '')
    #print("°")
    #calculation of Omega
    OMEGA = 124.7746 - 1.5637558 * k + 0.0020691 * T**2 + 0.00000215 * T**3
    #print(chr(937),"=", OMEGA, "=", angle(OMEGA), end = '')
    #print("°")

    #calculation of the sum of the first group of the 14 corrections
    #of the periodical terms for the full moon
    li_C, SOM_C = calcul_Ci(k, T)
    #print("Calculation of the sum of the first group of the", end = ' ')
    #print("14 corrections of the periodical terms for the full moon=", SOM_C)

    #calculation of the first 25 moons (FM)
    FM1 = -0.40614 * sin(radians(M_prime))
    FM2 = 0.17302 * E * sin(radians(M))
    FM3 = 0.01614 * sin(radians(2 * M_prime))
    FM4 = 0.01043 * sin(radians(2 * F))
    FM5 = 0.00734 * E * sin(radians(M_prime - M))
    FM6 = -0.00515 * E * sin(radians(M_prime + M))
    FM7 = -0.00209 * E**2 * sin(radians(2 * M))
    FM8 = -0.00111 * sin(radians(M_prime - 2 * F))
    FM9 = -0.00057 * sin(radians(M_prime + 2 * F))
    FM10 = 0.00056 * E * sin(radians(2 * M_prime + M))
    FM11 = -0.00042 * sin(radians(3 * M_prime))
    FM12 = 0.00042 * E * sin(radians(M + 2 * F))
    FM13 = 0.00038 * E * sin(radians(M - 2 * F))
    FM14 = -0.00024 * E * sin(radians(2 * M_prime - M))
    FM15 = -0.00017 * sin(radians(OMEGA))
    FM16 = -0.00007 * sin(radians(M_prime + 2 * M))
    FM17 = 0.00004 * sin(radians(2 * M_prime - 2 * F))
    FM18 = 0.00004 * sin(radians(3 * M))
    FM19 = 0.00003 * sin(radians(M_prime + M - 2 * F))
    FM20 = 0.00003 * sin(radians(2 * M_prime + 2 * F))
    FM21 = 0.00003 * sin(radians(M_prime + M + 2 * F))
    FM22 = 0.00003 * sin(radians(M_prime - M + 2 * F))
    FM23 = -0.00002 * sin(radians(M_prime - M - 2 * F))
    FM24 = -0.00002 * sin(radians(3 * M_prime + M))
    FM25 = 0.00002 * sin(radians(4 * M_prime))
    li_FM = [FM1, FM2, FM3, FM4, FM5, FM6, FM7, FM8, FM9, FM10, FM11, FM12, \
    FM13, FM14, FM15, FM16, FM17, FM18, FM19, FM20, FM21, FM22, FM23, FM24 \
    , FM25]
    SOM_FM = sum(li_FM)
    #for i in range(25):
    #    print("FM",end = '')
    #    print(i+1, '=',li_FM[i])
    #print("Sum 1st group of 14 corrections =", SOM_FM)

    JDE_FM = JDE + SOM_FM + SOM_C
    #print("JDE_FM = ", JDE_FM)
    #print("The day of the full moon is ", jj2date(JDE_FM))
    li_JDE += [JDE_FM]
    li_date += [jj2date(JDE_FM)]

    ###################################################################
    # Calculations for the last quarter LQ
    ###################################################################

    #print("\nCalculations for the last quarter LQ")

    #calculation of k
    k += 0.25
    #print("k =", k)
    #calculation of T
    T = k/1236.85
    #print("T = ", T)
    #calculation of E
    E = 1 - 0.002516 * T - 0.0000074 * T**2
    #print("E = ", E)
    #calculation of JDE
    JDE = 2451550.09765 + 29.530588853 * k + 0.0001337 * T**2 - \
    0.00000015 * T**3 + 0.00000000073 * T**4
    #print("JDE = ", JDE)
    #calculation of M
    M = 2.5534 + 29.10535670 * k - 0.0000014 * T**2 - 0.00000011 * T**3
    #print("M =", M, "=", angle(M), end = '')
    #print("°")
    #calculation of M'
    M_prime = 201.5643 + 385.81693528 * k + 0.0107438 * T**2 \
    + 0.00001239 * T**3 - 0.000000058 * T**4
    #print("M' =", M_prime, "=", angle(M_prime), end = '')
    #print("°")
    #calculation of F
    F = 160.7108 + 390.67050274 * k - 0.0016341 * T**2 \
    - 0.00000227 * T**3 + 0.000000011 * T**4
    #print("F =", F, "=", angle(F), end = '')
    #print("°")
    #calculation of Omega
    OMEGA = 124.7746 - 1.5637558 * k + 0.0020691 * T**2 + 0.00000215 * T**3
    #print(chr(937),"=", OMEGA, "=", angle(OMEGA), end = '')
    #print("°")
    #Calculation of W only for the first and last quarter
    W = 0.00306 - 0.00038 * E * cos(radians(M)) + 0.00026 \
    * cos(radians(M_prime)) - 0.00002 * cos(radians(M_prime - M)) \
    + 0.00002 * cos(radians(M_prime + M)) + 0.00002 * cos(radians(2 * F))
    #print("W =", W)

    #calculation of the sum of the first group of the 14
    #corrections of the periodic terms for the last quarter
    li_C, SOM_C = calcul_Ci(k, T)
    #print("Calculation of the sum of the first group of the 14", end = ' ')
    #print("corrections of the periodic terms for the last quarter =", SOM_C)
    li_C, SOM_C = calcul_Ci(k, T)

    #calculation of the last 25 quarters (LQ)
    LQ1 = -0.62801 * sin(radians(M_prime))
    LQ2 = 0.17172 * E * sin(radians(M))
    LQ3 = -0.01183 * E * sin(radians(M_prime + M))
    LQ4 = 0.00862 * sin(radians(2 * M_prime))
    LQ5 = 0.00804 * sin(radians(2 * F))
    LQ6 = 0.00454 * E * sin(radians(M_prime - M))
    LQ7 = 0.00204 * E**2 * sin(radians(2 * M))
    LQ8 = -0.00180 * sin(radians(M_prime - 2 * F))
    LQ9 = -0.00070 * sin(radians(M_prime + 2 * F))
    LQ10 = -0.00040 * sin(radians(3 * M_prime))
    LQ11 = -0.00034 * E * sin(radians(2 * M_prime - M))
    LQ12 = 0.00032 * E * sin(radians(M + 2 * F))
    LQ13 = 0.00032 * E * sin(radians(M - 2 * F))
    LQ14 = -0.00028 * E**2 * sin(radians(M_prime + 2 * M))
    LQ15 = 0.00027 * E * sin(radians(2 * M_prime + M))
    LQ16 = -0.00017 * sin(radians(OMEGA))
    LQ17 = -0.00005 * sin(radians(M_prime - M - 2 * F))
    LQ18 = 0.00004 * sin(radians(2 * M_prime + 2 * F))
    LQ19 = -0.00004 * sin(radians(M_prime + M + 2 * F))
    LQ20 = 0.00004 * sin(radians(M_prime - 2 * M))
    LQ21 = 0.00003 * sin(radians(M_prime + M - 2 * F))
    LQ22 = 0.00003 * sin(radians(3 * M))
    LQ23 = 0.00002 * sin(radians(2 * M_prime - 2 * F))
    LQ24 = 0.00002 * sin(radians(M_prime - M + 2 * F))
    LQ25 = -0.00002 * sin(radians(3 * M_prime + M))
    li_LQ = [LQ1, LQ2, LQ3, LQ4, LQ5, LQ6, LQ7, LQ8, LQ9, LQ10, LQ11, \
    LQ12, LQ13, LQ14, LQ15, LQ16, LQ17, LQ18, LQ19, LQ20, LQ21, LQ22, \
    LQ23, LQ24, LQ25]
    SOM_LQ = sum(li_LQ)
    #for i in range(25):
    #    print("LQ",end = '')
    #    print(i+1, '=',li_LQ[i])
    #print("Sum 1st group of 14 corrections =", SOM_LQ)

    JDE_LQ = JDE + SOM_LQ + SOM_C - W
    #print("JDE_LQ = ", JDE_LQ)
    #print("The day of the last quarter is", jj2date(JDE_LQ))
    li_JDE += [JDE_LQ]
    li_date += [jj2date(JDE_LQ)]

    return li_JDE, li_date


def lunar_phase(year, month, day):
    """Input: a date in the format (year, month, day).
    year, month, day are integers
    Output: the number of the image corresponding to visibility \
of the moon on this date and if necessary, the particular state, \
of the moon on this date."""
    [JDE_NM, JDE_FQ, JDE_FM, JDE_LQ], [d_NM, d_FQ, d_FM, d_LQ] = \
    calcul_phase(year, month, day)
    date_in = datetime.date(year, month, day)
    dateNM = datetime.date(int(d_NM.split("/")[0]), int(d_NM.split("/")[1]), int(d_NM.split("/")[2]))

    date = str(year) + '/' + str(month) + '/' + str(day)
#    print("Date input =", date)
#    print("Date of the new moon =", d_NM)
#    print("Date of the first quarter =", d_FQ)
#    print("Date of the full moon =", d_FM)
#    print("Date of the last quarter =", d_LQ)

#    print("JJ of the new moon =", JDE_NM)
#    print("JJ of the first quarter =", JDE_FQ)
#    print("JJ of the full moon =", JDE_FM)
#    print("JJ of the last quarter =", JDE_LQ)

    if date_in < dateNM:
        d = datetime.date(year, month, day) - datetime.timedelta(28.5)
#        print("d=", d)
        year, month, day = d.year, d.month, d.day
        [JDE_NM, JDE_FQ, JDE_FM, JDE_LQ], [d_NM, d_FQ, d_FM, d_LQ] = \
    calcul_phase(year, month, day)

    dateNM = datetime.date(int(d_NM.split("/")[0]), int(d_NM.split("/")[1]), int(d_NM.split("/")[2]))
    dateFQ = datetime.date(int(d_FQ.split("/")[0]), int(d_FQ.split("/")[1]), int(d_FQ.split("/")[2]))
    dateFM = datetime.date(int(d_FM.split("/")[0]), int(d_FM.split("/")[1]), int(d_FM.split("/")[2]))
    dateLQ = datetime.date(int(d_LQ.split("/")[0]), int(d_LQ.split("/")[1]), int(d_LQ.split("/")[2]))

#    date = str(year) + '/' + str(month) + '/' + str(day)
#    print("Date input or modify =", date)
#    print("Date of the new moon =", dateNM)
#    print("Date of the first quarter =", dateFQ)
#    print("Date of the full moon =", dateFM)
#    print("Date of the last quarter =", dateLQ)

    if date_in == dateNM:
        return '0.png', "Nouvelle lune"
    elif date_in == dateFQ:
        return '8.png', "Premier quartier"
    elif date_in == dateFM:
        return '15.png', "Pleine lune"
    elif date_in == dateLQ:
        return '22.png', "Dernier quartier"
    elif dateNM < date_in < dateFQ:
        return str((date_in - dateNM).days) + '.png', ""
    elif dateFQ < date_in < dateFM:
        return str((date_in - dateFQ).days + 8) + '.png', ""
    elif dateFM < date_in < dateLQ:
        return str((date_in - dateFM).days + 15) + '.png', ""
    elif dateLQ < date_in:
        return str(min(((date_in - dateLQ).days + 22), 29)) + '.png', ""

if __name__ == "__main__":
    print("The date display is in the form YYYY/MM/DD")

    print("\nExample with the date May 24, 1969")
    year, month, day = 1969, 5, 24
    [JDE_NM, JDE_FQ, JDE_FM, JDE_LQ], [d_NM, d_FQ, d_FM, d_LQ] = calcul_phase(year, month, day)
    date = str(year) + '/' + str(month) + '/' + str(day)
    print("Date input =", date)
    print("Date of the new moon =", d_NM)
    print("Date of the first quarter =", d_FQ)
    print("Date of the full moon =", d_FM)
    print("Date of the last quarter =", d_LQ)
    print(lunar_phase(year, month, day))

    print("\nExample with today's date")
    year = datetime.datetime.now().year
    month = datetime.datetime.now().month
    day = datetime.datetime.now().day

    [JDE_NM, JDE_FQ, JDE_FM, JDE_LQ], [d_NM, d_FQ, d_FM, d_LQ] = calcul_phase(year, month, day)
    date = str(year) + '/' + str(month) + '/' + str(day)
    print("Date input =", date)
    print("Date of the new moon =", d_NM)
    print("Date of the first quarter =", d_FQ)
    print("Date of the full moon =", d_FM)
    print("Date of the last quarter =", d_LQ)
    print(lunar_phase(year, month, day))
