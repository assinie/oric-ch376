											;'#ifndef CH376_H';
#ifndef CH376_H
											;'#define CH376_H;
#define CH376_H

;---------------------------------------------------------------------------
;
; Variables en page 0
;
;---------------------------------------------------------------------------
											;DEFINE * = 0;
	*=0
											;DECLARE PTR_READ_DEST WORD;
PTR_READ_DEST  *=*+2
											; DEFINE PTR_READ_DEST_L = PTR_READ_DEST;
PTR_READ_DEST_L=PTR_READ_DEST
											; DEFINE PTR_READ_DEST_H = PTR_READ_DEST +1;
PTR_READ_DEST_H=PTR_READ_DEST+1
											;DECLARE PTR_WRITE_SRC WORD;
PTR_WRITE_SRC  *=*+2
											; DEFINE PTR_WRITE_SRC_L = PTR_WRITE_SRC;
PTR_WRITE_SRC_L=PTR_WRITE_SRC
											; DEFINE PTR_WRITE_SRC_H = PTR_WRITE_SRC +1;
PTR_WRITE_SRC_H=PTR_WRITE_SRC+1
											;DECLARE ERRNO;
ERRNO  *=*+1
											;DECLARE OFFSET_0, OFFSET, OFFSET_H, OFFSET_3;
OFFSET_0  *=*+1
OFFSET  *=*+1
OFFSET_H  *=*+1
OFFSET_3  *=*+1
											;DEFINE OFFSET_L = OFFSET;
OFFSET_L=OFFSET
											;DECLARE TMP;
TMP  *=*+1
											;DEFINE * = $F3;
	*=$F3
											;DECLARE PTR ;
PTR  *=*+1
											;DECLARE PTR_MAX;
PTR_MAX  *=*+1
											;DECLARE PTW ;
PTW  *=*+1
											;DECLARE PTW_MAX;
PTW_MAX  *=*+1

;---------------------------------------------------------------------------
;
; Variables en page 2
;
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;
; Adresses des Buffers ou Tables
;
;---------------------------------------------------------------------------
											;DEFINE CRCLO = $8000;
CRCLO=$8000
											;DEFINE CRCHI = $8100;
CRCHI=$8100

;---------------------------------------------------------------------------
;
; Adresse de l'interface CH376
;
;---------------------------------------------------------------------------


;---------------------------------------------------------------------------
;
; Codes d'erreur du CH376
;
;---------------------------------------------------------------------------
											;DEFINE SUCCESS = $12;
SUCCESS=$12
											;DEFINE INT_SUCCESS = $14;
INT_SUCCESS=$14
											;DEFINE INT_DISK_READ = $1D;
INT_DISK_READ=$1D
											;DEFINE INT_DISK_WRITE= $1E;
INT_DISK_WRITE=$1E
											;DEFINE ERR_MISS_FILE = $42;
ERR_MISS_FILE=$42
											;DEFINE ABORT = $5F;
ABORT=$5F

;---------------------------------------------------------------------------
											;'#endif';
#endif

;---------------------------------------------------------------------------
											;EXIT;
;END
