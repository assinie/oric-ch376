; -----------------------------------------------------------------------------
;
;                       Adresse de l'interface CH376
;
; -----------------------------------------------------------------------------

		;DEFINE CH376COMMAND = $341;
CH376COMMAND=$341
		;DEFINE CH376DATA = $340;
CH376DATA=$340


; -----------------------------------------------------------------------------
;
;                       Codes d'erreur du CH376
;
; -----------------------------------------------------------------------------
		;DEFINE SUCCESS = $12;
SUCCESS=$12
		;DEFINE INTSUCCESS = $14;
INTSUCCESS=$14
		;DEFINE INTDISKREAD = $1D;
INTDISKREAD=$1D
		;DEFINE INTDISKWRITE= $1E;
INTDISKWRITE=$1E
		;DEFINE ABORT = $5F;
ABORT=$5F

; -----------------------------------------------------------------------------
; GetByte:
;	Lit le prochain caractère du buffer
;
; Entree:
;
; Sortie:
;       ACC: Caractère lu
;       X  : Modifié (0 si appel à ReadUSBData2)
;       Y  : Inchangé
;       V  : 1 Fin du fichier atteinte
;       Z,N: Fonction du caractère lu
; -----------------------------------------------------------------------------
#iflused GETBYTE
#echo Ajout de GetByte
		;GETBYTE:
GETBYTE
		; TMP = .Y;
	STY TMP
		; .Y = PTR;
	LDY PTR
		; IFF .Y ^= PTRMAX THEN GETBYTE2;
	CPY PTRMAX
	BNE GETBYTE2
		; CALL BYTERDGO;
	JSR BYTERDGO
		; IFF .A = $14 THEN GETBYTEERR;
	CMP #$14
	BEQ GETBYTEERR
		; CALL READUSBDATA2;
	JSR READUSBDATA2
		; PTRMAX = .Y;
	STY PTRMAX
		; .Y = 0;
	LDY #0
		; PTR = .Y;
	STY PTR
		;GETBYTE2:
	GETBYTE2
		; .A = @PTRREADDEST[.Y];
	LDA (PTRREADDEST),Y
		; STACK .P; " Sauvegarde P sinon il est modifie par le .Y = TMP ";
	PHP
		; INC PTR;
	INC PTR
		; .Y = TMP;
	LDY TMP
		; UNSTACK .P;
	PLP
		;RETURN;
	RTS
		;GETBYTEERR:
	GETBYTEERR
		; 'BIT *-1';
	BIT *-1
		; .Y = TMP;
	LDY TMP
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; InitCH376:
;	Vérifie la présence du CH376 et monte la clé
;
; Entree:
;
; Sortie:
;
; -----------------------------------------------------------------------------
#iflused INITCH376
#echo Ajout de InitCH376

		;INITCH376:
INITCH376
		; CALL EXISTS;
	JSR EXISTS
		; IF .Z THEN
	BNE ZZZ001
		; BEGIN;
		; CALL SETUSB;
	JSR SETUSB
		; CALL MOUNT;
	JSR MOUNT
		; "IFF ^.Z THEN InitError;";
		; END;
		;INITERROR:
	ZZZ001
	INITERROR
		; ERRNO = .A;
	STA ERRNO
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; GetVersion:
;	Recupere la version du ch376
;
; Entree:
;
; Sortie:
;	ACC: Version + $40
;
; -----------------------------------------------------------------------------
#iflused GETVERSION
#echo Ajout de GetVersion
		;GETVERSION:
GETVERSION
		; CH376COMMAND = $01;
	LDA #$01
	STA CH376COMMAND
		; .A = CH376DATA;
	LDA CH376DATA
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; ResetAll:
;	Reset du ch376
;
; Entree:
;
; Sortie:
;	ACC: $05
;
; -----------------------------------------------------------------------------
#iflused RESETALL
#echo Ajout de ResetAll
		;RESETALL:
RESETALL
		; CH376COMMAND = $05;
	LDA #$05
	STA CH376COMMAND
		; "Wait 35ms";
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; Exists:
;	Teste la presence du CH376
;
; Entree:
;
; Sortie:
;	ACC: $00-> OK, $FF-> NOK
;	Z  : 1 -> OK, 0 -> NOK
;	N  : 0 -> OK, 1 -> NOK
; -----------------------------------------------------------------------------
#iflused EXISTS
#echo Ajout de Exists
		;EXISTS:
