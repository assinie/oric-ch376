'
' Affichage du catalogue d'une disquette FTDOS
'
' Le programme RS doit avoir ete prealablement charge
'
Himem #95F0 \
Doke #2F5, Deek(#95FE)

Cls \
Paper 0 \
Ink 7 \
Poke #26A, Peek(#26A) AND #FE

D$ = "FTDOS.DSK"

Poke #BB80+21,16

' Lecture du nom de la disquette
P1 = 20 \
S1 = 1
	AD = #A000
	Poke #48D,P1 \
	Poke #48E,S1 \
	Doke #48F,AD

	Poke #BB80+20,#11 \
	!D$ \
	Poke #BB80+20,#10

	Print:Print
	Print "   VOLUME : ";
	For I=248 To 255 \
		Print Chr$(Peek(AD+I)); \
	Next

	Print:Print

DU = 0 \
NF = 0

P1 = 20 \
S1 = 2
Repeat
	AD = #A000

	Poke #48D,P1 \
	Poke #48E,S1 \
	Doke #48F,AD

	Poke #BB80+20,#11 \
	!D$ \
	Poke #BB80+20,#10

	If ER <> #14 Then Print "Erreur: ";ER:End

	P0 = Peek(AD) \
	S0 = Peek(AD+1) \
	P1 = Peek(AD+2) \
	S1 = Peek(AD+3)

	AD = AD+4

	For I=1 To 14
		FP = Peek(AD) \
		FS = Peek(AD+1)

		If FP=255 Then @Skip

		Print Chr$(Peek(AD+2));"  ";

		For J=1 To 12 \
			Print Chr$(Peek(AD+2+J)); \
		Next

		Print "  ";Chr$(Peek(AD+15));"      ";

		S$=Str$(Deek(AD+16)) \
		Print Right$("   "+S$,3);" SECTORS"

		DU=DU+Deek(AD+16) \
		NF=NF+1

	&Skip
		AD=AD+18
		' Pause si une touche est appuyee
		If Peek(#2DF) Then Get Z$: Get Z$
	Next
Until S1=0

Print \
Print 1394-2-DU"  SECTORS FREE"

Poke #26A, Peek(#26A) OR #01
