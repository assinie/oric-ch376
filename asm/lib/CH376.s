										;'#define WOR word';
#define WOR word
										;'#include <include/CH376.h>';
#include <include/CH376.h>

;---------------------------------------------------------------------------
;
; Variables en page 0
;
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;
; Adresses des Buffers ou Tables
;
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;
; Adresse de l'interface CH376
;
;---------------------------------------------------------------------------
										;DEFINE CH376_COMMAND = $341;
CH376_COMMAND=$341
										;DEFINE CH376_DATA = $340;
CH376_DATA=$340


;---------------------------------------------------------------------------
;
; Codes d'erreur du CH376
;
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;
; Variables et buffers
;
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;
; Debut du programme
;
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
; GetByte:
; Lit le prochain caractere du buffer
;
; Entree:
;
; Sortie:
; ACC: Caractere lu
; X : Modifie (0 si appel a ReadUSBData2)
; Y : Inchange
; V : 1 Fin du fichier atteinte
; Z,N: Fonction du caractere lu
;
;---------------------------------------------------------------------------
										;'#iflused GetByte';
#iflused GetByte
										;'#echo Ajout GetByte';
#echo Ajout GetByte
										;GetByte:
GetByte
										; TMP = .Y;
	STY TMP
										; .Y = PTR;
	LDY PTR
										; IFF .Y ^= PTR_MAX THEN GetByte2;
	CPY PTR_MAX
	BNE GetByte2
										; CALL ByteRdGo;
	JSR ByteRdGo
										; IFF .A = $14 THEN GetByteErr;
	CMP #$14
	BEQ GetByteErr
										; CALL ReadUSBData2;
	JSR ReadUSBData2
										; PTR_MAX = .Y;
	STY PTR_MAX
										; .Y = 0;
	LDY #0
										; PTR = .Y;
	STY PTR
										;GetByte2:
GetByte2
										; .A = @PTR_READ_DEST[.Y];
	LDA (PTR_READ_DEST),Y
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
										;GetByteErr:
GetByteErr
										; 'BIT *-1';
	BIT *-1
										; .Y = TMP;
	LDY TMP
										;RETURN;
	RTS
										;'#endif';
#endif

;===========================================================================
;
; Fonctions bas niveau
;
;===========================================================================
;---------------------------------------------------------------------------
; InitCH376:
; Verifie la presence du CH376 et monte la cle
;
; Entree:
;
; Sortie:
;
;---------------------------------------------------------------------------
										;'#iflused InitCH376';
#iflused InitCH376
										;'#echo Ajout InitCH376';
#echo Ajout InitCH376
										;InitCH376:
InitCH376
										; CALL Exists;
	JSR Exists
										; IF .Z THEN
	BNE ZZZ001
										; BEGIN;
										; CALL SetUSB;
	JSR SetUSB
										; CALL Mount;
	JSR Mount

	;IFF ^.Z THEN InitError;
										; END;
										;InitError:
ZZZ001
InitError
										; ERRNO = .A;
	STA ERRNO
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; GetVersion:
; Recupere la version du ch376
;
; Entree:
;
; Sortie:
; ACC: Version + $40
;
;---------------------------------------------------------------------------
										;'#iflused GetVersion';
#iflused GetVersion
										;'#echo Ajout GetVersion';
#echo Ajout GetVersion
										;GetVersion:
GetVersion
										; CH376_COMMAND = $01;
	LDA #$01
	STA CH376_COMMAND
										; .A = CH376_DATA;
	LDA CH376_DATA
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; ResetAll:
; Reset du ch376
;
; Entree:
;
; Sortie:
; ACC: $05
;
;---------------------------------------------------------------------------
										;'#iflused ResetAll';
#iflused ResetAll
										;'#echo Ajout ResetAll';
#echo Ajout ResetAll
										;ResetAll:
ResetAll
										; CH376_COMMAND = $05;
	LDA #$05
	STA CH376_COMMAND

	;Wait 35ms
										;RETURN;
	RTS
										;'#endif';
#endif
;---------------------------------------------------------------------------
; Exists:
; Teste la presence du CH376
;
; Entree:
;
; Sortie:
; ACC: $00-> OK, $FF-> NOK
; Z : 1 -> OK, 0 -> NOK
; N : 0 -> OK, 1 -> NOK
;---------------------------------------------------------------------------
										;'#iflused Exists';
#iflused Exists
										;'#echo Ajout Exists';
#echo Ajout Exists
										;Exists:
