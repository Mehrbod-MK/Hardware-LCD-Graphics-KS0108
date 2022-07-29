
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32A
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _wasBusy=R5
	.DEF _wasLcdOn=R4
	.DEF _wasReset=R7
	.DEF _rx_wr_index=R6
	.DEF _rx_rd_index=R9
	.DEF _rx_counter=R8

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x1,0x1,0x0,0x1
	.DB  0x0,0x0


__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

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

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : KS0108 Driver Program
;Version : 0.0.0.9
;Date    : 29/07/2022
;Author  : Mehrbod Molla Kazemi
;Company : MelaTronX®
;Comments:
;
;
;Chip type               : ATmega32A
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32a.h>
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
;
;#include <delay.h>
;
;// KS0108 MMK Library.
;#include "ks0108_mmk.h"
;
;// Declare your global variables here
;bool wasBusy = true;
;bool wasLcdOn = true;
;bool wasReset = true;
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 003F {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0040 char status,data;
; 0000 0041 status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0042 data=UDR;
	IN   R16,12
; 0000 0043 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0044    {
; 0000 0045    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0046 #if RX_BUFFER_SIZE == 256
; 0000 0047    // special case for receiver buffer size=256
; 0000 0048    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 0049 #else
; 0000 004A    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x4
	CLR  R6
; 0000 004B    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R8
	LDI  R30,LOW(8)
	CP   R30,R8
	BRNE _0x5
; 0000 004C       {
; 0000 004D       rx_counter=0;
	CLR  R8
; 0000 004E       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 004F       }
; 0000 0050 #endif
; 0000 0051    }
_0x5:
; 0000 0052 }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0059 {
; 0000 005A char data;
; 0000 005B while (rx_counter==0);
;	data -> R17
; 0000 005C data=rx_buffer[rx_rd_index++];
; 0000 005D #if RX_BUFFER_SIZE != 256
; 0000 005E if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 005F #endif
; 0000 0060 #asm("cli")
; 0000 0061 --rx_counter;
; 0000 0062 #asm("sei")
; 0000 0063 return data;
; 0000 0064 }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;void main(void)
; 0000 006C {
_main:
; .FSTART _main
; 0000 006D // Declare your local variables here
; 0000 006E 
; 0000 006F // Input/Output Ports initialization
; 0000 0070 // Port A initialization
; 0000 0071 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0072 DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0073 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0074 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0075 
; 0000 0076 // Port B initialization
; 0000 0077 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=Out
; 0000 0078 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(1)
	OUT  0x17,R30
; 0000 0079 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=0
; 0000 007A PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 007B 
; 0000 007C // Port C initialization
; 0000 007D // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 007E DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(31)
	OUT  0x14,R30
; 0000 007F // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0080 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0081 
; 0000 0082 // Port D initialization
; 0000 0083 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0084 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0085 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0086 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0087 
; 0000 0088 // Timer/Counter 0 initialization
; 0000 0089 // Clock source: System Clock
; 0000 008A // Clock value: Timer 0 Stopped
; 0000 008B // Mode: Normal top=0xFF
; 0000 008C // OC0 output: Disconnected
; 0000 008D TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 008E TCNT0=0x00;
	OUT  0x32,R30
; 0000 008F OCR0=0x00;
	OUT  0x3C,R30
; 0000 0090 
; 0000 0091 // Timer/Counter 1 initialization
; 0000 0092 // Clock source: System Clock
; 0000 0093 // Clock value: Timer1 Stopped
; 0000 0094 // Mode: Normal top=0xFFFF
; 0000 0095 // OC1A output: Disconnected
; 0000 0096 // OC1B output: Disconnected
; 0000 0097 // Noise Canceler: Off
; 0000 0098 // Input Capture on Falling Edge
; 0000 0099 // Timer1 Overflow Interrupt: Off
; 0000 009A // Input Capture Interrupt: Off
; 0000 009B // Compare A Match Interrupt: Off
; 0000 009C // Compare B Match Interrupt: Off
; 0000 009D TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 009E TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 009F TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00A0 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00A1 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00A2 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00A3 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00A4 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00A5 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00A6 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00A7 
; 0000 00A8 // Timer/Counter 2 initialization
; 0000 00A9 // Clock source: System Clock
; 0000 00AA // Clock value: Timer2 Stopped
; 0000 00AB // Mode: Normal top=0xFF
; 0000 00AC // OC2 output: Disconnected
; 0000 00AD ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00AE TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00AF TCNT2=0x00;
	OUT  0x24,R30
; 0000 00B0 OCR2=0x00;
	OUT  0x23,R30
; 0000 00B1 
; 0000 00B2 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00B3 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 00B4 
; 0000 00B5 // External Interrupt(s) initialization
; 0000 00B6 // INT0: Off
; 0000 00B7 // INT1: Off
; 0000 00B8 // INT2: Off
; 0000 00B9 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 00BA MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 00BB 
; 0000 00BC // USART initialization
; 0000 00BD // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00BE // USART Receiver: On
; 0000 00BF // USART Transmitter: On
; 0000 00C0 // USART Mode: Asynchronous
; 0000 00C1 // USART Baud Rate: 9600
; 0000 00C2 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 00C3 UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 00C4 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00C5 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00C6 UBRRL=0x67;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 00C7 
; 0000 00C8 // Analog Comparator initialization
; 0000 00C9 // Analog Comparator: Off
; 0000 00CA // The Analog Comparator's positive input is
; 0000 00CB // connected to the AIN0 pin
; 0000 00CC // The Analog Comparator's negative input is
; 0000 00CD // connected to the AIN1 pin
; 0000 00CE ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00CF SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00D0 
; 0000 00D1 // ADC initialization
; 0000 00D2 // ADC disabled
; 0000 00D3 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00D4 
; 0000 00D5 // SPI initialization
; 0000 00D6 // SPI disabled
; 0000 00D7 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00D8 
; 0000 00D9 // TWI initialization
; 0000 00DA // TWI disabled
; 0000 00DB TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00DC 
; 0000 00DD // Global enable interrupts
; 0000 00DE #asm("sei")
	sei
; 0000 00DF 
; 0000 00E0 GLCD_Init();
	RCALL _GLCD_Init
; 0000 00E1 
; 0000 00E2 while (1)
_0xA:
; 0000 00E3       {
; 0000 00E4         uint16_t u = 0, v = 0;
; 0000 00E5 
; 0000 00E6         GLCD_GoToXY(0, 0);
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
;	u -> Y+2
;	v -> Y+0
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _GLCD_GoToXY
; 0000 00E7         GLCD_Write(0xC0);
	LDI  R26,LOW(192)
	LDI  R27,0
	RCALL _GLCD_Write
; 0000 00E8 
; 0000 00E9         delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 00EA         GLCD_Clear();
	RCALL _GLCD_Clear
; 0000 00EB         delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 00EC       }
	ADIW R28,4
	RJMP _0xA
; 0000 00ED }
_0xD:
	RJMP _0xD
