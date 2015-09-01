
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 2,000000 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_pp:
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x41,0x8,0x0,0xF8,0x41,0x8,0x0,0xF8
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x0,0xF8,0x41,0x8,0x0,0xF8,0x41,0x8
	.DB  0x0,0xF8,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x0,0xF8,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x0,0xF8,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x41,0x8,0x0,0xF8,0x41,0x8,0x0,0xF8
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x41,0x8,0x41,0x8,0x0,0xF8,0x41,0x8
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0xE0,0x7,0x41,0x8,0xE0,0x7,0x41,0x8
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0xE0,0x7
	.DB  0x41,0x8,0xE0,0x7,0x41,0x8,0xE0,0x7
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0xE0,0x7
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0xE0,0x7
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0xE0,0x7,0x41,0x8,0xE0,0x7,0x41,0x8
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x41,0x8,0xE0,0x7,0x41,0x8,0x41,0x8
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x41,0x8,0x1F,0x0,0x41,0x8,0x1F,0x0
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x1F,0x0,0x41,0x8,0x1F,0x0,0x41,0x8
	.DB  0x1F,0x0,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x1F,0x0,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x1F,0x0,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x41,0x8,0x1F,0x0,0x41,0x8,0x1F,0x0
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x41,0x8,0x41,0x8,0x1F,0x0,0x41,0x8
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8
	.DB  0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 30.08.2015
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 2,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;#define L PORTD
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <sleep.h>
;#define ALL 2
;flash unsigned char pp[] = {
;0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,
;0x41,0x8,0x0,0xf8,0x41,0x8,0x0,0xf8,0x41,0x8,0x41,0x8,0x41,0x8,0x41,
;0x8,0x0,0xf8,0x41,0x8,0x0,0xf8,0x41,0x8,0x0,0xf8,0x41,0x8,0x41,0x8,
;0x41,0x8,0x0,0xf8,0x41,0x8,0x41,0x8,0x41,0x8,0x0,0xf8,0x41,0x8,0x41,
;0x8,0x41,0x8,0x41,0x8,0x0,0xf8,0x41,0x8,0x0,0xf8,0x41,0x8,0x41,0x8,
;0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x0,0xf8,0x41,0x8,0x41,0x8,0x41,
;0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0xe0,0x7,
;0x41,0x8,0xe0,0x7,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0xe0,0x7,0x41,
;0x8,0xe0,0x7,0x41,0x8,0xe0,0x7,0x41,0x8,0x41,0x8,0x41,0x8,0xe0,0x7,
;0x41,0x8,0x41,0x8,0x41,0x8,0xe0,0x7,0x41,0x8,0x41,0x8,0x41,0x8,0x41,
;0x8,0xe0,0x7,0x41,0x8,0xe0,0x7,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,
;0x41,0x8,0x41,0x8,0xe0,0x7,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x41,
;0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x1f,0x0,
;0x41,0x8,0x1f,0x0,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x1f,0x0,0x41,
;0x8,0x1f,0x0,0x41,0x8,0x1f,0x0,0x41,0x8,0x41,0x8,0x41,0x8,0x1f,0x0,
;0x41,0x8,0x41,0x8,0x41,0x8,0x1f,0x0,0x41,0x8,0x41,0x8,0x41,0x8,0x41,
;0x8,0x1f,0x0,0x41,0x8,0x1f,0x0,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,
;0x41,0x8,0x41,0x8,0x1f,0x0,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x41,
;0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,0x41,0x8,
;0x41,0x8
;};
;  volatile unsigned char count=0,step=0,sr=0;
;  unsigned char rgb[24][3][8] = {0};
;  eeprom unsigned char type;
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0038 {

	.CSEG
_timer1_ovf_isr:
; 0000 0039 // Place your code here
; 0000 003A 
; 0000 003B 
; 0000 003C }
	RETI