Exists
										; CH376_COMMAND = 6;
	LDA #6
	STA CH376_COMMAND
										; CH376_DATA = $FF;
	LDA #$FF
	STA CH376_DATA
										; .A = CH376_DATA;
	LDA CH376_DATA
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; GetFileSize:
; Recupere la taille du fichier courant
;
; Entree:
;
; Sortie:
; ACC: Modifie (octet de poids fort)
; OFFSET[]: Taille du fichier
;
;---------------------------------------------------------------------------
										;'#iflused GetFileSize';
#iflused GetFileSize
										;'#echo Ajout GetFileSize';
#echo Ajout GetFileSize
										;GetFileSize:
GetFileSize
										; CH376_COMMAND = $0C;
	LDA #$0C
	STA CH376_COMMAND
										; CH376_DATA = $68;
	LDA #$68
	STA CH376_DATA
										; OFFSET_0 = CH376_DATA;
	LDA CH376_DATA
	STA OFFSET_0
										; OFFSET_L = CH376_DATA;
	LDA CH376_DATA
	STA OFFSET_L
										; OFFSET_H = CH376_DATA;
	LDA CH376_DATA
	STA OFFSET_H
										; OFFSET_3 = CH376_DATA;
	LDA CH376_DATA
	STA OFFSET_3
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; SetUSB:
; Passe en mode USB
;
; Entree:
;
; Sortie:
; ACC: $51 -> OK
; Z : 1 -> OK, 0 -> NOK
;---------------------------------------------------------------------------
										;'#iflused SetUSB';
#iflused SetUSB
										;'#echo Ajout SetUSB';
#echo Ajout SetUSB
										;SetUSB:
SetUSB
										; CH376_COMMAND = $15;
	LDA #$15
	STA CH376_COMMAND
										; CH376_DATA = 6;
	LDA #6
	STA CH376_DATA

	;Wait 10us
										; 'NOP';
	NOP
										; 'NOP';
	NOP
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; SetSD:
; Passe en mode SD
;
; Entree:
;
; Sortie:
; ACC: $51 -> OK
; Z : 1 -> OK, 0 -> NOK
;---------------------------------------------------------------------------
										;'#iflused SetSD';
#iflused SetSD
										;'#echo Ajout SetSD';
#echo Ajout SetSD
										;SetSD:
SetSD
										; CH376_COMMAND = $15;
	LDA #$15
	STA CH376_COMMAND
										; CH376_DATA = 3;
	LDA #3
	STA CH376_DATA

	;Wait 10us
										; 'NOP';
	NOP
										; 'NOP';
	NOP
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; GetStatus:
; Inutile ici
;
; Remplace par WaitResponse
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
; ReadUSBData:
;
; Entree:
; AY : Adresse du tampon destination
;
; Sortie:
; ACC: Dernier octet lu ou 0 ou $27
; X : 0
; Y : Nombre d'octets lus ou 0
; Z : 1
;---------------------------------------------------------------------------
										;'#iflused ReadUSBData';
#iflused ReadUSBData
										;'#echo Ajout ReadUSBData';
#echo Ajout ReadUSBData
										;ReadUSBData:
ReadUSBData
										; PTR_READ_DEST <- .AY;
	STA PTR_READ_DEST
	STY PTR_READ_DEST+1
										;ReadUSBData2:
ReadUSBData2
										; .Y = 0;
	LDY #0
										; PTR = .Y; "Pointeur pour GetByte";
	STY PTR
										; CH376_COMMAND = $27;
	LDA #$27
	STA CH376_COMMAND
										; .X = CH376_DATA;
	LDX CH376_DATA
										; IF ^.Z THEN
	BEQ ZZZ002
										; BEGIN;
										; REPEAT;
ZZZ003
										; DO;
										; .A = CH376_DATA;
	LDA CH376_DATA

	;&PTR_READ_DEST[.Y] = CH376_COMMAND;
										; 'STA (PTR_READ_DEST),Y';
	STA (PTR_READ_DEST),Y
										; .Y+1;
	INY
										; .X-1;
	DEX
										; END;
										; UNTIL .Z;
	BNE ZZZ003
										; PTR_MAX = .Y; "Pour GetByte";
	STY PTR_MAX
										; END;
										;RETURN;
ZZZ002
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; WriteReqData:
;
; Entree:
; AY : Adresse du tampon source
;
; Sortie:
; ACC: Dernier octet ecrit ou 0 ou $27
; X : 0
; Y : Nombre d'octets ecrits ou 0
; Z : 1
;---------------------------------------------------------------------------
										;'#iflused WriteReqData';
