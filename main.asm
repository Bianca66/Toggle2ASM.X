;************************************
; Written by:         Palade Bianca *
; Date:               24.03.2020    *
; for PIC:            10F200        *
; Clock frequency:    4MHz          *
;************************************
 
; PROGRAM FUNCTION: _______________________________________
;__________________________________________________________
     
;_______________________________
; Declarations:
;_______________________________
;Timing register and GPIO
TMR0   EQU 1
GPIO   EQU 6
STATUS EQU 3
     UDATA
REG    RES 0
     
;Processor reset vector  
RES_VECT  CODE    0x0000  

;Go to beginning of program
GOTO    INIT          

;_______________________________
; Subroutines:
;_______________________________
;Let linker place main program
MAIN_PROG CODE                      
INIT
    MOVLW 0       ; W = 0
    TRIS 6        ; TRIS = W
    CLRF GPIO     ; GPIO = W (0xFF)
    MOVLW 0x07    ; W = 7
    OPTION        ; OPTION = W = 0000_0111 -> Intern Timer, Prescaler Period = 1:256
;_______________________________
; Program Start:
;_______________________________
START
   
    COMMAND
    ;Toggle 2 ms
    MOVLW 0x08         
    GOTO TOGGLE
    
    ; Delay 27.8 ms
    MOVLW 0x6C
    GOTO DELAY
    
    ; Toggle 0.5 ms
    GOTO TOGGLE1
    
    ; Delay 1.5 ms
    MOVLW 0x06
    GOTO DELAY
    
    ; Toggle 0.5 ms
    GOTO TOGGLE1
    
    ; Delay 3.5 ms
    MOVLW 0x0E
    GOTO DELAY
    
    ; Toggle 0.5 ms
    GOTO TOGGLE1
    RETURN
    
    ; Delay 63 ms
    MOVLW 0xF6
    GOTO DELAY
    
    GOTO COMMAND
GOTO START
    
;__________________________________________________
; Prescaler Period = 1:256
;            F_osc = 4MHz
;            F_CPU = 4MHZ/4 = 1MHz
;          F_timer = 1Hz / 256 = 10^6 / 256 = 3906.25 Hz
;          T_timer = 1/F_timer = 256 us
;
; 1000 ms(1s) .................... 3906.25 
;   63 ms     .................... 246    
; 27.8 ms     .................... 108.59 ~ 108
;  3.5 ms     .................... 13.67  ~  14
;    2 ms     .................... 7.81   ~   8
;  1.5 ms     .................... 5.85   ~   6  
;  0.5 ms     .................... 2  
;__________________________________________________

DELAY
    MOVWF REG              ; REG  = W
    CLRF  TMR0             ; TMR0 = 0
    LOOP 
	CALL _SUB
    GOTO LOOP
RETURN 

	
TOGGLE
    MOVWF REG              ; REG  = W
    CLRF  TMR0             ; TMR0 = 0
    LOOP1
	BSF GPIO, 0        ; GP0 = 5 V
	CALL _SUB          ; CALL _SUB subroutine
	CALL _SUB          ; CALL _SUB subroutine
	BCF GPIO, 0        ; GP0 = 0 V
	CALL _SUB          ; CALL _SUB subroutine
    GOTO LOOP1
RETURN 
    
TOGGLE1                    ; TOGGLE for 0.5 ms
    MOVLW 0x02             ; W = 2
    GOTO TOGGLE 
RETURN
 
    
_SUB:
    MOVF  REG, W       ;    W = REG
    SUBWF TMR0, W      ;    W = TMR0 - W
    BTFSS STATUS, 2    ;    check  if ((TMR0 - W) == 0)
RETURN 
    
    
END