;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0040 {
_timer2_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0041 
; 0000 0042     #asm("cli")
	cli
; 0000 0043 
; 0000 0044         if(count>8) count=0;
	LDS  R26,_count
	CPI  R26,LOW(0x9)
	BRSH PC+2
	RJMP _0x3
	LDI  R30,LOW(0)
	STS  _count,R30
; 0000 0045     OCR2=rgb[step][0][count];      //RED
_0x3:
	LDS  R30,_step
	LDI  R26,LOW(24)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_rgb)
	SBCI R31,HIGH(-_rgb)
	MOVW R26,R30
	LDS  R30,_count
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x23,R30
; 0000 0046     OCR1A=rgb[step][1][count];     // GREEN
	LDS  R30,_step
	LDI  R26,LOW(24)
	MUL  R30,R26
	MOVW R30,R0
	__ADDW1MN _rgb,8
	MOVW R26,R30
	LDS  R30,_count
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDI  R31,0
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0047     OCR1B=rgb[step][2][count];     //BLUE
	LDS  R30,_step
	LDI  R26,LOW(24)
	MUL  R30,R26
	MOVW R30,R0
	__ADDW1MN _rgb,16
	MOVW R26,R30
	LDS  R30,_count
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDI  R31,0
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 0048        #asm("sei")
	sei