EXISTS
		; CH376COMMAND = 6;
	LDA #6
	STA CH376COMMAND
		; CH376DATA = $FF;
	LDA #$FF
	STA CH376DATA
		; .A = CH376DATA;
	LDA CH376DATA
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; GetFileSize:
;	Récupère la taille du fichier courant
;
; Entree:
;
; Sortie:
;	ACC: Modifié (octet de poids fort)
; 	OFFSET[]: Taille du fichier
;
; -----------------------------------------------------------------------------
#iflused GETFILESIZE
#echo Ajout de GetFileSize
		;GETFILESIZE:
GETFILESIZE
		; CH376COMMAND = $0C;
	LDA #$0C
	STA CH376COMMAND
		; CH376DATA = $68;
	LDA #$68
	STA CH376DATA
		; OFFSET0 = CH376DATA;
	LDA CH376DATA
	STA OFFSET0
		; OFFSETL = CH376DATA;
	LDA CH376DATA
	STA OFFSETL
		; OFFSETH = CH376DATA;
	LDA CH376DATA
	STA OFFSETH
		; OFFSET3 = CH376DATA;
	LDA CH376DATA
	STA OFFSET3
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; SetUSB:
;	Passe en mode USB
;
; Entree:
;
; Sortie:
;	ACC: $51 -> OK
;	Z  : 1 -> OK, 0 -> NOK
; -----------------------------------------------------------------------------
#iflused SETUSB
#echo Ajout de SetUSB
		;SETUSB:
SETUSB
		; CH376COMMAND = $15;
	LDA #$15
	STA CH376COMMAND
		; CH376DATA = 6;
	LDA #6
	STA CH376DATA
		; "Wait 10us";
		; 'NOP';
	NOP
		; 'NOP';
	NOP
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; SetSD:
;	Passe en mode SD
;
; Entree:
;
; Sortie:
;	ACC: $51 -> OK
;	Z  : 1 -> OK, 0 -> NOK
; -----------------------------------------------------------------------------
#iflused SETSD
#echo Ajout de SetSD
		;SETSD:
SETSD
		; CH376COMMAND = $15;
	LDA #$15
	STA CH376COMMAND
		; CH376DATA = 3;
	LDA #3
	STA CH376DATA
		; "Wait 10us";
		; 'NOP';
	NOP
		; 'NOP';
	NOP
		;RETURN;
	RTS
#endif


; -----------------------------------------------------------------------------
; ReadUSBData:
;
; Entree:
;	AY : Adresse du tampon destination
;
; Sortie:
;	ACC: Dernier octet lu ou 0 ou $27
;	X  : 0
;	Y  : Nombre d'octets lus ou 0
;	Z  : 1
; -----------------------------------------------------------------------------
#iflused READUSBDATA
#echo Ajout de ReadUSBData
		;READUSBDATA:
READUSBDATA
		; PTRREADDEST <- .AY;
	STA PTRREADDEST
	STY PTRREADDEST+1
		;READUSBDATA2:
	READUSBDATA2
		; .Y = 0;
	LDY #0
		; PTR = .Y; "Pointeur pour GetByte";
	STY PTR
		; CH376COMMAND = $27;
	LDA #$27
	STA CH376COMMAND
		; .X = CH376DATA;
	LDX CH376DATA
		; IF ^.Z THEN
	BEQ ZZZ002
		; BEGIN;
		; REPEAT;
	ZZZ003
		; DO;
		; .A = CH376DATA;
	LDA CH376DATA
		; "&PTRREADDEST[.Y] = CH376COMMAND;";
		; 'STA (PTRREADDEST),Y';
	STA (PTRREADDEST),Y
		; .Y+1;
	INY
		; .X-1;
	DEX
		; END;
		; UNTIL .Z;
	BNE ZZZ003
		; PTRMAX = .Y; "Pour GetByte";
	STY PTRMAX
		; END;
		;RETURN;
	ZZZ002
	RTS
#endif

; -----------------------------------------------------------------------------
; WriteReqData:
;
; Entree:
;	AY : Adresse du tampon source
;
; Sortie:
;	ACC: Dernier octet écrit ou 0 ou $27
;	X  : 0
;	Y  : Nombre d'octets écrits ou 0
;	Z  : 1
; -----------------------------------------------------------------------------
#iflused WRITEREQDATA
#echo Ajout de WriteReqData
		;WRITEREQDATA:
