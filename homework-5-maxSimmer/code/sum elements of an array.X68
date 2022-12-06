*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    MOVE.L #0, D0
    MOVE.L #10, D1 
    LEA array, a0
    
* Put program code here
LOOP:
    MOVE.L (A0)+, D2
    add.l D2, D0
    SUB.B #1, D1
    BNE LOOP
    
    SIMHALT             ; halt simulator

* Put variables and constants here
array:
    DC.L $5, $10, $15, $20, $25, $30, $35, $40, $45, $50
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
