; STATE DEFINITIONS. EACH STATE GETS ASSIGNED A UNIQUE INTEGER IDENTIFIER.
LOOK_4_S           EQU 0
LOOK_4_2ND_NUM     EQU 1
S_DATA             EQU 2


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
    CMPI.L #LOOK_4_2ND_NUM, state
    BEQ PROCESS_LOOK_4_2ND_NUM
    CMPI.L #S_0, state
    BEQ PROCESS_S_0

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

PROCESS_LOOK_4_2ND_NUM:
    CMP.B #'0',(A0,D0)
    BNE SKIP_STATE_UPDATE_1
    MOVE.L #S_0, state
    BRA PROCESS_FSM
SKIP_STATE_UPDATE_1:
    MOVE.L #LOOK_4_S, state
    BRA PROCESS_FSM
    
PROCESS_S_0:
    CMP.B #$D,(A0,D0)
    BNE SKIP_STATE_UPDATE_2
    MOVE.L #LOOK_4_S, state
SKIP_STATE_UPDATE_2:
    BRA PROCESS_FSM

;  |---------------------------|
;  | CHAR TO PRINT             |  +8
;  |---------------------------|
;  | RETURN ADDRESS            |  +4
;  |---------------------------|
;  | CALLER'S A6               |  <-- A6
;  |---------------------------|
PUTC:
    LINK A6,#0  ; PROLOGUE
    MOVEM.L D0-D7/A0-A5,-(A7)  ; CALLEE SAVE REGISTER
    
    MOVE.L 8(A6),D1
    MOVE.L #6,D0
    TRAP #15
    
    MOVEM.L (A7)+,D0-D7/A0-A5  ; UNDO CALEE SAVE REGISTER
    UNLK A6
    RTS



;  |---------------------------|
;  | PTR TO STRING PATH        |  +8
;  |---------------------------|
;  | RETURN ADDRESS            |  +4
;  |---------------------------|
;  | CALLER'S A6               |  <-- A6
;  |---------------------------|

OPEN:
    LINK A6,#0
    MOVE.L 8(A6),A1
    MOVE.L #51,D0
    TRAP #15
    
    UNLK A6
    RTS
    
;  |---------------------------|
;  | INTEGER FILE IDENTIFIER   |  +16    
;  |---------------------------|
;  | SIZE OF BUFFER            |  +12
;  |---------------------------|
;  | PTR TO BUFFER             |  +8
;  |---------------------------|
;  | RETURN ADDRESS            |  +4
;  |---------------------------|
;  | CALLER'S A6               |  <-- A6
;  |---------------------------|

READ:
    LINK A6,#0
    
    MOVE.L 8(A6),A1   ; GET PTR TO BUFFER IN A1
    MOVE.L 16(A6),D1
    MOVE.L 12(A6),D2
    MOVE.L #53,D0
    TRAP #15
    
    
    UNLK A6
    RTS



    SIMHALT             ; halt simulator
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
