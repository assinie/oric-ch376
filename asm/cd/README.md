## Commande CD.

### Chargement du programme
```
CLOAD""
HIMEM #95F0
DOKE #2F5,DEEK(#95FE)
```

### Exemples:
```
!"/USR":PRINT HEX$(ER)

!"/USR/BIN":PRINT HEX$(ER)

A$="/USR/SHARE/MAN"
!A$:PRINT HEX$(ER)
```

### Notes:
- La variable **ER** contient le code de retour du CH376 ($41: Ok, $42: Répertoire inexistant)
