
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

	movlw	b'00000001'	;RB0 Button input
	movwf	TRISB		
	movlw	b'00000111'	;RA0-2 Arduino input
	movwf	TRISA		

	movlw	B'11000000'	;Set TRISC<7:6>
	movwf	TRISC
	movlw	D'10'   	;Baud rate =  115200bps
	movwf	SPBRG
	movlw	B'00100100'	;TXEN=1, BRGH=1 - TX enable, high bitrate
	movwf	TXSTA
	movlw	b'00000110'	;Make AN0-AN4 digital
	movwf	ADCON1		

	bank0
	movlw	B'10000000'
	movwf	RCSTA		;SPEN=1 - Enables serial ports

	clrf	PORTB		;Clear PortB
	clrf	PORTA		;Clear PortA
	movlw	D'40'
	call 	DELAYLOOP		;4 sec delay to avoid input "bounce"

;-----------------------  Button input check  ----------------------------------------
Main
	btfss	PORTB,0		;Is RB0 set?
	goto 	Main		;No, check again

	bsf		PORTB,1		;Send signal to PIC16F84A
	bsf		PORTA,3		;Send signal to Arduino


;----------  innerProgram ----------

	movlw	D'40'
	call 	DELAYLOOP
layer0
	btfss	PORTA,0
	goto	layer10
	goto	layer11


layer10
	btfss	PORTA,1
	goto	layer20
	goto	layer21
layer11
	btfss	PORTA,1
	goto	layer22
	goto	layer23


layer20
	btfss	PORTA,2
	goto	layer0
	goto	grayC
layer21
	btfss	PORTA,2
	goto 	redC
	goto	blueC
layer22
	btfss	PORTA,2
	goto	greenC
	goto	blackC
layer23
	btfss	PORTA,2
	goto	purpleC
	goto	yellowC


After
	btfsc	PORTB,0		;Is RB0 set?
	goto	innerProgram

	bcf		PORTB,1		;Stop signal to PIC16F84A
	bcf		PORTA,3		;Stop signal to Arduino
	goto 	Main



;===========================================================================================================================================
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;===========================================================================================================================================

grayC

	clrf	INDEX			;Clear INDEX varible to start from first byte in lookup table
	call	gray_OUT_STR_1	;Call auxilary loop for lookup table, sort of a "helper loop"

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX		
	call	gray_OUT_STR_2

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	gray_OUT_STR_3

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	gray_OUT_STR_4

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	gray_OUT_STR_5

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	gray_OUT_STR_6

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	gray_OUT_STR_7

	goto After				;All commands done, goto after

redC
	bsf		PORTB,2

	clrf	INDEX		;Clear INDEX varible to start from first byte in lookup table
	call	red_OUT_STR_1	;Call auxilary loop for lookup table, sort of a "helper loop"

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX		
	call	red_OUT_STR_2

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	red_OUT_STR_3

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	red_OUT_STR_4

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	red_OUT_STR_5

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	red_OUT_STR_6

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	red_OUT_STR_7
	goto After				;All commands done, goto after

blueC
	bsf		PORTB,2

	clrf	INDEX		;Clear INDEX varible to start from first byte in lookup table
	call	blue_OUT_STR_1	;Call auxilary loop for lookup table, sort of a "helper loop"

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX		
	call	blue_OUT_STR_2

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	blue_OUT_STR_3

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	blue_OUT_STR_4

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	blue_OUT_STR_5

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	blue_OUT_STR_6

	goto After				;All commands done, goto after


greenC
	bsf		PORTB,2

	clrf	INDEX		;Clear INDEX varible to start from first byte in lookup table
	call	green_OUT_STR_1	;Call auxilary loop for lookup table, sort of a "helper loop"

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX		
	call	green_OUT_STR_2

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	green_OUT_STR_3

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	green_OUT_STR_4

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	green_OUT_STR_5

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	green_OUT_STR_6

	goto After				;All commands done, goto after


