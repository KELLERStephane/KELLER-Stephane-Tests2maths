---------------------------------------------------
|    lune - Calcul des dates de phase lunaire    |
---------------------------------------------------

Vous pouvez l'installer avec pip:

    pip install lune

Utilisation :

    >>> from lune import phase
    >>> phase.lunar_phase(day, month, year)

Exemples d'usage

    >>> from lune import phase
    >>> phase.lunar_phase(24, 5, 1969)

Date pour la nouvelle lune :    16/05/1969      julien des éphémérides (JDE) : 2440357.8560705725\
Date pour le premier quartier : 24/05/1969      julien des éphémérides (JDE) : 2440366.010817295\
Date pour la pleine lune :      31/05/1969      julien des éphémérides (JDE) : 2440373.0585508235\
Date pour le dernier quartier : 07/06/1969      julien des éphémérides (JDE) : 2440379.6528647034\

    >>> phase.lunar_phase(1, 1, 2021)

Date pour la nouvelle lune :    13/01/2021      julien des éphémérides (JDE) : 2459227.7078555203\
Date pour le premier quartier : 20/01/2021      julien des éphémérides (JDE) : 2459235.3769139815\
Date pour la pleine lune :      28/01/2021      julien des éphémérides (JDE) : 2459243.3006039313\
Date pour le dernier quartier : 04/02/2021      julien des éphémérides (JDE) : 2459250.2349087223\

Ce code est sous licence WTFPL.