#iflused WriteReqData
										;'#echo Ajout WriteReqData';
#echo Ajout WriteReqData
										;WriteReqData:
WriteReqData
										; PTR_WRITE_SRC <- .AY;
	STA PTR_WRITE_SRC
	STY PTR_WRITE_SRC+1
										;WriteReqData2:
WriteReqData2
										; .Y = 0;
	LDY #0
										; CH376_COMMAND = $2D;
	LDA #$2D
	STA CH376_COMMAND
										; .X = CH376_DATA;
	LDX CH376_DATA
										; PTW_MAX = .X; "Pointeur pour PutByte";
	STX PTW_MAX
										; IF ^.Z THEN
	BEQ ZZZ004
										; BEGIN;
										; REPEAT;
ZZZ005
										; DO;
										; .A = @PTR_WRITE_SRC[.Y];
	LDA (PTR_WRITE_SRC),Y
										; CH376_DATA = .A;
	STA CH376_DATA
										; .Y+1;
	INY
										; .X-1;
	DEX
										; END;
										; UNTIL .Z;
	BNE ZZZ005
										; PTW = .Y; "Pour PutByte";
	STY PTW
										; END;
										;RETURN;
ZZZ004
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; SetFilename (variante2, avec limite de longueur a 12)
;
; Entree:
; AY: Adresse du Tampon, fin avec \0
;
; Sortie:
; ACC: 0
; Y: Longueur du tampon
; Z: 1
;---------------------------------------------------------------------------
										;'#iflused SetFilename';
#iflused SetFilename
										;'#echo Ajout SetFilename';
#echo Ajout SetFilename
										;SetFilename:
SetFilename
										; PTR_READ_DEST <- .AY;
	STA PTR_READ_DEST
	STY PTR_READ_DEST+1
										; CH376_COMMAND = $2F;
	LDA #$2F
	STA CH376_COMMAND
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
										; IF ^.Z THEN .A = @PTR_READ_DEST[.Y];
ZZZ007
	BEQ ZZZ008
	LDA (PTR_READ_DEST),Y
										; CH376_DATA = .A;
ZZZ008
	STA CH376_DATA
										; END;
										; UNTIL .Z;
	BNE ZZZ006
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; Mount:
; Monte le volume
;
; A faire suivre par un appel a ReadUSBData pour lire les infos du volume
;
; Entree:
;
; Sortie:
; ACC: $14 -> OK, $1F? -> NOK
; Z : 1 -> OK, 0 -> NOK
; X,Y: Modifies
;---------------------------------------------------------------------------
										;'#iflused Mount';
#iflused Mount
										;'#echo Ajout Mount';
#echo Ajout Mount
										;Mount:
Mount
										; CH376_COMMAND = $31;
	LDA #$31
	STA CH376_COMMAND
										; CALL WaitResponse;
	JSR WaitResponse
										; 'CMP #INT_SUCCESS';
	CMP #INT_SUCCESS
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; FileOpen
; FileOpen('/') -> ERR_OPEN_DIR ($41)
; FileOpen('DIR') -> ERR_OPEN_DIR ($41)
; FileOpen('FILE') -> INT_SUCCESS ($14)
; FileOpen('*') -> INT_DISK_READ ($1d)
; Si le fichier ou le repertoire n'existe pas -> ERR_MISS_FILE ($42)
;
; cmp #$41
; $14 -> N=1, Z=0, C=0
; $41 -> Z=1, C=1
; $42 -> Z=0, C=1
; X,Y: Modifies
;---------------------------------------------------------------------------
										;'#iflused FileOpen';
#iflused FileOpen
										;'#echo Ajout FileOpen';
#echo Ajout FileOpen
										;FileOpen:
FileOpen
										; CH376_COMMAND = $32;
	LDA #$32
	STA CH376_COMMAND
										; GOTO WaitResponse;
	JMP WaitResponse
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; FileEnumGo:
; Ok -> INT_DISK_READ ($1d)
; Plus de fichier -> ERR_MISS_FILE ($42) d'apres la doc,
; ERR_OPEN_DIR ($41) d'apres Oricutron
;
; Entree:
;
; Sortie:
; ACC: $1d -> Ok
; Z : 1 -> OK, 0 -> NOK
; X,Y: Modifies
;---------------------------------------------------------------------------
										;'#iflused FileEnumGo';
