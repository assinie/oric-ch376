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
 90 PAPER 0:INK 7:CLS
100 FOR L=0 TO 31
110 DU$=""
120 PRINT MID$(HEX$(AD+L*8),2);"|";
130 FOR C=0 TO 7
140 O=PEEK(AD+L*8+C)
150 OH$=RIGHT$("00"+MID$(HEX$(O),2),2)
160 C$="."
170 IF O>31 AND O<96 THEN C$=CHR$(O)
180 PRINT OH$;" ";
190 DU$ = DU$+C$
200 NEXT
210 PRINT "|";DU$
220 NEXT

```

### Notes:
- La variable **ER** contient le code de retour du CH376 ($14: Ok)
