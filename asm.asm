GPIO EQU 6
 UDATA
VARA RES 1
VARB RES 1
VARC RES 1
 
 
RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program
 
MAIN_PROG CODE                      ; let linker place main program
START
    MOVLW 0 ; W = 0
    TRIS 6 ; TRIS = W
    
    CLRF GPIO; GPIO = W (0xFF)
    
AICI
    BSF GPIO, 0
    GOTO $+1  
	
    BCF GPIO, 0
                        ; loop forever
    GOTO AICI
    END