		;DEFINE CH376COMMAND = $341;
CH376COMMAND=$341
		;DEFINE CH376DATA = $340;
CH376DATA=$340
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
;
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
;
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
;
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
;
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
;
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
	BEQ ZZZ005
		; BEGIN;
		; REPEAT;
	ZZZ006
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
	BNE ZZZ006
		; PTRMAX = .Y; "Pour GetByte";
	STY PTRMAX
		; END;
		;RETURN;
	ZZZ005
	RTS
#endif

; -----------------------------------------------------------------------------
;
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
	ZZZ007
		; DO;
		; INC .Y;
	INY
		; 'CPY #13';
	CPY #13
		; IF .Z THEN .A=0;
	BNE ZZZ008
	LDA #0
		; IF ^.Z THEN .A = @PTRREADDEST[.Y];
	ZZZ008
	BEQ ZZZ009
	LDA (PTRREADDEST),Y
		; CH376DATA = .A;
	ZZZ009
	STA CH376DATA
		; END;
		; UNTIL .Z;
	BNE ZZZ007
		;RETURN;
	RTS
#endif

; -----------------------------------------------------------------------------
;
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
;
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
;
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
;
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
;
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
;
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
;
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
;
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
;
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
		; 'CMP #INTDISKREAD';
	CMP #INTDISKREAD
		;RETURN;
	RTS
#endif


; -----------------------------------------------------------------------------
;
; -----------------------------------------------------------------------------
#iflused WAITRESPONSE
#echo Ajout de WaitResponse
		;WAITRESPONSE:
WAITRESPONSE
		; .Y = $FF;
	LDY #$FF
		; REPEAT;
	ZZZ002
		; DO;
		; .X=$FF;
	LDX #$FF
		; REPEAT;
	ZZZ003
		; DO;
		; .A = CH376COMMAND;
	LDA CH376COMMAND
		; IF + THEN
	BMI ZZZ004
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
	ZZZ004
	DEX
		; END;
		; UNTIL .Z;
	BNE ZZZ003
		; DEC .Y;
	DEY
		; END;
		; UNTIL .Z;
	BNE ZZZ002
		;RETURN;
	RTS
#endif


