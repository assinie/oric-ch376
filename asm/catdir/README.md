## Commande CATDIR.

### Chargement du programme
```
CLOAD""
HIMEM #95F0
DOKE #2F5,DEEK(#95FE)
```

### Exemples:
```
10 DIM FI$(255)
20 !"FTDOS.DSK",FI$
30 IF ER <> #14 THEN PRINT "Erreur: ";ER:END
40 PRINT "Fichiers: ";FI
50 FOR I=0 TO FI:PRINT FI$(I):NEXT
60 PRINT
60 !"SEDORIC3.DSK",,S
70 IF ER <> #14 THEN PRINT "Erreur: ";ER:END
80 PRINT "Fichiers: ";FI
90 FOR I=0 TO FI:PRINT FI$(I):NEXT
```

### Notes:
- Le tableau doit être correctement dimensionné avant l'appel sinon une erreur BASIC sera renvoyée.
- Si le tableau n'est pas indiqué, la commande reprend le tableau précédent (FI$ par défaut).
- Si le type d'OS n'est pas précisé, la commande reprent le type précédent (FTDOS par défaut).
- Le nom du fichier peut être contenu dans une variable `A$="FTDOS.DSK": !A$`.
- La variable OS$ contient le type d'OS courant.

### TODO:
- Ajouter la récupération du nom du volume dans une variable Basic.
- Ajouter la récupération des attributs et de la taille des fichiers dans un tableau.