; .FEND
;/************************************
;     This program is created by
;        Mehrbod Molla Kazemi
;  Copyright(C) 2022 - 7 Mordad 1401
;*************************************/
;// File:        ks0108_mmk.h
;// Creator:     Mehrbod M.K.
;// Date:        7 Mordad 1401
;
;// Primary includes.
;#include "ks0108_mmk.h"
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
;
;// Send GLCD Enable Pulse Signal.
;void        __GLCD_SEND_PULSE(void)
; 0001 000F {

	.CSEG
___GLCD_SEND_PULSE:
; .FSTART ___GLCD_SEND_PULSE
; 0001 0010     _PORT_LCD_EN = 1;
	SBI  0x15,0
; 0001 0011     delay_us(5);
	__DELAY_USB 27
; 0001 0012     _PORT_LCD_EN = 0;
	CBI  0x15,0
; 0001 0013     delay_us(5);
	__DELAY_USB 27
; 0001 0014 }
	RET
; .FEND
;
;// GLCD Display On/Off.
;void        GLCD_Display(bool isOn)
; 0001 0018 {
_GLCD_Display:
; .FSTART _GLCD_Display
; 0001 0019     if(isOn)
	ST   -Y,R26
;	isOn -> Y+0
	LD   R30,Y
	CPI  R30,0
	BREQ _0x20007
; 0001 001A     {
; 0001 001B         _PORT_LCD_CS1 = 0;
	CBI  0x15,3
; 0001 001C         _PORT_LCD_CS2 = 0;
	CBI  0x15,4
; 0001 001D         _PORT_LCD_DI_RS = 0;
	CBI  0x15,2
; 0001 001E         _PORT_LCD_RW = 0;
	CBI  0x15,1
; 0001 001F 
; 0001 0020         _PORT_LCD_DATA_WRITE = 0x3F;
	LDI  R30,LOW(63)
	RJMP _0x2005B
; 0001 0021 
; 0001 0022         __GLCD_SEND_PULSE();
; 0001 0023     }
; 0001 0024     else
_0x20007:
; 0001 0025     {
; 0001 0026         _PORT_LCD_CS1 = 1;
	SBI  0x15,3
; 0001 0027         _PORT_LCD_CS2 = 1;
	SBI  0x15,4
; 0001 0028         _PORT_LCD_DI_RS = 0;
	CBI  0x15,2
; 0001 0029         _PORT_LCD_RW = 0;
	CBI  0x15,1
; 0001 002A 
; 0001 002B         _PORT_LCD_DATA_WRITE = 0x3E;
	LDI  R30,LOW(62)
_0x2005B:
	OUT  0x1B,R30
; 0001 002C 
; 0001 002D         __GLCD_SEND_PULSE();
	RCALL ___GLCD_SEND_PULSE
; 0001 002E     }
; 0001 002F }
	ADIW R28,1
	RET
