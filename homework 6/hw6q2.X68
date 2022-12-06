*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    LEA array, a1 ; intialize the string into an array
    MOVE.B #0, D0 ;set first data reg to 0
* Put program code here
loop:
    ADD.L #1, d0 ;add 1 into data reg 0
    
    
    CMP.B #0, (A1, D0) ; COMPARES 0 to data reg 0 within array 1
    BGT loop ; if d0 within a1 is greater than 0, loop back
    SIMHALT             ; halt simulator

* Put variables and constants here
array:
    dc.b 'the quick brown fox jumped over the lazy dog', 0 ; set the array string
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
