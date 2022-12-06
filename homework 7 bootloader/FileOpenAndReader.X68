*-----------------------------------------------------------
* Title      :File Open and Reader
* Written by :Christian Vasquez and Max Simmer
* Date       :3/17/22
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  
    LEA filename, A1
    MOVE #51, D0
    TRAP #15
    MOVE.L #filesize, D2
    LEA buffer, A1
    MOVE #53, D0
    TRAP #15
    

    SIMHALT             

    ORG     $2000
* Put variables and constants here
filename:    
    DC.B 'hex.txt', 0
buffer:
    DS.B 80
filesize:
    DC.B 80
    
    END    START        
*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