; .FEND
;
;// GLCD Set Start Line.
;void        GLCD_SetStartLine(uint16_t lineNum)
; 0001 0033 {
_GLCD_SetStartLine:
; .FSTART _GLCD_SetStartLine
; 0001 0034     _PORT_LCD_DI_RS = 0;
	ST   -Y,R27
	ST   -Y,R26
;	lineNum -> Y+0
	CBI  0x15,2
; 0001 0035     _PORT_LCD_RW = 0;
	CBI  0x15,1
; 0001 0036     _PORT_LCD_CS1 = 0;
	CBI  0x15,3
; 0001 0037     _PORT_LCD_CS2 = 0;
	CBI  0x15,4
; 0001 0038 
; 0001 0039     _PORT_LCD_DATA_WRITE = 0xC0 | lineNum;
	LD   R30,Y
	ORI  R30,LOW(0xC0)
	OUT  0x1B,R30
; 0001 003A 
; 0001 003B     __GLCD_SEND_PULSE();
	RJMP _0x2060003
; 0001 003C }
; .FEND
;
;// GLCD Set Column.
;void        GLCD_SetColumn(unsigned int x)
; 0001 0040 {
_GLCD_SetColumn:
; .FSTART _GLCD_SetColumn
; 0001 0041     uint16_t colData;
; 0001 0042 
; 0001 0043     _PORT_LCD_DI_RS = 0;
	CALL SUBOPT_0x0
;	x -> Y+2
;	colData -> R16,R17
; 0001 0044     _PORT_LCD_RW = 0;
; 0001 0045 
; 0001 0046     if(x < 64)
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRSH _0x20025
; 0001 0047     {
; 0001 0048         _PORT_LCD_CS1 = 1;
	SBI  0x15,3
; 0001 0049         _PORT_LCD_CS2 = 0;
	CBI  0x15,4
; 0001 004A         colData = x;
	__GETWRS 16,17,2
; 0001 004B     }
; 0001 004C     else
	RJMP _0x2002A
_0x20025:
; 0001 004D     {
; 0001 004E        _PORT_LCD_CS1 = 0;
	CBI  0x15,3
; 0001 004F        _PORT_LCD_CS2 = 1;
	SBI  0x15,4
; 0001 0050        colData = x - 64;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(64)
	SBCI R31,HIGH(64)
	MOVW R16,R30
; 0001 0051     }
_0x2002A:
; 0001 0052 
; 0001 0053     colData = (colData | 0x40) & 0x7F;
	MOVW R30,R16
	ORI  R30,0x40
	ANDI R30,LOW(0x7F)
	ANDI R31,HIGH(0x7F)
	MOVW R16,R30
; 0001 0054 
; 0001 0055     _PORT_LCD_DATA_WRITE = colData;
	OUT  0x1B,R16
; 0001 0056 
; 0001 0057     __GLCD_SEND_PULSE();
	RCALL ___GLCD_SEND_PULSE
; 0001 0058 }
	RJMP _0x2060002
