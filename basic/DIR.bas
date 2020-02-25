'
' Affichage du catalogue d'une disquette Sedoric
'
' Le programme RS doit avoir ete prealablement charge
'
Himem #95F0 \
Doke #2F5, Deek(#95FE)

Cls \
Paper 0 \
Ink 7 \
Poke #26A, Peek(#26A) AND #FE

D$ = "SEDORIC3.DSK"

Poke #BB80+21,16

' Lecture du type de disquette
P1 = 0 \
S1 = 2 \
AD = #A000
	Poke #48D,P1 \
	Poke #48E,S1 \
	Doke #48F,AD

	Poke #BB80+20,#11 \
	!D$ \
	Poke #BB80+20,#10

	DT$="???"
	If Peek(AD+22) = 0 Then DT$="Mst"
	If Peek(AD+22) = 1 Then DT$="Slv"

	Print "Drive A    ("DT$") ";

' Lecture du nom de la disquette
P1 = 20 \
S1 = 1 \
AD = #A000
	Poke #48D,P1 \
	Poke #48E,S1 \
	Doke #48F,AD

	Poke #BB80+20,#11 \
	!D$ \
	Poke #BB80+20,#10

	For I=9 To 29 \
		Print Chr$(Peek(AD+I)); \
	Next

	Print:Print

' Lecture des informations
P1 = 20 \
S1 = 2
	AD = #A000

	Poke #48D,P1 \
	Poke #48E,S1 \
	Doke #48F,AD

	Poke #BB80+20,#11 \
	!D$ \
	Poke #BB80+20,#10

	If ER <> #14 Then Print "Erreur: ";ER:End
	If (Peek(AD)<>#FF) Or (Peek(AD+1)<>0) Then Print"Disque incorrect":End

	DF = Deek(AD+2) : ' Espace libre
	NF = Deek(AD+4) : ' Nombre de fichiers
	NT = Peek(AD+6) : ' Nombre de pistes
	NS = Peek(AD+7) : ' Nombre de secteurs
	ND = Peek(AD+8) : ' Nombre de secteurs du catalogue

	' Densite (S/D)
	DE$ = "S"
	If Peek(AD+9) = NT+#80 Then DE$="D"

	' Type de disquette
	DT$ = "?"
	If Peek(AD+10) = 0 Then DT$ = "Master"
	If Peek(AD+10) = 1 Then DT$ = "Slave"


' Lecture du catalogue
P1 = 20 \
S1 = 4

OD = 1
Repeat
	AD = #A000

	Poke #48D,P1 \
	Poke #48E,S1 \
	Doke #48F,AD

	Poke #BB80+20,#11 \
	!D$ \
	Poke #BB80+20,#10

	If ER <> #14 Then Print "Erreur: ";ER:End

	P1 = Peek(AD) \
	S1 = Peek(AD+1) \

	AD = AD+2
	AD = AD+14

	For I=1 To 15

		FP = Peek(AD+12) \
		FS = Peek(AD+13)

		If FP+FS = 0 Then @Skip

/*
		' Lock/Unlock
		UL = Peek(AD+15) AND #C0
		UL$="?"
		If UL = #40 Then UL$="U"
		If UL = #C0 Then UL$="L"
		Print UL$;"  ";
*/

		For J=0 To 8 \
			Print Chr$(Peek(AD+J)); \
		Next
		Print ".";
		For J=0 To 2
			Print Chr$(Peek(AD+9+J)); \
		Next

		Print " ";

/*
		' Lecture du type du fichier
		Poke #48D,FP \
		Poke #48E,FS \
		Doke #48F,#A100

		Poke #BB80+20,#11 \
		!D$ \
		Poke #BB80+20,#10

		If ER <> #14 Then Print:Print "Erreur: ";ER:End

		FT = Peek(AD+256+3)
		FT$ = "?"
		If FT AND   8 Then FT$="D"
		If FT AND #10 Then FT$="S"
		If FT AND #20 Then FT$="W"
		If FT AND #40 Then FT$="d"
		If FT AND #80 Then FT$="b"

		Print FT$" "Hex$(FT);
*/

		' Suite
		S = Peek(AD+14)+(Peek(AD+15) AND #3F)*256
		S$=Str$(S) \
		Print Right$("   "+S$,3);

		' Affichage sur 2 colonnes
		OD = OD = 0
		If OD Then Print : Else Print "   ";

	&Skip
		AD=AD+16
		' Pause si une touche est appuyee
		If Peek(#2DF) Then Get Z$: Get Z$
	Next
Until (P1+S1)=0

Print

Print "***"Mid$(Str$(DF),2)" sectors free ";
Print "("DE$"/"Mid$(Str$(NT),2)"/"Mid$(Str$(NS),2)") ";
Print Mid$(Str$(NF),2)" Files"

Poke #26A, Peek(#26A) OR #01
