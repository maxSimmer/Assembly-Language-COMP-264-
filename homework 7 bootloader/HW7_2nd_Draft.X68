*-----------------------------------------------------------
* Title      :HW7 2nd
* Written by :Christian Vasquez & Max Simmer
* Date       :03/25/22
* Description:
*-----------------------------------------------------------
; STATE DEFINITIONS. EACH STATE GETS ASSIGNED A UNIQUE INTEGER IDENTIFIER.
LOOK_4_S               EQU 0
LOOK_4_RECORD_TYPE     EQU 1
LOOK_4_NBYTES          EQU 2
S_DATA                 EQU 3


    ORG    $400
START:                  ; first instruction of program

    PEA filepath
    BSR OPEN
    ADDA.L #4,A7        ; CLEAN UP STACK
    
    MOVE.L D1,-(A7)     ; FILE ID
    MOVE.L #4096,-(A7)  ; SIZE OF BUF
    PEA FILEBUF         ; BUF ADDR
    BSR READ
    ADDA.L #12,A7       ; CLEAN UP STACK

    LEA FILEBUF,A0
    MOVE.L #-1,D0
    
; Below is the code for implementing the FSM:
PROCESS_FSM:
    ADD.L #1,D0
    
    CMPI.L #LOOK_4_S, state
    BEQ PROCESS_LOOK_4_S
    CMPI.L #LOOK_4_RECORD_TYPE, state
    BEQ PROCESS_LOOK_4_RECORD_TYPE
    CMPI.L #S_DATA, state
    BEQ PROCESS_S_DATA

PROCESS_LOOK_4_S:

    MOVE.B (A0,D0),D1
    MOVE.L D1,-(A7)     ; PUSH CURRENT CHAR
    BSR PUTC
    ADDA.L #4,A7        ; CLEAN UP STACK


    CMP.B #'S',(A0,D0)
    BNE SKIP_STATE_UPDATE
    MOVE.L #LOOK_4_2ND_NUM, state
SKIP_STATE_UPDATE:
    BRA PROCESS_FSM

PROCESS_LOOK_4_RECORD_TYPE:
    CMP.B #'0',(A0,D0)
    BNE SKIP_STATE_UPDATE_1
    CMP.B #'8',(A0,D0)
    BNE SKIP_STATE_UPDATE_1
    MOVE.L #S_0, state
    
    BRA PROCESS_FSM
SKIP_STATE_UPDATE_1:
    MOVE.L #LOOK_4_S, state
    BRA PROCESS_FSM
    
    
PROCESS_LOOK_4_NBYTES:
    CMP.B 

PROCESS_S_DATA: 
    BRA HEX2INT


PROCESS_IDK:
    CMP.B #$D,(A0,D0)
    BNE SKIP_STATE_UPDATE_2
    MOVE.L #LOOK_4_S, state
SKIP_STATE_UPDATE_2:
    BRA PROCESS_FSM

PUTC:
    LINK A6,#0  ; PROLOGUE
    MOVEM.L D0-D7/A0-A5,-(A7)  ; CALLEE SAVE REGISTER
    
    MOVE.L 8(A6),D1
    MOVE.L #6,D0
    TRAP #15
    
    MOVEM.L (A7)+,D0-D7/A0-A5  ; UNDO CALEE SAVE REGISTER
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
    
    MOVE.L 8(A6),A1               ; GET PTR TO BUFFER IN A1
    MOVE.L 16(A6),D1
    MOVE.L 12(A6),D2
    MOVE.L #53,D0
    TRAP #15
    
    
    UNLK A6
    RTS
    
HEX2INT:                  
    LEA filename, A2              ; initialize array
    MOVE.B #8, D3                 ; initialize counter
H2ILOOP:
    LSL.L #4, D1
    MOVEA.L #filepath,A2          ; get msg address in a2
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

    SIMHALT                       ; halt simulator
state:
    dc.l LOOK_4_S

FILEBUF:
    DS.B 4096
    
filepath:
    dc.b 'hex.txt',0

    END    START        ; last line of source
*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
