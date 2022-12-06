*-----------------------------------------------------------
* Title      :
* Written by :max simmer
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                 ; first instruction of program
    MOVE.L #0, D0
* Put program code here
LOOP:
    LEA ARRAY, A0
    MOVE.B #$55, (A0, D0)
    ADDI.L #1, D0
    CMP #10, D0
    BNE LOOP
    

    SIMHALT             ; halt simulator

* Put variables and constants here
ARRAY:
    dc.b 10

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