; .FEND
;
;// GLCD Set Row.
;void        GLCD_SetRow(unsigned int y)
; 0001 005C {
_GLCD_SetRow:
; .FSTART _GLCD_SetRow
; 0001 005D     uint16_t rowData;
; 0001 005E 
; 0001 005F     _PORT_LCD_DI_RS = 0;
	CALL SUBOPT_0x0
;	y -> Y+2
;	rowData -> R16,R17
; 0001 0060     _PORT_LCD_RW = 0;
; 0001 0061 
; 0001 0062     rowData = (y | 0xB8 ) & 0xBF;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ORI  R30,LOW(0xB8)
	ANDI R30,LOW(0xBF)
	ANDI R31,HIGH(0xBF)
	MOVW R16,R30
; 0001 0063 
; 0001 0064     _PORT_LCD_DATA_WRITE =  rowData;
	OUT  0x1B,R16
; 0001 0065 
; 0001 0066     __GLCD_SEND_PULSE();
	RCALL ___GLCD_SEND_PULSE
; 0001 0067 }
	RJMP _0x2060002
; .FEND
;
;// GLCD Go To (X, Y).
;void        GLCD_GoToXY(unsigned int x, unsigned int y)
; 0001 006B {
_GLCD_GoToXY:
; .FSTART _GLCD_GoToXY
; 0001 006C     GLCD_SetColumn(x);
	ST   -Y,R27
	ST   -Y,R26
;	x -> Y+2
;	y -> Y+0
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL _GLCD_SetColumn
; 0001 006D     GLCD_SetRow(y);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _GLCD_SetRow
; 0001 006E }
	RJMP _0x2060001
; .FEND
;
;// GLCD Write.
;void        GLCD_Write(uint16_t data)
; 0001 0072 {
_GLCD_Write:
; .FSTART _GLCD_Write
; 0001 0073     _PORT_LCD_DI_RS = 1;
	ST   -Y,R27
	ST   -Y,R26
;	data -> Y+0
	SBI  0x15,2
; 0001 0074     _PORT_LCD_RW = 0;
	CBI  0x15,1
; 0001 0075 
; 0001 0076     _PORT_LCD_DATA_WRITE = data;
	LD   R30,Y
	OUT  0x1B,R30
; 0001 0077 
; 0001 0078     delay_us(1);
	__DELAY_USB 5
; 0001 0079     __GLCD_SEND_PULSE();
_0x2060003:
	RCALL ___GLCD_SEND_PULSE
; 0001 007A }
	ADIW R28,2
	RET