blackC
	bsf		PORTB,2

	clrf	INDEX		;Clear INDEX varible to start from first byte in lookup table
	call	black_OUT_STR_1	;Call auxilary loop for lookup table, sort of a "helper loop"

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX		
	call	black_OUT_STR_2

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	black_OUT_STR_3

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	black_OUT_STR_4

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	black_OUT_STR_5

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	black_OUT_STR_6

	goto After				;All commands done, goto after


purpleC
	bsf		PORTB,2

	clrf	INDEX		;Clear INDEX varible to start from first byte in lookup table
	call	purple_OUT_STR_1	;Call auxilary loop for lookup table, sort of a "helper loop"

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX		
	call	purple_OUT_STR_2

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	purple_OUT_STR_3

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	purple_OUT_STR_4

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	purple_OUT_STR_5

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	purple_OUT_STR_6

	goto After				;All commands done, goto after


yellowC
	bsf		PORTB,2

	clrf	INDEX		;Clear INDEX varible to start from first byte in lookup table
	call	yellow_OUT_STR_1	;Call auxilary loop for lookup table, sort of a "helper loop"

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX		
	call	yellow_OUT_STR_2

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	yellow_OUT_STR_3

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	yellow_OUT_STR_4

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	yellow_OUT_STR_5

	movlw	D'4'
	call 	DELAYLOOP
	clrf	INDEX
	call	yellow_OUT_STR_6

	goto After				;All commands done, goto after
	
;----------------------------------------------------------------------------------------------------------------------------------
;||||||||||||||||||||||||||||||||||||  OUT_STR  ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;-----------------------------------------------------------------------------------------------------------------------------------
;Loop to help send the whole lookup table byte by byte, one at a time
gray_OUT_STR_1
	movf	INDEX, W		;Mov INDEX to w reg, for transfer to lookup table
	call	gray_LOOK1		;Call lookuptable, which return with value corresponding to the index we pass it
	movwf	temp			;Store returned value for later use
	addlw	01h				;Add 1 to w-reg, sets Z flag if value is 255, which indicates lookup table end
	btfsc	STATUS, Z		;Was the Z flag set in previous action?
	return					;Yes, packet is done and command is sent, return to sendCommand
	movf	temp,W			;No, we need to send the byte we got from lookup table. Retrieve stored value from temp
	movwf	TXREG			;Move byte to TXREG for transmission
	nop						;Wait 1 cycle (helps with simulation)
	call	Transmit		;Call Transmit, which waits till the whole byte is transmitted
	incf	INDEX, F		;Increment INDEX by 1, to reach next byte in lookup table
	goto	gray_OUT_STR_1	;Goto start of function to send next bit
	
gray_OUT_STR_2
	movf	INDEX, W
	call	gray_LOOK2
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	gray_OUT_STR_2
	
gray_OUT_STR_3
	movf	INDEX, W
	call	gray_LOOK3
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	gray_OUT_STR_3
	
gray_OUT_STR_4
	movf	INDEX, W
	call	gray_LOOK4
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	gray_OUT_STR_4
	
gray_OUT_STR_5
	movf	INDEX, W
	call	gray_LOOK5
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	gray_OUT_STR_5

gray_OUT_STR_6
	movf	INDEX, W
	call	gray_LOOK6
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	gray_OUT_STR_6

gray_OUT_STR_7
	movf	INDEX, W
	call	gray_LOOK7
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	gray_OUT_STR_7

;----- Red -------------------------------

red_OUT_STR_1
	movf	INDEX, W
	call	red_LOOK1
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	red_OUT_STR_1

red_OUT_STR_2
	movf	INDEX, W
	call	red_LOOK2
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	red_OUT_STR_2

red_OUT_STR_3
	movf	INDEX, W
	call	red_LOOK3
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	red_OUT_STR_3

red_OUT_STR_4
	movf	INDEX, W
	call	red_LOOK4
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	red_OUT_STR_4

red_OUT_STR_5
	movf	INDEX, W
	call	red_LOOK5
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	red_OUT_STR_5

