										;'#define WOR word';
#define WOR word
										;'#include <include/BASIC.h>';
#include <include/BASIC.h>

;---------------------------------------------------------------------------
;
; Debut du programme
;
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
; AddElt:
; Met a jour un element d'un tableau alpha ou une variable alpha
;
; Entree:
; C: 0-> tableau, 1-> variable simple
; AY: Adresse du nom du fichier (A: poids faible)
; X: Indice dans VARTABLE pour le nom du tableau
;---------------------------------------------------------------------------
										;'#iflused AddElt';
#iflused AddElt
										;'#echo Ajout AddElt';
#echo Ajout AddElt
										;AddElt:
AddElt
										; STACK .A, .Y; " Sauvegarde l'adresse de l'entree";
	PHA
	TYA
	PHA
										; STACK .P; " Sauvegarde P pour plus tard";
	PHP
										; CALL SetVarName;
	JSR SetVarName
										; UNSTACK .P; " Restaure P pour savoir ce qu'on cherche";
	PLP
										; CALL FindVarArray;
	JSR FindVarArray
	;String:
										; .Y = $02; " Sauvegarde l'adresse de la chaine";
	LDY #$02
										; REPEAT;
ZZ0001
										; DO;
										; .A = @VAR_ADDR[.Y];
	LDA (VAR_ADDR),Y
										; 'STA TMP_STR-1,Y';
	STA TMP_STR-1,Y
										; DEC .Y;
	DEY
										; END;
										; UNTIL .Z;
	BNE ZZ0001
										; .A = @VAR_ADDR[.Y]; " Taille de la chaine";
	LDA (VAR_ADDR),Y
										; IFF .Z THEN Vide;
	BEQ Vide
										; .AY <- VAR_ADDR; " Libere la chaine";
	LDA VAR_ADDR
	LDY VAR_ADDR+1
										; CALL FreeStr_04;
	JSR FreeStr_04
										; Vide:
	Vide
										; .A = 12; " Longueur de la chaine";
	LDA #12
										; CALL NewStr;
	JSR NewStr
										; .Y = $00;
	LDY #$00
										; 'STA (VAR_ADDR),Y'; " Nouvelle longueur dans le desripteur";
	STA (VAR_ADDR),Y
										; INC .Y;
	INY
	; &VAR_ADDR[.Y] = TMP_STR;
										; .A = TMP_STR; " Nouvelle adresse de la chaine dans le descripteur";
	LDA TMP_STR
										; 'STA (VAR_ADDR), Y';
	STA (VAR_ADDR), Y
										; INC .Y;
	INY
	; &VAR_ADDR[.Y] = TMP_STR_H;
										; .A = TMP_STR_H; " Nouvelle adresse de la chaine dans le descripteur";
	LDA TMP_STR_H
										; 'STA (VAR_ADDR), Y';
	STA (VAR_ADDR), Y
										; UNSTACK .Y,.X;
	PLA
	TAY
	PLA
	TAX
										; .A = 12; " Longueur de la chaine";
	LDA #12
										; CALL CpyStr; " Copie une chaine, XY:adresse de la chaine, ACC: longueur de la
	JSR CpyStr
										; chaine, $A4-A5: Destination";
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; FindVarArray:
; Recherche l'adresse d'une variable/tableau
;
; Entree:
; C: 0->Tableau, 1->Variable simple
; X: Indice du tableau dans ArrayIndex[]
;
; Externe:
; ArrayIndex[]: Tableau pour la sauvegarde des indices
;---------------------------------------------------------------------------
										;'#iflused FindVarArray';
#iflused FindVarArray
										;'#echo Ajout FindVarArray';
#echo Ajout FindVarArray
										;FindVarArray:
