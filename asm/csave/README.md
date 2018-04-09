## Equivalent simple la commande CSAVE du BASIC.

### Chargement du programme
```
CLOAD""
HIMEM #95F0
DOKE #2F5,DEEK(#95FE)
```

### Exemple de sauvegarde de l'écran:
```
!"/ECRAN.TAP",A#BB80,E#BFDF
```

### Exemple de sauvegarde d'un programme BASIC avec démarrage automatique:
```
!"/PROGRAMME.TAP",AUTO
```

### Notes:
- Le nom du fichier doit commencer par un **/** pour indiquer la racine de la clé USB.
- On peut indiquer un sous-répertoire `!"/REP/PROG.TAP"` mais la longueur totale du nom du fichier ne doit pas
dépasser 17 caractères (limite du BASIC).
- L'extension *.TAP* n'est pas obligatoire (c'est juste plus simple pour repérer les fichiers sur la clé USB)
- La commande accepte les mêmes paramètres que la commande **CSAVE** du BASIC.