red_OUT_STR_6
	movf	INDEX, W
	call	red_LOOK6
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	red_OUT_STR_6

red_OUT_STR_7
	movf	INDEX, W
	call	red_LOOK7
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	red_OUT_STR_7



;----- Blue  -----------------------------------------
blue_OUT_STR_1
	movf	INDEX, W
	call	blue_LOOK1
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	blue_OUT_STR_1

blue_OUT_STR_2
	movf	INDEX, W
	call	blue_LOOK2
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	blue_OUT_STR_2

blue_OUT_STR_3
	movf	INDEX, W
	call	blue_LOOK3
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	blue_OUT_STR_3

blue_OUT_STR_4
	movf	INDEX, W
	call	blue_LOOK4
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	blue_OUT_STR_4

blue_OUT_STR_5
	movf	INDEX, W
	call	blue_LOOK5
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	blue_OUT_STR_5

blue_OUT_STR_6
	movf	INDEX, W
	call	blue_LOOK6
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	blue_OUT_STR_6


;----- green -------- 

green_OUT_STR_1
	movf	INDEX, W
	call	green_LOOK1
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	green_OUT_STR_1

green_OUT_STR_2
	movf	INDEX, W
	call	green_LOOK2
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	green_OUT_STR_2

green_OUT_STR_3
	movf	INDEX, W
	call	green_LOOK3
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	green_OUT_STR_3

green_OUT_STR_4
	movf	INDEX, W
	call	green_LOOK4
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	green_OUT_STR_4

green_OUT_STR_5
	movf	INDEX, W
	call	green_LOOK5
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	green_OUT_STR_5

green_OUT_STR_6
	movf	INDEX, W
	call	green_LOOK6
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	green_OUT_STR_6

;---------Black ------------

black_OUT_STR_1
	movf	INDEX, W
	call	black_LOOK1
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	black_OUT_STR_1

black_OUT_STR_2
	movf	INDEX, W
	call	black_LOOK2
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	black_OUT_STR_2

black_OUT_STR_3
	movf	INDEX, W
	call	black_LOOK3
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	black_OUT_STR_3

black_OUT_STR_4
	movf	INDEX, W
	call	black_LOOK4
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	black_OUT_STR_4

black_OUT_STR_5
	movf	INDEX, W
	call	black_LOOK5
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	black_OUT_STR_5

black_OUT_STR_6
	movf	INDEX, W
	call	black_LOOK6
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	black_OUT_STR_6

; -------purple --------

purple_OUT_STR_1
	movf	INDEX, W
	call	purple_LOOK1
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	purple_OUT_STR_1

purple_OUT_STR_2
	movf	INDEX, W
	call	purple_LOOK2
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	purple_OUT_STR_2

purple_OUT_STR_3
	movf	INDEX, W
	call	purple_LOOK3
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	purple_OUT_STR_3

purple_OUT_STR_4
	movf	INDEX, W
	call	purple_LOOK4
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	purple_OUT_STR_4

purple_OUT_STR_5
	movf	INDEX, W
	call	purple_LOOK5
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	purple_OUT_STR_5

purple_OUT_STR_6
	movf	INDEX, W
	call	purple_LOOK6
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	purple_OUT_STR_6


; ------- yellow ------------ 

yellow_OUT_STR_1
	movf	INDEX, W
	call	yellow_LOOK1
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	yellow_OUT_STR_1

yellow_OUT_STR_2
	movf	INDEX, W
	call	yellow_LOOK2
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	yellow_OUT_STR_2

yellow_OUT_STR_3
	movf	INDEX, W
	call	yellow_LOOK3
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	yellow_OUT_STR_3

yellow_OUT_STR_4
	movf	INDEX, W
	call	yellow_LOOK4
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	yellow_OUT_STR_4

yellow_OUT_STR_5
	movf	INDEX, W
	call	yellow_LOOK5
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	yellow_OUT_STR_5

