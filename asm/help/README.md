## Equivalent simple la commande !HELP du FT-DOS.

Copier les fichiers *CAT.SCR* et *FORMAT.SCR* du ***FT-DOS*** à la racine de la clé USB.

### Chargement du programme
```
CLOAD""
HIMEM #95F0
DOKE #2F5,DEEK(#95FE)
```

### Exemples:
```
!"CAT"
!"FORMAT"
```

### Notes:
- Comme pour la commande **!HELP**, il est inutile de préciser l'extension *.SCR*.
- Peut aussi être utilisé pour afficher les écrans d'aide ***SEDORIC***.
Pour cela, il suffit de remplacer les 3 octets en $970F-$9711 par $48,$4C,$50 (HLP).