FindVarArray
										; IF ^.C THEN
	BCS ZZ0002
										; BEGIN;
										; VARFOUND = $00; " Consultation";
	LDA #$00
	STA VARFOUND
										; ARRAY_FLAG = .A; " Atmos uniquement:on veut l'adresse d'un element et non cel
	STA ARRAY_FLAG
										;le du tableau";
										; STACK .A; " MSB indice du tableau (<255)";
	PHA
										; LINESIZE = $01; " Tableau a 1 dimension";
	LDA #$01
	STA LINESIZE
										; .A = ArrayIndex[.X]; " LSB indice du tableau";
	LDA ArrayIndex,X
										; STACK .A;
	PHA
										; GOTO FindArrayElt;
	JMP FindArrayElt
										; END;
										; GOTO FindVar;
ZZ0002
	JMP FindVar
;RETURN;
										;'#endif';
#endif

;---------------------------------------------------------------------------
; SetCH376Var:
; Met a jour une variable
;
; Entree:
; AY: Valeur entiere de la variable
; X: Indice de la variable dans le tableau VARTABLE
;---------------------------------------------------------------------------
										;'#iflused SetCH376Var';
#iflused SetCH376Var
										;'#echo Ajout SetCH376Var';
#echo Ajout SetCH376Var
										;SetCH376Var:
SetCH376Var
										; CALL SetVarName;
	JSR SetVarName
										; GOTO SetVar;
	JMP SetVar
;RETURN
										;'#endif';
#endif

;---------------------------------------------------------------------------
; SetVarName:
; Place le nom de la variable .X dans VARNAME1, VARNAME2
;
; Entree:
; X: Indice dans VARTABLE
;
; Sortie:
; A: Inchange
; X: Inchange
; Y: Inchange
;
; Externe:
; VARTABLE[]: Table des noms de variables
;---------------------------------------------------------------------------
										;'#iflused SetVarName';
#iflused SetVarName
										;'#echo Ajout SetVarName';
#echo Ajout SetVarName
										;SetVarName:
SetVarName
										; STACK .A, .X; " Sauvegarde A et X pour plus tard";
	PHA
	TXA
	PHA
										; SHIFT LEFT A;
	ASL A
										; .X = .A;
	TAX
										; VARNAME1 = VARTABLE[.X];
	LDA VARTABLE,X
	STA VARNAME1
										; INC .X;
	INX
										; VARNAME2 = VARTABLE[.X];
	LDA VARTABLE,X
	STA VARNAME2
										; UNSTACK .X, .A; " Restaure X & A";
	PLA
	TAX
	PLA
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; SetVar:
; Met a jour une variable flotante
;
; Entree:
; AY: Valeur entiere de la variable
; VARNAME1,VARNAME2: Nom de la variable
;---------------------------------------------------------------------------
										;'#iflused SetVar';
#iflused SetVar
										;'#echo Ajout SetVar';
#echo Ajout SetVar
										;SetVar:
SetVar
										; CALL GIVAYF; " Conversion Entier -> FACC1";
	JSR GIVAYF
										; CALL FindVar; " Recherche la variable (adresse en AY)";
	JSR FindVar
										; .X = .A;
	TAX
										; GOTO MOVMF; " MOVMF necessite que l'adresse soit en XY";
	JMP MOVMF
;RETURN;
										;'#endif';
#endif

;---------------------------------------------------------------------------
; PrintAY:
; Affiche une chaine a l'ecran
;
; Entree:
; AY: Adresse de la chaine
; X: Longueur de la chaine
;---------------------------------------------------------------------------
										;'#iflused PrintAY';
#iflused PrintAY
										;'#echo Ajout PrintAY';
#echo Ajout PrintAY
										;PrintAY:
PrintAY
										; H91 <-.AY; " AY: Adresse de la chaine";
	STA H91
	STY H91+1
	; X: Longueur de la chaine
										; GOTO PrintString_07;
	JMP PrintString_07
;RETURN;
										;'#endif';
#endif

;---------------------------------------------------------------------------
; Fin du Module
;---------------------------------------------------------------------------
										;EXIT;
;	END