; .FEND
;
;// GLCD Read.
;uint16_t    GLCD_Read(uint16_t colNum)
; 0001 007E {
; 0001 007F     uint16_t readData = 0;
; 0001 0080     _DDR_LCD_DATA = 0x00;
;	colNum -> Y+2
;	readData -> R16,R17
; 0001 0081 
; 0001 0082     _PORT_LCD_DI_RS = 1;
; 0001 0083     _PORT_LCD_RW = 1;
; 0001 0084 
; 0001 0085     _PORT_LCD_CS1 = (colNum <= 63);
; 0001 0086     _PORT_LCD_CS2 = !_PORT_LCD_CS1;
; 0001 0087     delay_us(1);
; 0001 0088 
; 0001 0089     _PORT_LCD_EN = 1;
; 0001 008A     delay_us(1);
; 0001 008B 
; 0001 008C     // DUMMY READ.
; 0001 008D     _PORT_LCD_EN = 0;
; 0001 008E     delay_us(5);
; 0001 008F     _PORT_LCD_EN = 1;
; 0001 0090     delay_us(1);
; 0001 0091 
; 0001 0092     // Read input data now.
; 0001 0093     readData = _PIN_LCD_DATA_READ;
; 0001 0094 
; 0001 0095     _PORT_LCD_EN = 0;
; 0001 0096     delay_us(1);
; 0001 0097 
; 0001 0098     _DDR_LCD_DATA = 0xFF;
; 0001 0099 
; 0001 009A     return readData;
; 0001 009B }
;
;// GLCD Clear Line.
;void        GLCD_ClearLine(uint16_t lineNum)
; 0001 009F {
_GLCD_ClearLine:
; .FSTART _GLCD_ClearLine
; 0001 00A0     int i;
; 0001 00A1 
; 0001 00A2     GLCD_GoToXY(0, lineNum);
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	lineNum -> Y+2
;	i -> R16,R17
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x1
; 0001 00A3     //GLCD_GoToXY(0, 64); // TODO
; 0001 00A4 
; 0001 00A5     //_PORT_LCD_CS1 = 1;
; 0001 00A6     //_PORT_LCD_CS2 = 0;
; 0001 00A7 
; 0001 00A8     for(i = 0; i < 128; i++)
_0x20048:
	__CPWRN 16,17,128
	BRGE _0x20049
; 0001 00A9         GLCD_Write(0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _GLCD_Write
	__ADDWRN 16,17,1
	RJMP _0x20048
_0x20049:
; 0001 00AB GLCD_GoToXY(64, lineNum);
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CALL SUBOPT_0x1
; 0001 00AC     for(i = 0; i < 128; i++)
_0x2004B:
	__CPWRN 16,17,128
	BRGE _0x2004C
; 0001 00AD         GLCD_Write(0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _GLCD_Write
	__ADDWRN 16,17,1
	RJMP _0x2004B
_0x2004C:
; 0001 00AE }
_0x2060002:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x2060001:
	ADIW R28,4
	RET
; .FEND
;
;// GLCD Clear Screen.
;void        GLCD_Clear(void)
; 0001 00B2 {
_GLCD_Clear:
; .FSTART _GLCD_Clear
; 0001 00B3     int m;
; 0001 00B4     for(m = 0; m < 8; m++)
	ST   -Y,R17
	ST   -Y,R16
;	m -> R16,R17
	__GETWRN 16,17,0
_0x2004E:
	__CPWRN 16,17,8
	BRGE _0x2004F
; 0001 00B5         GLCD_ClearLine(m);
	MOVW R26,R16
	RCALL _GLCD_ClearLine
	__ADDWRN 16,17,1
	RJMP _0x2004E
_0x2004F:
; 0001 00B6 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;// GLCD Draw Pixel.
;void        GLCD_DrawPixel(uint16_t x, uint16_t y, uint16_t col)
; 0001 00BA {
; 0001 00BB     uint16_t colData;
; 0001 00BC     GLCD_GoToXY(x, (y / 8));
;	x -> Y+6
;	y -> Y+4
;	col -> Y+2
;	colData -> R16,R17
; 0001 00BD 
; 0001 00BE     switch(col)
; 0001 00BF     {
; 0001 00C0         case 0:
; 0001 00C1             colData = ~(1<<(y%8)) & GLCD_Read(x);
; 0001 00C2             break;
; 0001 00C3 
; 0001 00C4         case 1:
; 0001 00C5             colData = (1<<(y%8)) | GLCD_Read(x);
; 0001 00C6             break;
; 0001 00C7     }
; 0001 00C8 
; 0001 00C9     GLCD_GoToXY(x, (y / 8));
; 0001 00CA     GLCD_Write(colData);
; 0001 00CB }
;
;// GLCD Initialization.
;void        GLCD_Init(void)
; 0001 00CF {
_GLCD_Init:
; .FSTART _GLCD_Init
; 0001 00D0     _DDR_LCD_DATA = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0001 00D1     _PORT_LCD_CS1 = 1;
	SBI  0x15,3
; 0001 00D2     _PORT_LCD_CS2 = 1;
	SBI  0x15,4
; 0001 00D3 
; 0001 00D4     _PORT_LCD_RESET = 1;
	SBI  0x18,0
; 0001 00D5 
; 0001 00D6     GLCD_Display(true);
	LDI  R26,LOW(1)
	RCALL _GLCD_Display
; 0001 00D7     GLCD_Clear();
	RCALL _GLCD_Clear
; 0001 00D8     GLCD_SetStartLine(0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _GLCD_SetStartLine
; 0001 00D9 }
	RET
; .FEND
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

	.CSEG

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	CBI  0x15,2
	CBI  0x15,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL _GLCD_GoToXY
	__GETWRN 16,17,0
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