yellow_OUT_STR_6
	movf	INDEX, W
	call	yellow_LOOK6
	movwf	temp
	addlw	01h
	btfsc	STATUS, Z
	return
	movf	temp,W
	movwf	TXREG
	nop
	call	Transmit
	incf	INDEX, F
	goto	yellow_OUT_STR_6


;----------------------------------------------------------------------------------------
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;--------------------LOOKUP TABLE-----------------------------------------------------
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;----------------------------------------------------------------------------------------


;Sug fat i jeton
gray_LOOK1
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0xCC, 0xCF, 0x24, 0x43, 0x4E, 0xA2, 0x90, 0xC2, 0x1D, 0xC9, 0x11, 0xC0, 0xE5, 0x61, 0xFD, 0xC2, 0xAA, 0xFF

;Sucktioncup on
gray_LOOK2
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x04, 0x3E, 0x03, 0x01, 0x01, 0xBD, 0xFF

;Gå op med jeton
gray_LOOK3
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x4F, 0x40, 0x22, 0x43, 0x9E, 0xBE, 0x8E, 0xC2, 0xFB, 0x8B, 0x6D, 0x42, 0x08, 0x7D, 0xFD, 0xC2, 0x91, 0xFF


;1 højre - 5
gray_LOOK4
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x00, 0x00, 0x20, 0x43, 0x09, 0x62, 0x8B, 0xC3, 0x00, 0x00, 0xA0, 0xC1, 0x33, 0xF3, 0x21, 0xC3, 0x23, 0xFF

;Suck off
gray_LOOK5
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x04, 0x3E, 0x03, 0x00, 0x00, 0xBF, 0xFF

;Op 1 højre
gray_LOOK6
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x00, 0x00, 0x20, 0x43, 0x09, 0x62, 0x8B, 0xC3, 0x00, 0x00, 0x20, 0xC1, 0x33, 0xF3, 0x21, 0xC3, 0xA3, 0xFF


;Home
gray_LOOK7
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0xDF, 0xB0, 0x25, 0x43, 0x53, 0xC5, 0x91, 0xC2, 0x66, 0xA6, 0x5A, 0x42, 0x08, 0x7D, 0xFD, 0xC2, 0x5C, 0xFF



; red -2----------------7------

;Sug fat i jeton
red_LOOK1
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0xCC, 0xCF, 0x24, 0x43, 0x4E, 0xA2, 0x90, 0xC2, 0x1D, 0xC9, 0x11, 0xC0, 0xE5, 0x61, 0xFD, 0xC2, 0xAA, 0xFF

;Suck on
red_LOOK2
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x04, 0x3E, 0x03, 0x01, 0x01, 0xBD, 0xFF

;Gå op med jeton
red_LOOK3
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x4F, 0x40, 0x22, 0x43, 0x9E, 0xBE, 0x8E, 0xC2, 0xFB, 0x8B, 0x6D, 0x42, 0x08, 0x7D, 0xFD, 0xC2, 0x91, 0xFF


;2 højre - 10
red_LOOK4
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x00, 0x00, 0xD2, 0x42, 0x09, 0x62, 0x8B, 0xC3, 0x00, 0x00, 0xA0, 0xC1, 0x33, 0xF3, 0x21, 0xC3, 0x72, 0xFF

;Suck off
red_LOOK5
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x04, 0x3E, 0x03, 0x00, 0x00, 0xBF, 0xFF

;Op 1 højre
red_LOOK6
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x00, 0x00, 0x20, 0x43, 0x09, 0x62, 0x8B, 0xC3, 0x00, 0x00, 0x20, 0xC1, 0x33, 0xF3, 0x21, 0xC3, 0xA3, 0xFF


;Home
red_LOOK7
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0xDF, 0xB0, 0x25, 0x43, 0x53, 0xC5, 0x91, 0xC2, 0x66, 0xA6, 0x5A, 0x42, 0x08, 0x7D, 0xFD, 0xC2, 0x5C, 0xFF

; blue -3-------------------------------6----------------------

