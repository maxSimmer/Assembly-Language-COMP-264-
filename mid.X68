*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; firstinstruction of program
    move $5000, d0
    
    sub.b #30, d0 ; ascii to int 
    move.b d0, $5000
    move.l #28, d1
    lsl.l d1,d0
    or.l d0,d2
    
    
* Put program code here

    SIMHALT             ; halt simulator
    
    
    ORG $5000
    dc.b '12345678', 0
    
    ORG $6000
    dc.b '87654321', 0
    
* Put variables and constants here



    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