#iflused FileEnumGo
										;'#echo Ajout FileEnumGo';
#echo Ajout FileEnumGo
										;FileEnumGo:
FileEnumGo
										; CH376_COMMAND = $33;
	LDA #$33
	STA CH376_COMMAND
										; CALL WaitResponse;
	JSR WaitResponse
										; 'CMP #INT_DISK_READ';
	CMP #INT_DISK_READ
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; FileCreate
;
; Entree:
;
; Sortie:
; ACC : -> INT_SUCCESS ($14)
; Z : 1 -> OK, 0 -> NOK
; X,Y: Modifies
;---------------------------------------------------------------------------
										;'#iflused FileCreate';
#iflused FileCreate
										;'#echo Ajout FileCreate';
#echo Ajout FileCreate
										;FileCreate:
FileCreate
										; CH376_COMMAND = $34;
	LDA #$34
	STA CH376_COMMAND
										; CALL WaitResponse;
	JSR WaitResponse
										; 'CMP #INT_SUCCESS';
	CMP #INT_SUCCESS
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; FileErase
;
; Entree:
;
; Sortie:
; ACC : -> INT_SUCCESS ($14)
; Z : 1 -> OK, 0 -> NOK
; X,Y: Modifies
;---------------------------------------------------------------------------
										;'#iflused FileErase';
#iflused FileErase
										;'#echo Ajout FileErase';
#echo Ajout FileErase
										;FileErase:
FileErase
										; CH376_COMMAND = $35;
	LDA #$35
	STA CH376_COMMAND
										; CALL WaitResponse;
	JSR WaitResponse
										; 'CMP #INT_SUCCESS';
	CMP #INT_SUCCESS
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; FileClose
; FileClose(0) -> Pas de mise a jour de la taille du fichier
; FileClose(1) -> Mise a jour de la taille du fichier
;
; Ok -> INT_SUCCESS ($14)
;
; X,Y: Modifies
;---------------------------------------------------------------------------
										;'#iflused FileClose';
#iflused FileClose
										;'#echo Ajout FileClose';
#echo Ajout FileClose
										;FileClose:
FileClose
										; STACK .A;
	PHA
										; CH376_COMMAND = $36;
	LDA #$36
	STA CH376_COMMAND
										; UNSTACK CH376_DATA;
	PLA
	STA CH376_DATA
										; CALL WaitResponse;
	JSR WaitResponse
										; 'CMP #INT_SUCCESS';
	CMP #INT_SUCCESS
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; ByteLocate
;
; Entree:
; AY: Offset
;
; Sortie:
; A,X,Y: Modifies
;
;---------------------------------------------------------------------------
										;'#iflused ByteLocate';
#iflused ByteLocate
										;'#echo Ajout ButeLocate';
#echo Ajout ButeLocate
										;ByteLocate:
ByteLocate
										; CH376_COMMAND = $39;
	LDA #$39
	STA CH376_COMMAND
										; CH376_DATA = OFFSET_0;
	LDA OFFSET_0
	STA CH376_DATA
										; CH376_DATA = OFFSET_L;
	LDA OFFSET_L
	STA CH376_DATA
										; CH376_DATA = OFFSET_H;
	LDA OFFSET_H
	STA CH376_DATA
										; CH376_DATA = OFFSET_3;
	LDA OFFSET_3
	STA CH376_DATA
										; CALL WaitResponse;
	JSR WaitResponse
										; 'CMP #INT_SUCCESS';
	CMP #INT_SUCCESS
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; fseek:
; Deplacement (absolu) du pointeur du fichier
;
; Entree:
; AY: Offset
;
; Sortie:
; A,X,Y: Modifies
;
;---------------------------------------------------------------------------
										;'#iflused fseek';
#iflused fseek
										;'#echo Ajout fseek';
#echo Ajout fseek
										;fseek:
fseek
										; STACK .A;
	PHA
										; CH376_COMMAND = $39;
	LDA #$39
	STA CH376_COMMAND
										; UNSTACK .A;
	PLA
										; CH376_DATA = .A;
	STA CH376_DATA
										; CH376_DATA = .Y;
	STY CH376_DATA
										; CH376_DATA = 0;
	LDA #0
	STA CH376_DATA
										; CH376_DATA = 0;
	LDA #0
	STA CH376_DATA
										; CALL WaitResponse;
	JSR WaitResponse
										; 'CMP #INT_SUCCESS';
	CMP #INT_SUCCESS
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; SetByteRead
;
; Entree:
; AY: Nombre d'octets a lire (.A = LSB, .Y = MSB)
;
; Sortie:
; ACC: 0
; X,Y: Modifies
;---------------------------------------------------------------------------
										;'#iflused SetByteRead';
