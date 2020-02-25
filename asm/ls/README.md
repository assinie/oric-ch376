## Commande LS.

### Chargement du programme
```
CLOAD""
HIMEM #95F0
DOKE #2F5,DEEK(#95FE)
```

### Exemples:
```
10 DIM FI$(255), DI$(255)
20 !"/",FI$,DI$
30 IF ER THEN PRINT "Erreur: ";ER:END
40 PRINT "Repertoires: ";DI
50 FOR I=0 TO DI:PRINT DI$(I):NEXT
60 PRINT "Fichiers: ";FI
70 FOR I=0 TO FI:PRINT FI$(I):NEXT
```

### Notes:
- Les tableaux doivent être correctement dimensionnés avant l'appel sinon une erreur BASIC sera renvoyée.
- Si les tableaux ne sont pas indiqués, la commande reprend les tableaux précédents (FI$ et DI$ par défaut).
- Le nom du répertoire doit commencer par un **/** pour indiquer la racine de la clé USB.
- On peut indiquer un sous-répertoire `!"/REP"`.
- Le répertoire peut être contenu dans une variable `A$="/": !A$`

