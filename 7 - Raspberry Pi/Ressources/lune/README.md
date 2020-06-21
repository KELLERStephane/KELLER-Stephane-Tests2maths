---------------------------------------------------
|    lune - Calcul des dates de phase lunaire    |
---------------------------------------------------

Vous pouvez l'installer avec pip:

    pip install lune

Utilisation :

    >>> import lune
    >>> lune.calcul_phase(year, month, day)
    >>> lune.lunar_phase(year, month, day)

Exemples d'usage

    >>> import lune
    >>> lune.calcul_phase(1969, 5, 24)


([2440357.8560705725, 2440366.010817295, 2440373.0585508235, 2440379.6528647034], ['1969/05/16', '1969/05/24', '1969/05/31', '1969/06/07'])

    >>> import lune
    >>> lune.lunar_phase(1969, 5, 24)

('8.png', 'Premier quartier')


python phase.py



The date display is in the form YYYY/MM/DD

Example with the date May 24, 1969

Date input = 1969/5/24

Date of the new moon = 1969/05/16

Date of the first quarter = 1969/05/24

Date of the full moon = 1969/05/31

Date of the last quarter = 1969/06/07

('8.png', 'Premier quartier')

Example with today's date

Date input = 2020/6/17

Date of the new moon = 2020/06/21

Date of the first quarter = 2020/06/28

Date of the full moon = 2020/07/05

Date of the last quarter = 2020/07/12

('26.png', '')

Ce code est sous licence WTFPL.