WRITEREQDATA
		; PTRWRITESRC <- .AY;
	STA PTRWRITESRC
	STY PTRWRITESRC+1
		;WRITEUSBDATA2:
	WRITEREQDATA2
		; .Y = 0;
	LDY #0
		; CH376COMMAND = $2D;
	LDA #$2D
	STA CH376COMMAND
		; CH376DATA = .X;
	LDX CH376DATA
		; PTW = .Y; "Pointeur pour PutByte";
	STX PTWMAX
		; IF ^.Z THEN
	BEQ ZZZ004
		; BEGIN;
		; REPEAT;
	ZZZ005
		; DO;
		; .A = @PTRWRITESRC[.Y];
	LDA (PTRWRITESRC),Y
		; CH376DATA = .A;
	STA CH376DATA
		; .Y+1;
	INY
		; .X-1;
	DEX
		; END;
		; UNTIL .Z;
	BNE ZZZ005
		; PTWMAX = .Y; "Pour PutByte";
	STY PTW
		; END;
		;RETURN;
	ZZZ004
	RTS
#endif

; -----------------------------------------------------------------------------
; SetFilename (variante2, avec limite de longueur a 12)
;
; Entree:
;	AY: Adresse du Tampon, fin avec \0
;
; Sortie:
;	ACC: 0
;	Y: Longueur du tampon
;	Z: 1
; -----------------------------------------------------------------------------
#iflused SETFILENAME
#echo Ajout de SetFilename
		;SETFILENAME:
SETFILENAME
		; PTRREADDEST <- .AY;
	STA PTRREADDEST
	STY PTRREADDEST+1
		; CH376COMMAND = $2F;
	LDA #$2F
	STA CH376COMMAND
		; .Y = $FF;
	LDY #$FF
		; REPEAT;
	ZZZ006
		; DO;
		; INC .Y;
	INY
		; 'CPY #13';
	CPY #13
		; IF .Z THEN .A=0;
	BNE ZZZ007
	LDA #0
		; IF ^.Z THEN .A = @PTRREADDEST[.Y];
	ZZZ007
	BEQ ZZZ008
	LDA (PTRREADDEST),Y
		; CH376DATA = .A;
	ZZZ008
	STA CH376DATA
		; END;
		; UNTIL .Z;
	BNE ZZZ006
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; Mount:
;	Monte le volume
;
;  A faire suivre par un appel a ReadUSBData pour lire les infos du volume
;
; Entree:
;
; Sortie:
;	ACC: $14 -> OK, $1F? -> NOK
;	Z  : 1 -> OK, 0 -> NOK
;       X,Y: Modifies
; -----------------------------------------------------------------------------
#iflused MOUNT
#echo Ajout de Mount
		;MOUNT:
MOUNT
		; CH376COMMAND = $31;
	LDA #$31
	STA CH376COMMAND
		; CALL WAITRESPONSE;
	JSR WAITRESPONSE
		; 'CMP #INTSUCCESS';
	CMP #INTSUCCESS
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; FileOpen
;	FileOpen('/')    -> ERR_OPEN_DIR ($41)
;	FileOpen('DIR')  -> ERR_OPEN_DIR ($41)
;	FileOpen('FILE') -> INT_SUCCESS ($14)
;	FileOpen('*')    -> INT_DISK_READ ($1d)
;	Si le fichier ou le répertoire n'existe pas -> ERR_MISS_FILE ($42)
;
; cmp #$41
;	$14 -> N=1, Z=0, C=0
;	$41 -> Z=1, C=1
;	$42 -> Z=0, C=1
;       X,Y: Modifies
; -----------------------------------------------------------------------------
#iflused FILEOPEN
#echo Ajout de FileOpen
		;FILEOPEN:
FILEOPEN
		; CH376COMMAND = $32;
	LDA #$32
	STA CH376COMMAND
		; GOTO WAITRESPONSE;
	JMP WAITRESPONSE
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; FileEnumGo:
;	Ok -> INT_DISK_READ ($1d)
;	Plus de fichier -> ERR_MISS_FILE ($42) d'après la doc,
;	ERR_OPEN_DIR ($41) d'après Oricutron
;
; Entree:
;
; Sortie:
;	ACC: $1d -> Ok
;	Z  : 1 -> OK, 0 -> NOK
;       X,Y: Modifies
; -----------------------------------------------------------------------------
#iflused FILEENUMGO
#echo Ajout de FileEnumGo
		;FILEENUMGO:
