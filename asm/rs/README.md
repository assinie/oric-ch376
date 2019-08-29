## Simulation de l'instruction !RS du FTDOS


### Chargement du programme
```
CLOAD""
HIMEM #95F0
DOKE #2F5,DEEK(#95FE)
```

### Exemples:
```
 10 REM Lecture Piste 20, Secteur 2
 20 AD=#A000
 30 POKE #48D,20
 40 POKE #48E,2
 50 DOKE #48F,AD
 60 D$="FTDOS.DSK"
 70 !D$
 80 IF ER <> #14 THEN PRINT "Erreur:";HEX$(ER):END
 90 DU$ = "":CLS
100 FOR L=0 TO 31
110 PRINT MID$(HEX$(AD+L*8),2);"|";
120 FOR C=0 TO 7
130 O=PEEK(AD+L*8+C)
140 OH$=RIGHT$("00"+MID$(HEX$(O),2),2)
150 C$="."
160 IF O>31 AND O<96 THEN C$=CHR$(O)
170 PRINT OH$;" ";
180 DU$ = DU$+C$
190 NEXT
200 PRINT "|";DU$:DU$=""
210 NEXT

```

### Notes:
- La variable **ER** contient le code de retour du CH376 ($14: Ok)
