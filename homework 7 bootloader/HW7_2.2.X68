*-----------------------------------------------------------
* Title      :HW7 2nd
* Written by :Christian Vasquez & Max Simmer
* Date       :03/25/22
* Description:
*-----------------------------------------------------------

; STATE DEFINITIONS. EACH STATE GETS ASSIGNED A UNIQUE INTEGER IDENTIFIER.

LOOK_4_S                    EQU 0           ; search for an s, if yes then move on, if not then go to new line and start search again
LOOK_4_RECORD_TYPE          EQU 1           ; search for record type, if 1 then move on, if not then go to new line process
LOOK_4_NBYTES               EQU 2           ; count num of bytes and store in var NBYTES, then move on
LOOK_4_ADDRESS              EQU 3           ; search for address and store in var ADDR, then subtract ADDR from NBYTES and store in NBYTES
COUNT_REST_OF_BYTES         EQU 4           ; go through rest of line and count each byte, store in RESTBYTES, sub RESTBYTES from NBYTES and store in NBYTES
READ_S_DATA                 EQU 5           ; use NBYTES in a counter to read a byte of data, convert it to int, and store in memory, then move to next byte


    ORG    $400
START:                                      ; first instruction of program

    PEA filepath                            ; push the address of our file
    BSR OPEN                                ; branch to the file open process
    ADDA.L #4,A7                            ; CLEAN UP STACK
    
    MOVE.L D1,-(A7)                         ; FILE ID
    MOVE.L #4096,-(A7)                      ; SIZE OF BUF
    PEA FILEBUF                             ; BUF ADDR
    BSR READ                                ; branch to the file read process
    ADDA.L #12,A7                           ; CLEAN UP STACK

    LEA FILEBUF,A0                          ; load effective address of our buffer
    MOVE.L #-1,D0                           ; initialize D0 with -1, which which is for the index
    
PROCESS_FSM:
    ADDI.L #1,D0
    
    CMPI.L #LOOK_4_S, state                 ; all of these commands compare and jump to the correct process correlating to the state variable
    BEQ PROCESS_LOOK_4_S
    CMPI.L #LOOK_4_RECORD_TYPE, state
    BEQ PROCESS_LOOK_4_RECORD_TYPE
    CMPI.L #LOOK_4_NBYTES, state
    BEQ PROCESS_LOOK_4_NBYTES
    CMPI.L #LOOK_4_ADDRESS, state
    BEQ PROCESS_LOOK_4_ADDRESS
    CMPI.L #READ_S_DATA, state
    BEQ PROCESS_READ_S_DATA


PROCESS_LOOK_4_S:
    ; make loop to continually look for s and go to next char if not found until s is found

    MOVE.B (A0,D0),D1                       
    MOVE.L D1,-(A7)                         ; PUSH CURRENT CHAR
    BSR PUTC                                ; EXECUTE PUTC
    ADDA.L #4,A7                            ; CLEAN UP STACK


    CMP.B #'S',(A0,D0)                      ; look for s 
    BNE NOT_S                               ; branch to NOT_S if no s is found
    MOVE.L #LOOK_4_RECORD_TYPE, state       ; moves the next state into the state var
    BRA PROCESS_FSM                         ; branch to beginning
    
NOT_S:
    BRA PROCESS_FSM                         ; branch to beginning

PROCESS_LOOK_4_RECORD_TYPE:
; compare 0 and 8 to the record type, if its equal to either then loop back to start, if its not equal then move to look_4_nbytes
    CMP.B #'0',(A0,D0)
    BEQ SKIP_STATE_UPDATE_1
    CMP.B #'8',(A0,D0)
    BEQ SKIP_STATE_UPDATE_1
    MOVE.L #LOOK_4_NBYTES, state
    
    BRA PROCESS_FSM                         ; branch to beginning
SKIP_STATE_UPDATE_1:
    MOVE.L #LOOK_4_S, state                 ; returns state to first step
    BRA PROCESS_FSM                         ; branch to beginning
    
    
PROCESS_LOOK_4_NBYTES:
; have this scan the next byte (2 hex digits) and then store in nbytes, then move to look_4_address
    PEA (A0,D0)                             ; push the address of the nbytes to d0
    PEA 2                                   ; read 1 byte
    BSR HEX2INT                             ; call subroutine HEX2INT
    MOVE.L D0, nbytes                       ; move contents of d0 to nbytes
    ADDA.L #8, A7                           ; clean up stack after bsr
    MOVE.L #LOOK_4_ADDRESS, state           ; next state
    BRA PROCESS_FSM                         ; branch to beginning



PROCESS_LOOK_4_ADDRESS:
; have this scan the next 2 bytes (4 hex digits), store the address, and then subtract from nbytes a hardcoded 4
    PEA (A0,D0)                             ; push the address of the address in the Srecord to d0
    PEA 4                                   ; read 2 bytes
    MOVE.L D0, address                      ; move contents of d0 to address var
    SUB.B #4, nbytes                        ; subtracting the address from nbytes
    SUB.B #2, nbytes                        ; subtracting the checksum from nbytes
    MOVE.L #READ_S_DATA, state              ; next state
    BRA PROCESS_FSM                         ; branch to beginning



PROCESS_READ_S_DATA: 
; jump to address stored in address var, then go through each char of data, converting to int and moving to memory all in this process.
    MOVE.B (A0,D0),D1
    PEA nbytes
    MOVE.L D1,-(A7)                         ; push current char
    BSR HEX2INT                             
    CMP.B #$A, D1
    BNE PROCESS_READ_S_DATA
    BRA PROCESS_FSM                         ; branch to beginning


PUTC:
    LINK A6,#0                              ; PROLOGUE
    MOVEM.L D0-D7/A0-A5,-(A7)               ; CALLEE SAVE REGISTER
    
    MOVE.L 8(A6),D1
    MOVE.L #6,D0
    TRAP #15
    
    MOVEM.L (A7)+,D0-D7/A0-A5               ; UNDO CALEE SAVE REGISTER
    UNLK A6
    RTS

OPEN:
    LINK A6,#0
    MOVE.L 8(A6),A1
    MOVE.L #51,D0
    TRAP #15
    
    UNLK A6
    RTS
    
READ:
    LINK A6,#0
    
    MOVE.L 8(A6),A1                         ; GET PTR TO BUFFER IN A1
    MOVE.L 16(A6),D1
    MOVE.L 12(A6),D2
    MOVE.L #53,D0
    TRAP #15
    
    
    UNLK A6
    RTS


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
    LSR.L #8, D3                ; logical shift right d3 8 bytes
    LSR.L #4, D3                ; logical shift right d3 4 bytes
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
    LSR.L #4,D0                 ; logical shift right by 2 bytes
    UNLK A6                     ; epilogue
    RTS                         ; Return to BSR Hex2Int    
    SIMHALT                     ; halt simulator
state:
    dc.l LOOK_4_S

filebuf:
    DS.B 4096
    
nbytes:
    DS.B 4
    
address:
    DS.B 8
    
filepath:
    dc.b 'srecordex.txt',0
    
    END    START                            ; last line of source









*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
