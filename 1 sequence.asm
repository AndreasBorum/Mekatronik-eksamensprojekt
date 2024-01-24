; logic med 1 række comands
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

	clrf	INDEX		;Clear INDEX varible to start from first byte in lookup table
	call	OUT_STR_1	;Call auxilary loop for lookup table, sort of a "helper loop"

	movlw	D'40'
	call 	DELAYLOOP

	bcf		PORTB,2

	clrf	INDEX		
	call	OUT_STR_2

	movlw	D'40'
	call 	DELAYLOOP

	bsf		PORTB,2

	clrf	INDEX
	call	OUT_STR_3

	movlw	D'40'
	call 	DELAYLOOP
	
	bcf		PORTB,2	

	clrf	INDEX
	call	OUT_STR_4

	movlw	D'40'
	call 	DELAYLOOP
	
	bsf		PORTB,2

	clrf	INDEX
	call	OUT_STR_5

	movlw	D'40'
	call 	DELAYLOOP

	bcf		PORTB,2

	clrf	INDEX
	call	OUT_STR_6

	movlw	D'40'
	call 	DELAYLOOP
	
	bsf		PORTB,2

	clrf	INDEX
	call	OUT_STR_7

	bcf		PORTB,2
	goto After				;All commands done, goto after

redC

	goto After				;All commands done, goto after

	
;----------------------------------------------------------------------------------------------------------------------------------
;||||||||||||||||||||||||||||||||||||  OUT_STR  ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;-----------------------------------------------------------------------------------------------------------------------------------


;Loop to help send the whole lookup table byte by byte, one at a time
OUT_STR_1
	movf	INDEX, W	;Mov INDEX to w reg, for transfer to lookup table
	call	LOOK1		;Call lookuptable, which return with value corresponding to the index we pass it
	movwf	temp		;Store returned value for later use
	addlw	01h			;Add 1 to w-reg, sets Z flag if value is 255, which indicates lookup table end
	btfsc	STATUS, Z	;Was the Z flag set in previous action?
	return				;Yes, packet is done and command is sent, return to sendCommand
	movf	temp,W		;No, we need to send the byte we got from lookup table. Retrieve stored value from temp (line 72)
	movwf	TXREG		;Move byte to TXREG for transmission
	nop					;Wait 1 cycle (helps with simulation)
	call	Transmit	;Call Transmit, which waits till the whole byte is transmitted
	incf	INDEX, F	;Increment INDEX by 1, to reach next byte in lookup table
	goto	OUT_STR_1	;Goto start of function to send next bit
	
OUT_STR_2
	movf	INDEX, W
	call	LOOK2
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	OUT_STR_2
	
OUT_STR_3
	movf	INDEX, W
	call	LOOK3
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	OUT_STR_3
	
OUT_STR_4
	movf	INDEX, W
	call	LOOK4
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	OUT_STR_4
	
OUT_STR_5
	movf	INDEX, W
	call	LOOK5
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	OUT_STR_5

OUT_STR_6
	movf	INDEX, W
	call	LOOK6
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	OUT_STR_6

OUT_STR_7
	movf	INDEX, W
	call	LOOK7
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	OUT_STR_7
	


;----------------------------------------------------------------------------------------
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;--------------------LOOKUP TABLE-----------------------------------------------------
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;----------------------------------------------------------------------------------------


;Sug fat i jeton
LOOK1
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0xCC, 0xCF, 0x24, 0x43, 0x4E, 0xA2, 0x90, 0xC2, 0x1D, 0xC9, 0x11, 0xC0, 0xE5, 0x61, 0xFD, 0xC2, 0xAA, 0xFF

;Suck on
LOOK2
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x04, 0x3E, 0x03, 0x01, 0x01, 0xBD, 0xFF

;Gå op med jeton
LOOK3
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x4F, 0x40, 0x22, 0x43, 0x9E, 0xBE, 0x8E, 0xC2, 0xFB, 0x8B, 0x6D, 0x42, 0x08, 0x7D, 0xFD, 0xC2, 0x91, 0xFF


;1 højre - 5
LOOK4
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x00, 0x00, 0x20, 0x43, 0x09, 0x62, 0x8B, 0xC3, 0x00, 0x00, 0xA0, 0xC1, 0x33, 0xF3, 0x21, 0xC3, 0x23, 0xFF

;Suck off
LOOK5
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x04, 0x3E, 0x03, 0x00, 0x00, 0xBF, 0xFF

;Op 1 højre
LOOK6
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x00, 0x00, 0x20, 0x43, 0x09, 0x62, 0x8B, 0xC3, 0x00, 0x00, 0x20, 0xC1, 0x33, 0xF3, 0x21, 0xC3, 0xA3, 0xFF


;Home
LOOK7
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0xDF, 0xB0, 0x25, 0x43, 0x53, 0xC5, 0x91, 0xC2, 0x66, 0xA6, 0x5A, 0x42, 0x08, 0x7D, 0xFD, 0xC2, 0x5C, 0xFF


; --------------------- TRANSMIT ----------------------------------------------------

Transmit
	btfss PIR1, TXIF	;Waiting for TXIF flag in PIR1 register to be set
						;TXIF indicates, whether the byte has been sent off
	goto Transmit		;Byte not sent, wait again
	return				;Byte sent, return
	
	
	
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





