*-----------------------------------------------------------
* Title      :HW7 1st
* Written by :Christian Vasquez & Max Simmer
* Date       :03/17/22
* Description:
*-----------------------------------------------------------
    ORG    $1000     
START:           
FILE:
    LEA filename, A1              ; put name of file into a1
    MOVE #51, D0                  ; move 51 to d0
    TRAP #15                      ; trap 15
    MOVE.L #filesize, D2          ; move filesize to d2
    LEA buffer, A1                ; move buffer to a1
    MOVE #53, D0                  ; move 53 to d0
    TRAP #15                      ; trap 15           
HEX2INT:                  
    LEA filename, A2              ; initialize array
    MOVE.B #8, D3                 ; initialize counter
H2ILOOP:
    LSL.L #4, D1
    MOVEA.L #filename,A2          ; get msg address in a2
    MOVE.B (A2, D2), D5           ; move a1 to d5
    SUB.B #'0', D5                ; subtract hex offset
    CMP #9, D5                    ; compare 9 to d5
    BLT H2ISKIP                   ; if less than then skip
    SUB.B #7, D5                  ; subtract 7 if greater than 9
H2ISKIP:
    ADDI.L #1, D2                 ; increment the array
    SUB.B #1, D3                  ; subtract 1 from counter
    OR.L D5, D1                   ; place d5 into d1
    CMP #0, D3                    ; compare counter to #0
    BNE H2ILOOP                   ; if not equal, loop
    TRAP #15                      ; call monitor to print
    

    

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
