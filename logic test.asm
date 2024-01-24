; logic test

	list            p=PIC16F873
	include         p16f873.inc
	__config _HS_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF


INDEX 			equ 20h	;Variable for index lookup table
DCounter1		equ 21h	;Delay variable
DCounter2		equ 22h	;Delay variable
DCounter3		equ 23h	;Delay variable
DCLoop			equ 24h
temp			equ	25h ;Variable for storing lookup table value

;Bank macro
bank1 macro
	bsf STATUS, RP0
	endm
bank0 macro
	bcf STATUS, RP0
	endm

	org 0x00
	goto init

;-------------------------  Initialisering  -----------------------------------
init 
	bank1
	movlw	B'11000000'
	movwf	TRISC		;Set TRISC<7:6>, Se Datasheet s. 95

	movlw	b'00000001'
	movwf	TRISB		;Button input TRISB
	movlw	b'00000111'
	movwf	TRISA		;Arduino TRISA

	movlw	D'10'   	;Baud rate =  115200bps
	movwf	SPBRG
	movlw	B'00100100'	;TXEN=1, BRGH=1 - TX enable, high bitrate
	movwf	TXSTA
	movlw	b'00000110'
	movwf	ADCON1		;Make AN0-AN4 digital
	bank0
	movlw	B'10000000'
	movwf	RCSTA		;SPEN=1 - Enables serial ports

	clrf	PORTB		;Clear PortB
	clrf	PORTA
	movlw	D'40'
	call 	DELAYLOOP		;4 sec delay to avoid input "bounce"

;-----------------------  Button input check  ----------------------------------------

	;call	OUT_STR_HOME

Main
	btfss	PORTB,0		;Is RB0 set?
	goto 	Main		;No, check again

	bsf		PORTB,1		;Send signal to PIC16F84A
	bsf		PORTA,3		;Send signal to Arduino


innerProgram

	movlw	D'40'
	call 	DELAYLOOP
layer0
	btfss	PORTA,0
	goto	layer10
	goto	grayC

layer10
	btfss	PORTA,1
	goto	layer0
	goto	redC


After
	btfsc	PORTB,0		;Is RB0 set?
	goto	innerProgram

	bcf		PORTB,1		;Send signal to PIC16F84A
	bcf		PORTA,3		;Send signal to Arduino
	goto 	Main



;===========================================================================================================================================
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;===========================================================================================================================================

grayC
	bsf		PORTB,2
	movlw	D'40'
	call 	DELAYLOOP
	bcf		PORTB,2	

	goto After				;All commands done, goto after

redC

	bsf		PORTB,2
	movlw	D'40'
	call 	DELAYLOOP
	bcf		PORTB,2

	goto After				;All commands done, goto after


	
	
;--------------------DELAY---------------------------------------------

DELAYLOOP
	movwf	DCLoop
	DLOOP
	call DELAY100
	DECFSZ DCLoop, 1
	GOTO DLOOP
	NOP
	RETURN



DELAY100		; 100 ms delay
	MOVLW 0X54
	MOVWF DCounter1
	MOVLW 0X8a
	MOVWF DCounter2
	MOVLW 0X03
	MOVWF DCounter3
	LOOP
	DECFSZ DCounter1, 1
	GOTO LOOP
	DECFSZ DCounter2, 1
	GOTO LOOP
	DECFSZ DCounter3, 1
	GOTO LOOP
	NOP
	RETURN
	
	end