#iflused SetByteRead
										;'#echo Ajout SetByteRead';
#echo Ajout SetByteRead
										;SetByteRead:
SetByteRead
										; STACK .A;
	PHA
										; CH376_COMMAND = $3A;
	LDA #$3A
	STA CH376_COMMAND
										; UNSTACK .A;
	PLA
										; CH376_DATA = .A;
	STA CH376_DATA
										; CH376_DATA = .Y;
	STY CH376_DATA
										; CH376_DATA = 0;
	LDA #0
	STA CH376_DATA
										; CH376_DATA = 0;
	LDA #0
	STA CH376_DATA
										; CALL WaitResponse;
	JSR WaitResponse
										; 'CMP #INT_DISK_READ';
	CMP #INT_DISK_READ
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; ByteRdGo
; Ok -> INT_DISK_READ ($1d)
; Plus de donnees -> INT_SUCCESS ($14)
; X,Y: Modifies
;---------------------------------------------------------------------------
										;'#iflused ByteRdGo';
#iflused ByteRdGo
										;'#echo Ajout ByteRdGo';
#echo Ajout ByteRdGo
										;ByteRdGo:
ByteRdGo
										; CH376_COMMAND = $3B;
	LDA #$3B
	STA CH376_COMMAND
										; CALL WaitResponse;
	JSR WaitResponse
										; 'CMP #INT_DISK_READ';
	CMP #INT_DISK_READ
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; SetByteWrite
;
; Entree:
; AY: Nombre d'octets a ecrire (.A = LSB, .Y = MSB)
;
; Sortie:
; ACC: 0
; X,Y: Modifies
;---------------------------------------------------------------------------
										;'#iflused SetByteWrite';
#iflused SetByteWrite
										;'#echo Ajout SetByteWrite';
#echo Ajout SetByteWrite
										;SetByteWrite:
SetByteWrite
										; STACK .A;
	PHA
										; CH376_COMMAND = $3C;
	LDA #$3C
	STA CH376_COMMAND
										; UNSTACK .A;
	PLA
										; CH376_DATA = .A;
	STA CH376_DATA
										; CH376_DATA = .Y;
	STY CH376_DATA
										; CH376_DATA = 0;
	LDA #0
	STA CH376_DATA
										; CH376_DATA = 0;
	LDA #0
	STA CH376_DATA
										; CALL WaitResponse;
	JSR WaitResponse
										; 'CMP #INT_DISK_READ';
	CMP #INT_DISK_READ
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; ByteWrGo
; Ok -> INT_DISK_READ ($1d)
; Plus de donnees -> INT_SUCCESS ($14)
; X,Y: Modifies
;---------------------------------------------------------------------------
										;'#iflused ByteWrGo';
#iflused ByteWrGo
										;'#echo Ajout ByteWrGo';
#echo Ajout ByteWrGo
										;ByteWrGo:
ByteWrGo
										; CH376_COMMAND = $3D;
	LDA #$3D
	STA CH376_COMMAND
										; CALL WaitResponse;
	JSR WaitResponse
										; 'CMP #INT_DISK_WRITE';
	CMP #INT_DISK_WRITE
										;RETURN;
	RTS
										;'#endif';
#endif

;---------------------------------------------------------------------------
; WaitResponse:
; A voir si il faut preserver X et Y
;
; Entree:
;
; Sortie:
; Z: 0 -> ACC: Status du CH376
; Z: 1 -> Timeout
; X,Y: Modifies
;---------------------------------------------------------------------------
										;'#iflused WaitResponse';
#iflused WaitResponse
										;'#echo Ajout WaitResponse';
#echo Ajout WaitResponse
										;WaitResponse:
WaitResponse
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
										; .A = CH376_COMMAND;
	LDA CH376_COMMAND
										; IF + THEN
	BMI ZZZ011
										; BEGIN;
										; CH376_COMMAND = $22;
	LDA #$22
	STA CH376_COMMAND
										; .A = CH376_DATA;
	LDA CH376_DATA
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
										;'#endif';
#endif

;---------------------------------------------------------------------------
; Fin du Module
;---------------------------------------------------------------------------
										;EXIT;
;END