; 0000 0049               L = (1<<count++);
	LDS  R30,_count
	SUBI R30,-LOW(1)
	STS  _count,R30
	SUBI R30,LOW(1)
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OUT  0x12,R30
; 0000 004A }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 004D {
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 004E  TCNT0=100;
	LDI  R30,LOW(100)
	OUT  0x32,R30
; 0000 004F step=(step>=sr)?0:(step+1);
	LDS  R30,_sr
	LDS  R26,_step
	CP   R26,R30
	BRSH PC+2
	RJMP _0x4
	LDI  R30,LOW(0)
	RJMP _0x5
_0x4:
	LDS  R30,_step
	LDI  R31,0
	ADIW R30,1
_0x5:
_0x6:
	STS  _step,R30
; 0000 0050 
; 0000 0051 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;// Declare your global variables here
;void sleep()
; 0000 0055 {
_sleep:
; 0000 0056 //unsigned char x;
; 0000 0057 //x = (MCUCR & ~(1 << BODSE)) | (1 << BODS); // подготовка бит
; 0000 0058 //MCUCR = x | (1 << BODSE); // процедура отключения BOD
; 0000 0059 //MCUCR = x;
; 0000 005A MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 005B #asm("cli");
	cli
; 0000 005C  sleep_enable();
	RCALL _sleep_enable
; 0000 005D  powerdown();
	RCALL _powerdown
; 0000 005E }
	RET
;void conv(flash unsigned char *pic,unsigned int so )
; 0000 0060 {
_conv:
; 0000 0061 unsigned int ii=0,c;
; 0000 0062 unsigned char i,j;
; 0000 0063 register unsigned char r=0,g=0,b=0;
; 0000 0064 sr=so/16;
	SBIW R28,3
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	RCALL __SAVELOCR6
;	*pic -> Y+11
;	so -> Y+9
;	ii -> R16,R17
;	c -> R18,R19
;	i -> R21
;	j -> R20
;	r -> Y+8
;	g -> Y+7
;	b -> Y+6
	__GETWRN 16,17,0
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	RCALL __LSRW4
	STS  _sr,R30
; 0000 0065 
; 0000 0066 for (j=0;j<=sr; j++)
	LDI  R20,LOW(0)
_0x8:
	LDS  R30,_sr
	CP   R30,R20
	BRSH PC+2
	RJMP _0x9
; 0000 0067 {
; 0000 0068 for(i=0; i<8 ; i++)
	LDI  R21,LOW(0)
_0xB:
	CPI  R21,8
	BRLO PC+2
	RJMP _0xC
; 0000 0069 {   if(ii>=so) ii=0;
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R16,R30
	CPC  R17,R31
	BRSH PC+2
	RJMP _0xD
	__GETWRN 16,17,0
; 0000 006A  c=pic[ii++]|(pic[ii++]<<8);
_0xD:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R0,Z
	CLR  R1
	MOVW R30,R16
	__ADDWRN 16,17,1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOV  R31,R30
	LDI  R30,0
	OR   R30,R0
	OR   R31,R1
	MOVW R18,R30
; 0000 006B 
; 0000 006C  r=(0xF800 & c)>>11;
	MOVW R30,R18
	ANDI R30,LOW(0xF800)
	ANDI R31,HIGH(0xF800)
	RCALL __LSRW3
	MOV  R30,R31
	LDI  R31,0
	STD  Y+8,R30
; 0000 006D  g=(0x07E0 & c) >>5;
	MOVW R30,R18
	ANDI R30,LOW(0x7E0)
	ANDI R31,HIGH(0x7E0)
	LSR  R31
	ROR  R30
	RCALL __LSRW4
	STD  Y+7,R30
; 0000 006E  b=(0x001F & c);
	MOV  R30,R18
	ANDI R30,LOW(0x1F)
	STD  Y+6,R30
; 0000 006F 
; 0000 0070  rgb[j][0][i] =(float)r/31 * 120;
	LDI  R26,LOW(24)
	MUL  R20,R26
	MOVW R30,R0
	SUBI R30,LOW(-_rgb)
	SBCI R31,HIGH(-_rgb)
	MOVW R26,R30
	MOV  R30,R21
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDD  R30,Y+8
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41F80000
	RCALL __DIVF21
	__GETD2N 0x42F00000
	RCALL __MULF12
	POP  R26
	POP  R27
	RCALL __CFD1U
	ST   X,R30
; 0000 0071  rgb[j][1][i] =(float)g/63  * 120;
	LDI  R26,LOW(24)
	MUL  R20,R26
	MOVW R30,R0
	__ADDW1MN _rgb,8
	MOVW R26,R30
	MOV  R30,R21
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDD  R30,Y+7
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x427C0000
	RCALL __DIVF21
	__GETD2N 0x42F00000
	RCALL __MULF12
	POP  R26
	POP  R27
	RCALL __CFD1U
	ST   X,R30
; 0000 0072  rgb[j][2][i] = (float)b/31 * 120;
	LDI  R26,LOW(24)
	MUL  R20,R26
	MOVW R30,R0
	__ADDW1MN _rgb,16
	MOVW R26,R30
	MOV  R30,R21
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDD  R30,Y+6
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41F80000
	RCALL __DIVF21
	__GETD2N 0x42F00000
	RCALL __MULF12
	POP  R26
	POP  R27
	RCALL __CFD1U
	ST   X,R30
; 0000 0073 
; 0000 0074 }
_0xA:
	SUBI R21,-1
	RJMP _0xB
_0xC:
; 0000 0075 }
_0x7:
	SUBI R20,-1
	RJMP _0x8
_0x9:
; 0000 0076 }
	RCALL __LOADLOCR6
	ADIW R28,13
	RET
;void main(void)
; 0000 0078 {
_main:
; 0000 0079 unsigned char i=0;
; 0000 007A     #asm("cli")
;	i -> R17
	LDI  R17,0
	cli
; 0000 007B // Declare your local variables here
; 0000 007C 
; 0000 007D // Input/Output Ports initialization
; 0000 007E // Port B initialization
; 0000 007F // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=In
; 0000 0080 // State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=T
; 0000 0081 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0082 DDRB=0x0E;
	LDI  R30,LOW(14)
	OUT  0x17,R30
; 0000 0083 
; 0000 0084 // Port C initialization
; 0000 0085 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0086 // State6=P State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0087 PORTC=0x40;
	LDI  R30,LOW(64)
	OUT  0x15,R30
; 0000 0088 DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0089 
; 0000 008A // Port D initialization
; 0000 008B // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 008C // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 008D PORTD=0x00;
	OUT  0x12,R30
; 0000 008E DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 008F 
; 0000 0090 
; 0000 0091 
; 0000 0092 
; 0000 0093 // Timer/Counter 0 initialization
; 0000 0094 // Clock source: System Clock
; 0000 0095 // Clock value: 250,000 kHz
; 0000 0096 TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 0097 TCNT0=100;
	LDI  R30,LOW(100)
	OUT  0x32,R30
; 0000 0098 
; 0000 0099 // Timer/Counter 1 initialization
; 0000 009A // Clock source: System Clock
; 0000 009B // Clock value: 2000,000 kHz
; 0000 009C // Mode: Fast PWM top=0x00FF
; 0000 009D // OC1A output: Non-Inv.
; 0000 009E // OC1B output: Non-Inv.
; 0000 009F // Noise Canceler: Off
; 0000 00A0 // Input Capture on Falling Edge
; 0000 00A1 // Timer1 Overflow Interrupt: Off
; 0000 00A2 // Input Capture Interrupt: Off
; 0000 00A3 // Compare A Match Interrupt: Off
; 0000 00A4 // Compare B Match Interrupt: Off
; 0000 00A5 TCCR1A=0xF1;
	LDI  R30,LOW(241)
	OUT  0x2F,R30
; 0000 00A6 TCCR1B=0x09;
	LDI  R30,LOW(9)
	OUT  0x2E,R30
; 0000 00A7 //TCCR1B=0x01;
; 0000 00A8 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00A9 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00AA ICR1H=0x00;
	OUT  0x27,R30
; 0000 00AB ICR1L=0x00;
	OUT  0x26,R30
; 0000 00AC OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00AD OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00AE OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00AF OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00B0 
; 0000 00B1 // Timer/Counter 2 initialization
; 0000 00B2 // Clock source: System Clock
; 0000 00B3 // Clock value: 2000,000 kHz
; 0000 00B4 // Mode: Fast PWM top=0xFF
; 0000 00B5 // OC2 output: Non-Inverted PWM
; 0000 00B6 ASSR=0x00;
	OUT  0x22,R30
; 0000 00B7 TCCR2=0x79;
	LDI  R30,LOW(121)
	OUT  0x25,R30
; 0000 00B8 // TCCR2=0x71;
; 0000 00B9 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 00BA OCR2=0x00;
	OUT  0x23,R30
; 0000 00BB 
; 0000 00BC // External Interrupt(s) initialization
; 0000 00BD // INT0: Off
; 0000 00BE // INT1: Off
; 0000 00BF MCUCR=0x00;
	OUT  0x35,R30
; 0000 00C0 
; 0000 00C1 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00C2 TIMSK=0x45;
	LDI  R30,LOW(69)
	OUT  0x39,R30
; 0000 00C3 
; 0000 00C4 // USART initialization
; 0000 00C5 // USART disabled
; 0000 00C6 UCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 00C7 
; 0000 00C8 // Analog Comparator initialization
; 0000 00C9 // Analog Comparator: Off
; 0000 00CA // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00CB ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00CC SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00CD 
; 0000 00CE // ADC initialization
; 0000 00CF // ADC disabled
; 0000 00D0 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 00D1 
; 0000 00D2 // SPI initialization
; 0000 00D3 // SPI disabled
; 0000 00D4 SPCR=0x00;
	OUT  0xD,R30
; 0000 00D5 
; 0000 00D6 // TWI initialization
; 0000 00D7 // TWI disabled
; 0000 00D8 TWCR=0x00;
	OUT  0x36,R30
; 0000 00D9 
; 0000 00DA // Global enable interrupts
; 0000 00DB 
; 0000 00DC if ((MCUCSR & 1)) { MCUCSR=0;
	IN   R30,0x34
	SBRS R30,0
	RJMP _0xE
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 00DD 
; 0000 00DE    OCR2=100;
	LDI  R30,LOW(100)
	OUT  0x23,R30
; 0000 00DF  for (i=0; i<8; i++) {  L   =1<<i; delay_ms(100);} OCR2=OCR1A=OCR1B=0;
	LDI  R17,LOW(0)
_0x10:
	CPI  R17,8
	BRLO PC+2
	RJMP _0x11
	MOV  R30,R17
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OUT  0x12,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
_0xF:
	SUBI R17,-1
	RJMP _0x10
_0x11:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x28+1,R31
	OUT  0x28,R30
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	OUT  0x23,R30
; 0000 00E0 
; 0000 00E1   OCR1A=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00E2  for (i=0; i<8; i++) {  L   =1<<i;  delay_ms(100); } OCR2=OCR1A=OCR1B=0;
	LDI  R17,LOW(0)
_0x13:
	CPI  R17,8
	BRLO PC+2
	RJMP _0x14
	MOV  R30,R17
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OUT  0x12,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
_0x12:
	SUBI R17,-1
	RJMP _0x13
_0x14:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x28+1,R31
	OUT  0x28,R30
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	OUT  0x23,R30
; 0000 00E3 
; 0000 00E4   OCR1B=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00E5  for (i=0; i<8; i++) {  L   =1<<i;  delay_ms(100); }   OCR2=OCR1A=OCR1B=0;
	LDI  R17,LOW(0)
_0x16:
	CPI  R17,8
	BRLO PC+2
	RJMP _0x17
	MOV  R30,R17
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OUT  0x12,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
_0x15:
	SUBI R17,-1
	RJMP _0x16
_0x17:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x28+1,R31
	OUT  0x28,R30
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	OUT  0x23,R30
; 0000 00E6   L=0;
	OUT  0x12,R30
; 0000 00E7   type=0;
	LDI  R26,LOW(_type)
	LDI  R27,HIGH(_type)
	RCALL __EEPROMWRB
; 0000 00E8 sleep();}
	RCALL _sleep
; 0000 00E9 
; 0000 00EA 
; 0000 00EB if ((MCUCSR & 2))
_0xE:
	IN   R30,0x34
	SBRS R30,1
	RJMP _0x18
; 0000 00EC {
; 0000 00ED type=(type>ALL)?1:(type+1);
	LDI  R26,LOW(_type)
	LDI  R27,HIGH(_type)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x3)
	BRSH PC+2
	RJMP _0x19
	LDI  R30,LOW(1)
	RJMP _0x1A
_0x19:
	LDI  R26,LOW(_type)
	LDI  R27,HIGH(_type)
	RCALL __EEPROMRDB
	LDI  R31,0
	ADIW R30,1
_0x1A:
_0x1B:
	LDI  R26,LOW(_type)
	LDI  R27,HIGH(_type)
	RCALL __EEPROMWRB
; 0000 00EE MCUCSR=0; if(type>=ALL) {  type=0; sleep(); }
	LDI  R30,LOW(0)
	OUT  0x34,R30
	LDI  R26,LOW(_type)
	LDI  R27,HIGH(_type)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRSH PC+2
	RJMP _0x1C
	LDI  R26,LOW(_type)
	LDI  R27,HIGH(_type)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
	RCALL _sleep
; 0000 00EF }
_0x1C:
; 0000 00F0 
; 0000 00F1 
; 0000 00F2 
; 0000 00F3   conv(pp,sizeof(pp));
_0x18:
	LDI  R30,LOW(_pp*2)
	LDI  R31,HIGH(_pp*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(288)
	LDI  R31,HIGH(288)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _conv
; 0000 00F4 
; 0000 00F5  #asm("sei")
	sei
; 0000 00F6   while(1){     }
_0x1D:
	RJMP _0x1D
_0x1F:
; 0000 00F7 
; 0000 00F8 
; 0000 00F9 }
_0x20:
	RJMP _0x20
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_sleep_enable:
   in   r30,power_ctrl_reg
   sbr  r30,__se_bit
   out  power_ctrl_reg,r30
	RET
_powerdown:
   in   r30,power_ctrl_reg
   cbr  r30,__sm_mask
   sbr  r30,__sm_powerdown
   out  power_ctrl_reg,r30
   in   r30,sreg
   sei
   sleep
   out  sreg,r30
	RET

	.DSEG
_count:
	.BYTE 0x1
_step:
	.BYTE 0x1
_sr:
	.BYTE 0x1
_rgb:
	.BYTE 0x240

	.ESEG
_type:
	.BYTE 0x1

	.CSEG

	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x1F4
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