FILEENUMGO
		; CH376COMMAND = $33;
	LDA #$33
	STA CH376COMMAND
		; CALL WAITRESPONSE;
	JSR WAITRESPONSE
		; 'CMP #INTDISKREAD';
	CMP #INTDISKREAD
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; FileCreate
;
; Entree:
;
; Sortie:
;	ACC : -> INT_SUCCESS ($14)
;	Z  : 1 -> OK, 0 -> NOK
;       X,Y: Modifies
; -----------------------------------------------------------------------------
#iflused FILECREATE
#echo Ajout de FileCreate
		;FILECREATE:
FILECREATE
		; CH376COMMAND = $34;
	LDA #$34
	STA CH376COMMAND
		; CALL WAITRESPONSE;
	JSR WAITRESPONSE
		; 'CMP #INTSUCCESS';
	CMP #INTSUCCESS
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; FileErase
;
; Entree:
;
; Sortie:
;	ACC : -> INT_SUCCESS ($14)
;	Z  : 1 -> OK, 0 -> NOK
;       X,Y: Modifies
; -----------------------------------------------------------------------------
#iflused FILEERASE
#echo FileErase
		;FILEERASE:
FILEERASE
		; CH376COMMAND = $35;
	LDA #$35
	STA CH376COMMAND
		; CALL WAITRESPONSE;
	JSR WAITRESPONSE
		; 'CMP #INTSUCCESS';
	CMP #INTSUCCESS
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; FileClose
;	FileClose(0) -> Pas de mise à jour de la taille du fichier
;	FileClose(1) -> Mise à jour de la taille du fichier
;
;	Ok -> INT_SUCCESS ($14)
;
;       X,Y: Modifies
; -----------------------------------------------------------------------------
#iflused FILECLOSE
#echo Ajout de FileClose
		;FILECLOSE:
FILECLOSE
		; STACK .A;
	PHA
		; CH376COMMAND = $36;
	LDA #$36
	STA CH376COMMAND
		; UNSTACK CH376DATA;
	PLA
	STA CH376DATA
		; CALL WAITRESPONSE;
	JSR WAITRESPONSE
		; 'CMP #INTSUCCESS';
	CMP #INTSUCCESS
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; ByteLocate
;
; Entree:
;	AY: Offset
;
; Sortie:
;       A,X,Y: Modifies
;
; -----------------------------------------------------------------------------
#iflused BYTELOCATE
#echo Ajout de ByteLocate
		;BYTELOCATE:
BYTELOCATE
		; CH376COMMAND = $39;
	LDA #$39
	STA CH376COMMAND
		; CH376DATA = OFFSET0;
	LDA OFFSET0
	STA CH376DATA
		; CH376DATA = OFFSETL;
	LDA OFFSETL
	STA CH376DATA
		; CH376DATA = OFFSETH;
	LDA OFFSETH
	STA CH376DATA
		; CH376DATA = OFFSET3;
	LDA OFFSET3
	STA CH376DATA
		; CALL WAITRESPONSE;
	JSR WAITRESPONSE
		; 'CMP #INTSUCCESS';
	CMP #INTSUCCESS
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; fseek:
;	Déplacement (absolu) du pointeur du fichier
;
; Entree:
;	AY: Offset
;
; Sortie:
;       A,X,Y: Modifies
;
; -----------------------------------------------------------------------------
#iflused FSEEK
#echo Ajout de fseek
		;FSEEK:
FSEEK
		; STACK .A;
	PHA
		; CH376COMMAND = $39;
	LDA #$39
	STA CH376COMMAND
		; UNSTACK .A;
	PLA
		; CH376DATA = .A;
	STA CH376DATA
		; CH376DATA = .Y;
	STY CH376DATA
		; CH376DATA = 0;
	LDA #0
	STA CH376DATA
		; CH376DATA = 0;
	LDA #0
	STA CH376DATA
		; CALL WAITRESPONSE;
	JSR WAITRESPONSE
		; 'CMP #INTSUCCESS';
	CMP #INTSUCCESS
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; SetByteRead
;
; Entree:
;	AY: Nombre d'octets a lire (.A = LSB, .Y = MSB)
;
; Sortie:
;	ACC: 0
;       X,Y: Modifies
; -----------------------------------------------------------------------------
#iflused SETBYTEREAD
#echo Ajout de SetByteRead
		;SETBYTEREAD:
SETBYTEREAD
		; STACK .A;
	PHA
		; CH376COMMAND = $3A;
	LDA #$3A
	STA CH376COMMAND
		; UNSTACK .A;
	PLA
		; CH376DATA = .A;
	STA CH376DATA
		; CH376DATA = .Y;
	STY CH376DATA
		; CH376DATA = 0;
	LDA #0
	STA CH376DATA
		; CH376DATA = 0;
	LDA #0
	STA CH376DATA
		; CALL WAITRESPONSE;
	JSR WAITRESPONSE
		; 'CMP #INTDISKREAD';
	CMP #INTDISKREAD
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; ByteRdGo
;	Ok -> INT_DISK_READ ($1d)
;	Plus de données -> INT_SUCCESS ($14)
;       X,Y: Modifies
; -----------------------------------------------------------------------------
#iflused BYTERDGO
#echo Ajout de ByteRdGo
		;BYTERDGO:
BYTERDGO
		; CH376COMMAND = $3B;
	LDA #$3B
	STA CH376COMMAND
		; CALL WAITRESPONSE;
	JSR WAITRESPONSE
		; 'CMP #INTDISKREAD';
	CMP #INTDISKREAD
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
; SetByteWrite
;
; Entree:
;	AY: Nombre d'octets a écrire (.A = LSB, .Y = MSB)
;
; Sortie:
;	ACC: 0
;       X,Y: Modifies
; -----------------------------------------------------------------------------
#iflused SETBYTEWRITE
#echo Ajout de SetByteWrite
		;SETBYTEWRITE:
SETBYTEWRITE
		; STACK .A;
	PHA
		; CH376COMMAND = $3C;
	LDA #$3C
	STA CH376COMMAND
		; UNSTACK .A;
	PLA
		; CH376DATA = .A;
	STA CH376DATA
		; CH376DATA = .Y;
	STY CH376DATA
		; CH376DATA = 0;
	LDA #0
	STA CH376DATA
		; CH376DATA = 0;
	LDA #0
	STA CH376DATA
		; CALL WAITRESPONSE;
	JSR WAITRESPONSE
		; 'CMP #INTDISKREAD';
	CMP #INTDISKREAD
		;RETURN;
	RTS
#endif


; -----------------------------------------------------------------------------
; ByteWrGo
;	Ok -> INT_DISK_READ ($1d)
;	Plus de données -> INT_SUCCESS ($14)
;       X,Y: Modifies
; -----------------------------------------------------------------------------
#iflused BYTEWRGO
#echo Ajout de ByteWrGo
		;BYTEWRGO:
BYTEWRGO
		; CH376COMMAND = $3D;
	LDA #$3D
	STA CH376COMMAND
		; CALL WAITRESPONSE;
	JSR WAITRESPONSE
		; 'CMP #INTDISKWRITE';
	CMP #INTDISKWRITE
		;RETURN;
	RTS
#endif


; -----------------------------------------------------------------------------
; WaitResponse:
;	A voir si il faut préserver X et Y
;
; Entree:
;
; Sortie:
;	Z: 0 -> ACC: Status du CH376
;	Z: 1 -> Timeout
;       X,Y: Modifies
; -----------------------------------------------------------------------------
#iflused WAITRESPONSE
#echo Ajout de WaitResponse
		;WAITRESPONSE:
WAITRESPONSE
		; .Y = $FF;
	LDY #$FF
		; REPEAT;
	ZZZ009
		; DO;
		; .X=$FF;
	LDX #$FF
		; REPEAT;
	ZZZ010
		; DO;
		; .A = CH376COMMAND;
	LDA CH376COMMAND
		; IF + THEN
	BMI ZZZ011
		; BEGIN;
		; CH376COMMAND = $22;
	LDA #$22
	STA CH376COMMAND
		; .A = CH376DATA;
	LDA CH376DATA
		; RETURN;
	RTS
		; END;
		; DEC .X;
	ZZZ011
	DEX
		; END;
		; UNTIL .Z;
	BNE ZZZ010
		; DEC .Y;
	DEY
		; END;
		; UNTIL .Z;
	BNE ZZZ009
		;RETURN;
	RTS
#endif


