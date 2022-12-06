*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    SIMHALT             ; halt simulator
HANDLE_LOOK_FOR_SLASH:
    ; if filebuf(d0) == '/' then state := look for comment
    ;else state ;= look_for_slash
    cmb.b #'/', (A0, D0)
    bne not_slash
    move.l #look_for_comment, state
HANDLE_LOOK_FOR_COMMENT:
    ; if filebuf(d0) == '/' then state := found comment
    ;else state ;= look_for_slash
    cmb.b #'/', (A0, D0)
    bne not_slash
    move.l #FOUND_COMMENT, state
    BRA FSM_LOOP
handle_found_comment:
    ; if filebuf[d0] == '\n' then state := look_for_slash
    ; else state := found_comment
    cmp.b #$D, (A0, D0)
    BNE not_slash
    MOVE.L #look_for_slash, state
not_slash:
    bra fsm_loop

num_chars_read:
    dc.1 0
state:
    
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
