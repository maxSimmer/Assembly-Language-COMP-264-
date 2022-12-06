*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    
* Put program code here
    MOVEA.L #MSG,A1 ; get msg address in a1
    ADD.B #2, (A1) ; replace H with J
    MOVE.L #14,D0 ; get function code for print in d0
    TRAP #15       ; call to print
    SIMHALT             ; halt simulator

* Put variables and constants here
msg:
    DC.B 'Hello World', 0 
    END    START        ; last line of source
    
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
