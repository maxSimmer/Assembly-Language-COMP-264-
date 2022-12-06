*-----------------------------------------------------------
* Title      :Hex2Int
* Written by :Christian Vasquez
* Date       :03/29/2022
* Description:
*-----------------------------------------------------------
    ORG  0
    dc.l $8000
    dc.l START
    ORG  $1000
    
; NAK adding a test function to call hex2int from
START:
    PEA msg                     ; push msg address
    PEA 4                       ; read 4 bytes
    BRA HEX2INT                 ; ASK NEIL IF I CAN USE BRA INSTEAD OF BSR
    ADDA.L #8,A7                ; clean up stack
    
    
;|-------------------|
;|   ADDR OF STRING  | +12
;|-------------------|
;| #CHARS TO CONVERT | +8
;|-------------------|
;|   RETURN ADDRESS  | +4
;|-------------------|
;|   FRAME POINTER   | +0
;|-------------------|
;Variables: D0 - Output Register
;           D1 - Index
;           D2 - Data
;           D3 - Counter

HEX2INT:    
    LINK A6, #0                 ; prologue
    MOVEM.L D1-D7/A0-A5,-(A7)   ; Save scratch regs on the stack 
    MOVE.L 12(A6),D3            ; address of string           
    MOVE.L 8(A6),A1             ; # of chars to convert
    LSR.L #8, D3
    LSR.L #4, D3
H2ILOOP:
    LSL.L #4, D0                ; shift left 4 bytes 
    MOVE.B (A1, D1),D2          ; move a1 to d2
    SUB.B #'0',D2               ; subtract hex offset
    CMP.B #9, D2                ; compare 9 to d2
    BLT H2ISKIP                 ; if less than then skip
    SUB.B #7, D2                ; subtract 7 if greater than 9
    
H2ISKIP:
    ADDI.B #1, D1               ; increment the array 
    SUB.B #1, D3                ; subtract 1 from counter
    OR.L D2, D0                 ; place d2 into d0
    CMP.B #0, D3                ; compare counter to #0
    BNE H2ILOOP                 ; if not equal, loop
    MOVEM.L (A7)+, D1-D7/A0-A5  ; restore scratch regs
    LSR.L #4,D0
    UNLK A6                     ; epilogue
    RTS                         ; Return to BSR Hex2Int
    

    SIMHALT             
msg:
    DC.B 'DEADBEEF',0  

    END    START                ; last line of source




*~Font name~Courier New~
*~Font size~16~
*~Tab type~1~
*~Tab size~4~