;Sug fat i jeton
blue_LOOK1
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0xCC, 0xCF, 0x24, 0x43, 0x4E, 0xA2, 0x90, 0xC2, 0x1D, 0xC9, 0x11, 0xC0, 0xE5, 0x61, 0xFD, 0xC2, 0xAA, 0xFF

;Suck on
blue_LOOK2
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x04, 0x3E, 0x03, 0x01, 0x01, 0xBD, 0xFF

;Gå op med jeton
blue_LOOK3
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x4F, 0x40, 0x22, 0x43, 0x9E, 0xBE, 0x8E, 0xC2, 0xFB, 0x8B, 0x6D, 0x42, 0x08, 0x7D, 0xFD, 0xC2, 0x91, 0xFF


;3 højre - 25
blue_LOOK4
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x00, 0x00, 0x48, 0x42, 0x09, 0x62, 0x8B, 0xC3, 0x00, 0x00, 0xA0, 0xC1, 0x33, 0xF3, 0x21, 0xC3, 0xFC, 0xFF

;Suck off
blue_LOOK5
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x04, 0x3E, 0x03, 0x00, 0x00, 0xBF, 0xFF

;Home
blue_LOOK6
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0xDF, 0xB0, 0x25, 0x43, 0x53, 0xC5, 0x91, 0xC2, 0x66, 0xA6, 0x5A, 0x42, 0x08, 0x7D, 0xFD, 0xC2, 0x5C, 0xFF


; green ---------------------------------------6--------------------------


;Sug fat i jeton
green_LOOK1
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0xCC, 0xCF, 0x24, 0x43, 0x4E, 0xA2, 0x90, 0xC2, 0x1D, 0xC9, 0x11, 0xC0, 0xE5, 0x61, 0xFD, 0xC2, 0xAA, 0xFF

;Suck on
green_LOOK2
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x04, 0x3E, 0x03, 0x01, 0x01, 0xBD, 0xFF

;Gå op med jeton
green_LOOK3
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x4F, 0x40, 0x22, 0x43, 0x9E, 0xBE, 0x8E, 0xC2, 0xFB, 0x8B, 0x6D, 0x42, 0x08, 0x7D, 0xFD, 0xC2, 0x91, 0xFF


;4 højre - 1000
green_LOOK4
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x00, 0x00, 0xA0, 0xC0, 0x09, 0x62, 0x8B, 0xC3, 0x00, 0x00, 0xA0, 0xC1, 0x33, 0xF3, 0x21, 0xC3, 0x26, 0xFF

;Suck off
green_LOOK5
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x04, 0x3E, 0x03, 0x00, 0x00, 0xBF, 0xFF

;Home
green_LOOK6
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0xDF, 0xB0, 0x25, 0x43, 0x53, 0xC5, 0x91, 0xC2, 0x66, 0xA6, 0x5A, 0x42, 0x08, 0x7D, 0xFD, 0xC2, 0x5C, 0xFF

; black --------------------------------------6----------------------------------------------

;Sug fat i jeton
black_LOOK1
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0xCC, 0xCF, 0x24, 0x43, 0x4E, 0xA2, 0x90, 0xC2, 0x1D, 0xC9, 0x11, 0xC0, 0xE5, 0x61, 0xFD, 0xC2, 0xAA, 0xFF

;Suck on
black_LOOK2
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x04, 0x3E, 0x03, 0x01, 0x01, 0xBD, 0xFF

;Gå op med jeton
black_LOOK3
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x4F, 0x40, 0x22, 0x43, 0x9E, 0xBE, 0x8E, 0xC2, 0xFB, 0x8B, 0x6D, 0x42, 0x08, 0x7D, 0xFD, 0xC2, 0x91, 0xFF


;5 højre
black_LOOK4
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x00, 0x00, 0x70, 0xC2, 0x09, 0x62, 0x8B, 0xC3, 0x00, 0x00, 0xA0, 0xC1, 0x33, 0xF3, 0x21, 0xC3, 0x54, 0xFF

;Suck off
black_LOOK5
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x04, 0x3E, 0x03, 0x00, 0x00, 0xBF, 0xFF

