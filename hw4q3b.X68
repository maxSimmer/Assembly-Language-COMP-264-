*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    
* Put program code here
    MOVE.B #6, D0 ; get func for print one char in d0
    MOVE.B #65, D1 ; place char a into D1
    TRAP #15 ; call to monitor to print
    BRA Start  ; go to loop
    SIMHALT             ; halt simulator

* Put variables and constants here
msg:
    DC.B 'Hello World', 0 
    END    START        ; last line of source
    
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
