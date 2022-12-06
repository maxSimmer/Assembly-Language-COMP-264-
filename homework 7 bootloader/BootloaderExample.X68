*-----------------------------------------------------------
* Title      :First Bootloader
* Written by :Christian Vasquez
* Date       :03/14/22
* Description:Bootloader Example w/ hardcoded machine code
*-----------------------------------------------------------
    ORG    $1000
START:                  
    LEA $2000,A0                  ; Load address 2000 into A0
    MOVE.W #$4E71,(A0)+           ; Moves NOP to address 2000, increments A0 by 2 bytes (word)
    MOVE.W #$60FC,(A0)+           ; Moves BRA -4 to address 2002, increments A0 by 2 bytes (word)
    MOVEA.L #$2000,A0             ; Puts address 2000 back into A0
    JMP (A0)                      ; Jumps to address 2000 to run the code we bootloaded (hardcoded machine code)
    NOP                           ; No Operation
    NOP                           ; No Operation
    SIMHALT             

* Put variables and constants here

    END    START        
*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
