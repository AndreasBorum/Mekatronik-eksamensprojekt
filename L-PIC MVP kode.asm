;********************************************************
;
;               Stepper Motor controller
;
;                                 Author : Seiichi Inoue
;********************************************************

        list            p=pic16f84a
        include         p16f84a.inc
;        __config _hs_osc & _wdt_off & _pwrte_on & _cp_off
 
__CONFIG       _CP_OFF & _PWRTE_ON & _WDT_OFF & _HS_OSC

       errorlevel      -302    ;Eliminate bank warning

;****************  Label Definition  ********************
        cblock  h'0c'
mode                            ;Operation mode
                                ;0=stop 1=right 2=left
count1                          ;Wait counter
count2                          ;Wait counter(for 1msec)
count3

DCounter1
DCounter2
DCounter3

		endc


status	equ	03h
porta	equ 05
portb	equ	06
trisa	equ	85h
trisb	equ	86h
intcon	equ	0Bh
rp0		equ	5
option_reg	equ	81h



rb0     equ     0               ;RB0 of PORTB
rb1     equ     1               ;RB1 of PORTB
rb2     equ     2               ;RB2 of PORTB

rb5     equ     5               ;RB5 of PORTB

rb7     equ     7               ;RB7 of PORTB

;****************  Program Start  ***********************
        org     0               ;Reset Vector
       goto    init
        org     4               ;Interrupt Vector
        clrf    intcon          ;Clear Interruption reg

;****************  Initial Process  *********************
init
        bsf     status,rp0      ;Change to Bank1
        clrf    trisa           ;Set PORTA all OUT
        movlw   b'00100111'     ;RB0,1,2.5=IN RB7=OUT
        movwf   trisb           ;Set PORTB
        movlw   b'10000000'     ;RBPU=1 Pull up not use
        movwf   option_reg      ;Set OPTION_REG
        bcf     status,rp0      ;Change to Bank0
        clrf    mode            ;Set mode = stop
        clrf    count1          ;Clear counter
        clrf    count2          ;Clear counter
		clrf	count3

        movlw   b'00000101'     ;Set PORTA initial value
        movwf   porta           ;Write PORTA
        bsf     portb,rb7       ;Set RB7 = 1
        btfsc   portb,rb5       ;RB5 = 0 ?
        goto    $-1             ;No. Wait

start
;*************  Check switch condition  *****************
        btfsc   portb,rb1       ;RB1(stop key) = OFF ?
        goto    setmode         ;No. goto setmode
        clrf    mode            ;Yes. Set stop mode
        goto    drive           ;No. Jump to motor drive

setmode
        movlw   d'1'            ;Yes. Set left mode
        movwf   mode            ;Save mode
		movlw	d'200'
		movwf	count3
		goto    drive           ;No. Jump to motor drive


		
;********************  Motor drive  *********************


drive
        movf    mode,w          ;Read mode
        bz      start           ;mode = stop
        bsf     portb,rb7       ;Set RB7 = 1
        btfsc   portb,rb5       ;RB5 = 0 ?
        goto    $-1             ;No. Wait
        movlw   d'5'            ;Set loop count(5msec)
        movwf   count1          ;Save loop count
loop    call    timer           ;Wait 1msec
        decfsz  count1,f        ;count - 1 = 0 ?
        goto    loop            ;No. Continue
        bcf     portb,rb7       ;Set RB7 = 0
        btfss   portb,rb5       ;RB5 = 1 ?
        goto    $-1             ;No. Wait
        movf    porta,w         ;Read PORTA
        sublw   b'000000101'    ;Check motor position
        bnz     drive2          ;Unmatch
        movf    mode,w          ;Read mode
        sublw   d'1'            ;Right ?
        bz      drive1          ;Yes. Right
        movlw   b'00001001'     ;No. Set Left data
        goto    drive_end       ;Jump to PORTA write
drive1
        movlw   b'00000110'     ;Set Right data
        goto    drive_end       ;Jump to PORTA write
;-------
drive2
        movf    porta,w         ;Read PORTA
        sublw   b'000000110'    ;Check motor position
        bnz     drive4          ;Unmatch
        movf    mode,w          ;Read mode
        sublw   d'1'            ;Right ?
        bz      drive3          ;Yes. Right
        movlw   b'00000101'     ;No. Set Left data
        goto    drive_end       ;Jump to PORTA write
drive3
        movlw   b'00001010'     ;Set Right data
        goto    drive_end       ;Jump to PORTA write
;-------
drive4
        movf    porta,w         ;Read PORTA
        sublw   b'000001010'    ;Check motor position
        bnz     drive6          ;Unmatch
        movf    mode,w          ;Read mode
        sublw   d'1'            ;Right ?
        bz      drive5          ;Yes. Right
        movlw   b'00000110'     ;No. Set Left data
        goto    drive_end       ;Jump to PORTA write
drive5
        movlw   b'00001001'     ;Set Right data
        goto    drive_end       ;Jump to PORTA write
;-------
drive6
        movf    porta,w         ;Read PORTA
        sublw   b'000001001'    ;Check motor position
        bnz     drive8          ;Unmatch
        movf    mode,w          ;Read mode
        sublw   d'1'            ;Right ?
        bz      drive7          ;Yes. Right
        movlw   b'00001010'     ;No. Set Left data
        goto    drive_end       ;Jump to PORTA write
drive7
        movlw   b'00000101'     ;Set Right data
        goto    drive_end       ;Jump to PORTA write
;-------
drive8
        movlw   b'00000101'     ;Compulsion setting

drive_end
        movwf   porta           ;Write PORTA
		decfsz	count3,f
		goto	drive
		call	DELAY
		clrf	mode
        goto    start           ;Jump to start

;*************  1msec Timer Subroutine  *****************
timer
        movlw   d'200'          ;Set loop count to 200
        movwf   count2          ;Save loop count
tmlp    nop                     ;Time adjust
        nop                     ;Time adjust
        decfsz  count2,f        ;count - 1 = 0 ?
        goto    tmlp            ;No. Continue
        return                  ;Yes. Count end

		




DELAY
MOVLW 0X7d
MOVWF DCounter1
MOVLW 0X96
MOVWF DCounter2
MOVLW 0X29
MOVWF DCounter3
LOOP
DECFSZ DCounter1, 1
GOTO LOOP
DECFSZ DCounter2, 1
GOTO LOOP
DECFSZ DCounter3, 1
GOTO LOOP
RETURN

;********************************************************
;             END of Stepper Motor controller
;********************************************************

        end


