; F(x3, x2, x1, x0) = 2, 3, 4, 9, 11, 12, 13
; R0 - address of the reference function
; R1 - shift counter

; Start
    ORG     0000h           ; Starting address
    P4      EQU 0C0h        ; Define P4

; Preparing the environment for work
    MOV     DPTR, #8000h    ; \;
    MOV     A, #08h         ; | Loading an indirect address into external memory
    MOVX    @DPTR, A        ; /

    MOV     DPTR, #8008h    ; \;
    MOV     A, #15h         ; | Loading the base address into external memory
    MOVX    @DPTR, A        ; /

    MOV     DPTR, #8000h    ; \;
    MOVX    A, @DPTR        ; | Calculating the address of the reference
    MOV     DPL, A          ; | function in external memory and writing
    MOVX    A, @DPTR        ; | this address to the register R0
    MOV     DPL, A          ; |
    MOV     R0, DPL         ; /

    MOV     A, #01Ch        ; \;
    MOVX    @DPTR, A        ; | Writing a reference function
    INC     DPTR            ; | to external memory
    MOV     A, #03Ah        ; |
    MOVX    @DPTR, A        ; /

    MOV     DPTR, #8020h
    MOV     A, #2
    MOVX    @DPTR, A

    MOV     DPTR, #8021h
    MOV     A, #1
    MOVX    @DPTR, A

    MOV     DPTR, #8022h
    MOV     A, #4
    MOVX    @DPTR, A

    MOV     DPTR, #8023h
    MOV     A, #1
    MOVX    @DPTR, A

    MOV     DPTR, #8024h
    MOV     A, #3
    MOVX    @DPTR, A

    MOV     DPTR, #8025h
    MOV     A, #1
    MOVX    @DPTR, A

    MOV     DPTR, #8026h
    MOV     A, #1
    MOVX    @DPTR, A

    MOV     DPTR, #8027h
    MOV     A, #1
    MOVX    @DPTR, A

    MOV     DPTR, #8028h
    MOV     A, #1
    MOVX    @DPTR, A

    MOV     DPTR, #8029h
    MOV     A, #3
    MOVX    @DPTR, A

    MOV     DPTR, #802Ah
    MOV     A, #1
    MOVX    @DPTR, A

    MOV     DPTR, #802Bh
    MOV     A, #4
    MOVX    @DPTR, A

    MOV     DPTR, #802Ch
    MOV     A, #5
    MOVX    @DPTR, A

    MOV     DPTR, #802Dh
    MOV     A, #2
    MOVX    @DPTR, A

    MOV     DPTR, #802Eh
    MOV     A, #1
    MOVX    @DPTR, A

    MOV     DPTR, #802Fh
    MOV     A, #1
    MOVX    @DPTR, A

; Preparing input values
PREPARING:
    MOV     DPTR, #7FFBh    ; \;
    MOVX    A, @DPTR        ; | Cyclic polling of the readiness bit
    JZ      PREPARING       ; /
    MOV     DPTR, #7FFAh    ; \;
    MOVX    A, @DPTR        ; | Writing the input value to the internal memory
    MOV     20h, A          ; /

; Calculation of a logical function
    MOV     C, 1            ;
    ANL     C, /2           ;
    ANL     C, /3           ;
    MOV     8, C            ;
    MOV     C, 2            ;
    ANL     C, /0           ;
    ANL     C, /1           ;
    MOV     9, C            ;
    MOV     C, 2            ;
    ANL     C, /1           ;
    ANL     C, 3            ;
    MOV     10, C           ;
    MOV     C, 0            ;
    ANL     C, /2           ;
    ANL     C, 3            ;
    ORL     C, 8            ;
    ORL     C, 9            ;
    ORL     C, 10           ;
    MOV     8, C            ;

; Comparison of the obtained result with the reference function
    MOV     DPTR, #8000h    ; \;Preparing the address of
    MOV     DPL, R0         ; / the reference function
    JB      3, PTR_1        ; \;Checking which half
    AJMP    PTR_2           ; / of the reference function to use
PTR_1:
    INC     DPTR            ; \;Preparation for working with the
    CLR     3               ; / second half of the reference function
PTR_2:
    MOVX    A, @DPTR        ; Writing part of the reference function to the accumulator
    MOV     R1, 20h         ; Preparing the shift counter
SHIFT:
    CJNE    R1, #00h, PTR_3 ; \;
    AJMP    PTR_4           ; |
PTR_3:                      ; | Shift the desired bit to
    RR      A               ; | the first (index=0) position
    DEC     R1              ; |
    AJMP    SHIFT           ; /
PTR_4:
    MOV     C, 8            ; \;
    MOV     P4.0, C         ; | Output of the received result
    MOV     C, ACC.0        ; | and the reference to the P4 channel
    CPL     C               ; |
    MOV     P4.1, C         ; /
    MOV     DPTR, #7FFBh    ; \;
    MOV     A, #00h         ; | Resetting the ready bit to 0
    MOVX    @DPTR, A        ; /
    MOV     DPTR, #7FFAh    ; \;
    MOVX    A, @DPTR        ; | The following set
    INC     A               ; | of input data
    MOVX    @DPTR, A        ; /
    MOV     DPTR, #8000h
    DEC     A
    ANL     A, #00001111b
    ADD     A, #20h
    MOV     DPL, A
    MOVX    A, @DPTR
    MOV     B, A
    MOV     A, #15d
    MUL     AB
    MOV     R2, A
    MOV     TMOD, #00000011b
PTR_5:
    MOV     R1, #0FFh
PTR_6:
    CLR     TR0;
    MOV     TL0, #17h;
    SETB    TR0;
PTR_7:
    JBC     TF0, PTR_8
    AJMP    PTR_7
PTR_8:
    DJNZ    R1, PTR_6
    DJNZ    R2, PTR_5
    AJMP    PREPARING

END