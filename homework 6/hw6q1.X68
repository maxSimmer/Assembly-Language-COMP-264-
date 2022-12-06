*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    LEA array, A1 ; initalize array with the variable inside
    move.b #8, d3 ; intialize counter, 8 characters for deadbeef. in d3 since other registers will get filled
    
* Put program code here
loop:
    LSL.L #4, D0 ; logical shift left? sifts the bits 4 to left so our value is the first bits
    MOVEA.L #array, A1 ; puts the message into array 1
    move.b (A1, D1), D5 ; move the array to data reg 1
    
    SUB.B #'0', D5 ; subtract hex offset value ; conversion
    CMP #9, D5 ; compares 9 to data reg 5, which 
    BLT func ; if less than, skip to the next function
    SUB.B #7, D5 ; subtract 9 if d5 is greater than 9
    
func:
    addi.l #1, D1 ;increment the arrays index
    sub.b #1, D3 ;subtract 1 from the counter (8)
    OR.L D5, D0 ; d5 goes back into d0 (move the array value into d0)
    CMP #0, D3 ; compares the counter to 0
    BNE loop ; if not 0, loop back to the loop

    
    SIMHALT             ; halt simulator

* Put variables and constants here
array:
    dc.b 'DEADBEEF', 0 
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