;Home
black_LOOK6
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0xDF, 0xB0, 0x25, 0x43, 0x53, 0xC5, 0x91, 0xC2, 0x66, 0xA6, 0x5A, 0x42, 0x08, 0x7D, 0xFD, 0xC2, 0x5C, 0xFF

; purple --------------------------------------------6----------------------------------------
;Sug fat i jeton
purple_LOOK1
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0xCC, 0xCF, 0x24, 0x43, 0x4E, 0xA2, 0x90, 0xC2, 0x1D, 0xC9, 0x11, 0xC0, 0xE5, 0x61, 0xFD, 0xC2, 0xAA, 0xFF

;Suck on
purple_LOOK2
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x04, 0x3E, 0x03, 0x01, 0x01, 0xBD, 0xFF

;Gå op med jeton
purple_LOOK3
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x4F, 0x40, 0x22, 0x43, 0x9E, 0xBE, 0x8E, 0xC2, 0xFB, 0x8B, 0x6D, 0x42, 0x08, 0x7D, 0xFD, 0xC2, 0x91, 0xFF

;6 højre
purple_LOOK4
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x00, 0x00, 0xE6, 0xC2, 0x09, 0x62, 0x8B, 0xC3, 0x00, 0x00, 0xA0, 0xC1, 0x33, 0xF3, 0x21, 0xC3, 0xDE, 0xFF

;Suck off
purple_LOOK5
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x04, 0x3E, 0x03, 0x00, 0x00, 0xBF, 0xFF

;Home
purple_LOOK6
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0xDF, 0xB0, 0x25, 0x43, 0x53, 0xC5, 0x91, 0xC2, 0x66, 0xA6, 0x5A, 0x42, 0x08, 0x7D, 0xFD, 0xC2, 0x5C, 0xFF

; yellow --------------------------------------------------6----------------------------------

;Sug fat i jeton
yellow_LOOK1
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0xCC, 0xCF, 0x24, 0x43, 0x4E, 0xA2, 0x90, 0xC2, 0x1D, 0xC9, 0x11, 0xC0, 0xE5, 0x61, 0xFD, 0xC2, 0xAA, 0xFF

;Suck on
yellow_LOOK2
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x04, 0x3E, 0x03, 0x01, 0x01, 0xBD, 0xFF

;Gå op med jeton
yellow_LOOK3
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x4F, 0x40, 0x22, 0x43, 0x9E, 0xBE, 0x8E, 0xC2, 0xFB, 0x8B, 0x6D, 0x42, 0x08, 0x7D, 0xFD, 0xC2, 0x91, 0xFF


;7 højre
yellow_LOOK4
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0x00, 0x00, 0x2A, 0xC3, 0x09, 0x62, 0x8B, 0xC3, 0x00, 0x00, 0xA0, 0xC1, 0x33, 0xF3, 0x21, 0xC3, 0x99, 0xFF

;Suck off
yellow_LOOK5
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x04, 0x3E, 0x03, 0x00, 0x00, 0xBF, 0xFF

;Home
yellow_LOOK6
	addwf	PCL, F
	DT		0xAA, 0xAA, 0x13, 0x54, 0x01, 0x01, 0xDF, 0xB0, 0x25, 0x43, 0x53, 0xC5, 0x91, 0xC2, 0x66, 0xA6, 0x5A, 0x42, 0x08, 0x7D, 0xFD, 0xC2, 0x5C, 0xFF









; --------------------- TRANSMIT ----------------------------------------------------

Transmit
	btfss PIR1, TXIF	;Waiting for TXIF flag in PIR1 register to be set
						;TXIF indicates, whether the byte has been sent off
	goto Transmit		;Byte not sent, wait again
	return				;Byte sent, return
	
	
	
;-----DELAY---------------

DELAYLOOP
	movwf	DCLoop
DLOOP
	call DELAY100
	DECFSZ DCLoop, 1	;DCLoop - 1, skip if zero
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
