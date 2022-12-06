*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    LEA array, A1 ;intialize array
    
    move.b #9, D3 ;intialize counter (9 letters) 
    
* Put program code here
LOOP:
    MOVEA.L #array, A1 ; put uppercase into array
    ADD.B #32, (A1, D1) ; uppercase to lowercase conversion
    MOVE.L #14, D0 ; func code back to d0
    ADDI.L #1, D1 ; increment the array index
    SUB.B #1, D3 ; subtract 1 from the counter (9 letters)
    CMP #0, D3 ; compare the counter to 0
    BNE LOOP ; if not 0, keep looping (keep looping until end of the string)
    
    
    trap #15 ; print to screen
    
    SIMHALT             ; halt simulator

* Put variables and constants here
array:
    dc.b 'UPPERCASE', 0

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
