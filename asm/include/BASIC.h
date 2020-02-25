										;'#ifndef BASIC_H';
#ifndef BASIC_H
										;'#define BASIC_H';
#define BASIC_H
;---------------------------------------------------------------------------
;
; Variables en page 0
;
;---------------------------------------------------------------------------
										;DEFINE LINESIZE = $26; " Trouver un autre label";
	LINESIZE=$26
										;DEFINE VARFOUND = $27;
	VARFOUND=$27
										;DEFINE VAR_TYPE = $28;
	VAR_TYPE=$28
										;DEFINE ARRAY_FLAG = $2B;
	ARRAY_FLAG=$2B
										;DEFINE TMP_STR = $A4;
	TMP_STR=$A4
										; DEFINE TMP_STR_H = $A5;
	TMP_STR_H=$A5
										;DEFINE H91 = $91;
	H91=$91
										;DEFINE VARNAME1 = $B4;
	VARNAME1=$B4
										;DEFINE VARNAME2 = $B5;
	VARNAME2=$B5
										;DEFINE VAR_ADDR = $B6;
	VAR_ADDR=$B6
;---------------------------------------------------------------------------
;
; Adresses des Routines ROM v1.0
;
;---------------------------------------------------------------------------
										;'#ifdef ORIC1';
#ifdef ORIC1
										;DEFINE CharGet = $00E2;
	CharGet=$00E2
										;DEFINE CharGot = $00E8;
	CharGot=$00E8
										;DEFINE GetVarFromText = $D0FC;
	GetVarFromText=$D0FC
										;DEFINE FindVar = $D158;
	FindVar=$D158
										;DEFINE FindArrayElt= $D270;
	FindArrayElt=$D270
										;DEFINE GIVAYF = $D3ED;
	GIVAYF=$D3ED
										;DEFINE NewStr = $D563;
	NewStr=$D563
										;DEFINE CpyStr = $D6F7;
	CpyStr=$D6F7
										;DEFINE FreeStr = $D715;
	FreeStr=$D715
										;DEFINE FreeStr_04 = FreeStr+4;
	FreeStr_04=FreeStr+4
										;DEFINE MOVMF = $DEA5;
	MOVMF=$DEA5
										;DEFINE EvalExpr = $CE8B;
	EvalExpr=$CE8B
										;DEFINE SyntaxError = $CFE4;
	SyntaxError=$CFE4
										;DEFINE CheckStr = $D712;
	CheckStr=$D712
										;DEFINE PrintString = $CBED;
	PrintString=$CBED
										;DEFINE PrintString_07 = PrintString+7;
	PrintString_07=PrintString+7
; $F7AC
										;DEFINE PrintA = $CC12;
	PrintA=$CC12
;---------------------------------------------------------------------------
;
; Adresses des Routines ROM v1.1
;
;---------------------------------------------------------------------------
										;'#else';
#else
										;DEFINE CharGet = $00E2;
	CharGet=$00E2
										;DEFINE CharGot = $00E8;
	CharGot=$00E8
										;DEFINE GetVarFromText = $D188;
	GetVarFromText=$D188
										;DEFINE FindVar = $D1E8;
	FindVar=$D1E8
										;DEFINE FindArrayElt= $D306;
	FindArrayElt=$D306
										;DEFINE GIVAYF = $D499;
	GIVAYF=$D499
										;DEFINE NewStr = $D61E;
	NewStr=$D61E
										;DEFINE CpyStr = $D7B2;
	CpyStr=$D7B2
										;DEFINE FreeStr = $D7D0;
	FreeStr=$D7D0
										;DEFINE FreeStr_04 = FreeStr+4;
	FreeStr_04=FreeStr+4
										;DEFINE MOVMF = $DEAD;
	MOVMF=$DEAD
										;DEFINE EvalExpr = $CF17;
	EvalExpr=$CF17
										;DEFINE SyntaxError = $D070;
	SyntaxError=$D070
										;DEFINE CheckStr = $D7CD;
	CheckStr=$D7CD
										;DEFINE PrintString = $CCB0;
	PrintString=$CCB0
										;DEFINE PrintString_07 = PrintString+7;
	PrintString_07=PrintString+7
; $F7E4
										;DEFINE PrintA = $CCD9;
	PrintA=$CCD9
										;'#endif';
#endif
;---------------------------------------------------------------------------
										;'#endif';
#endif
;---------------------------------------------------------------------------
										;EXIT;
;	END
