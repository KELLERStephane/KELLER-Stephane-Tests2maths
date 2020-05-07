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


Jour Julien des éphémérides (JDE) pour la nouvelle lune : 2440357.8560705725


Date pour la nouvelle lune : 16/05/1969


Jour Julien des éphémérides (JDE) pour le premier quartier : 2440366.010817295


Date pour le premier quartier : 24/05/1969


Jour Julien des éphémérides (JDE) pour la pleine lune : 2440373.0585508235


Date pour la pleine lune : 31/05/1969


Jour Julien des éphémérides (JDE) pour le dernier quartier : 2440379.6528647034


Date pour le dernier quartier : 07/06/1969

    >>> phase.lunar_phase(1, 1, 2021)

Jour Julien des éphémérides (JDE) pour la nouvelle lune : 2459227.7078555203


Date pour la nouvelle lune : 13/01/2021


Jour Julien des éphémérides (JDE) pour le premier quartier : 2459235.3769139815


Date pour le premier quartier : 20/01/2021


Jour Julien des éphémérides (JDE) pour la pleine lune : 2459243.3006039313


Date pour la pleine lune : 28/01/2021


Jour Julien des éphémérides (JDE) pour le dernier quartier : 2459250.2349087223


Date pour le dernier quartier : 04/02/2021


    >>> phase.between_dates('24/5/1969','16/05/1969', '24/05/1969', '31/05/1969', '07/06/1969')
 
 
  ('8.png', 'Premier quartier')
  
  
      >>> phase.between_dates('28/01/2021','13/01/2021', '20/01/2021', '28/01/2021', '04/02/2021')
 
    
    ('15.png', 'Pleine lune')


Ce code est sous licence WTFPL.

