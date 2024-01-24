	list            p=PIC16F873
	include         p16f873.inc
	__config _HS_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF


INDEX 	equ 20h	;Variable for index lookup table
d1		equ 21h	;Delay variable
d2		equ 22h	;Delay variable
d3		equ 23h	;Delay variable
temp	equ	24h ;Variable for storing lookup table value

;Bank macro
bank1 macro
	bsf STATUS, RP0
	endm
bank0 macro
	bcf STATUS, RP0
	endm

	org 0x00
	goto init

;Initialisering
init 
	bank1
	movlw	B'11000000'
	movwf	TRISC		;Set TRISC<7:6>, Se Datasheet s. 95
	movlw	b'00000001'
	movwf	TRISB		;Button input TRISB
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
	call	Delay		;4 sec delay to avoid input "bounce"

;Button input check
Main
	btfsc	PORTB,0		;Is RB0 set?
	call 	sendCommand	;Yes, send commands!
	goto 	Main		;No, check again

;Send all strings with 4 second delay between
sendCommand
	clrf	INDEX		;Clear INDEX varible to start from first byte in lookup table
	call	OUT_STR_1	;Call auxilary loop for lookup table, sort of a "helper loop"
	bsf		PORTB, 1
	call	Delay		;Call 4second delay between commands
	bcf		PORTB, 1
	clrf	INDEX		;Clear INDEX, so we dont jump way too far in lookup table
	;These next calls are similar to the first, but for different commands
	call	OUT_STR_2
	call	Delay
	clrf	INDEX
	call	OUT_STR_3
	call	Delay
	clrf	INDEX
	call	OUT_STR_4
	call	Delay
	clrf	INDEX
	call	OUT_STR_5
	return				;All commands done, return to main
	

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
	

;--------------------LOOKUP TABLE-----------------------------------------------------
;SetPTPCmd to move suction cup to object
LOOK1
	addwf	PCL, F      ;Add W-reg to Program counter, to jump to correct index.
	DT		0AAh, 0AAh, 13h, 54h, 03h, 00h, 95h, 65h, 48h, 41h, 0D3h, 0Dh, 4Ah, 0C3h, 4Ch, 0B7h, 7Ch, 0C2h, 0E3h, 0E7h, 0ACh, 0C2h, 0C0h, 0FFh

;SetEndEffectorSuctionCup to turn on suction cup
LOOK2
	addwf	PCL, F
	DT		0AAh, 0AAh, 04h, 3Eh, 03h, 01h, 01h, 0BDh, 0FFh

;SetPTPCmd to move sucked object to destination
LOOK3
	addwf	PCL, F
	DT		0AAh, 0AAh, 13h, 54h, 03h, 01h, 0C2h, 27h, 63h, 43h, 82h, 0E3h, 37h, 0C3h, 00h, 00h, 40h, 42h, 0FDh, 0F6h, 1Bh, 0C2h, 68h, 0FFh

;SetEndEffectorSuctionCup turn off to drop object
LOOK4
	addwf	PCL, F
	DT		0AAh, 0AAh, 04h, 3Eh, 03h, 00h, 00h, 0BFh, 0FFh

;SetPTPCmd to move arm to start position again	
LOOK5
	addwf	PCL, F
	DT		0AAh, 0AAh, 13h, 54h, 03h, 00h, 4Ah, 0Ch, 86h, 41h, 6Ah, 6Eh, 40h, 0C3h, 02h, 9Ah, 0ECh, 40h, 08h, 0Ch, 0AAh, 0C2h, 69h, 0FFh


Transmit
	btfss PIR1, TXIF	;Waiting for TXIF flag in PIR1 register to be set
						;TXIF indicates, whether the byte has been sent off
	goto Transmit		;Byte not sent, wait again
	return				;Byte sent, return
	
	
	
;--------------------DELAY---------------------------------------------
Delay					;4 Second delay
			;19999992 cycles
	movlw	0xB5
	movwf	d1
	movlw	0x99
	movwf	d2
	movlw	0x2C
	movwf	d3
Delay_0
	decfsz	d1, f
	goto	$+2
	decfsz	d2, f
	goto	$+2
	decfsz	d3, f
	goto	Delay_0

			;4 cycles
	goto	$+1
	goto	$+1

			;4 cycles (including call)
	return
	
	end

