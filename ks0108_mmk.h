/************************************ 
     This program is created by
        Mehrbod Molla Kazemi
  Copyright(C) 2022 - 7 Mordad 1401
*************************************/
// File:        ks0108_mmk.h
// Creator:     Mehrbod M.K.
// Date:        7 Mordad 1401

// One-shot include notation.
#ifndef _KS0108_MMK_H_
#define _KS0108_MMK_H_

///////////////// PORT DEFINITIONS /////////////////
#define     _PORT_LCD_DATA_WRITE        PORTA
#define     _PIN_LCD_DATA_READ          PINA
#define     _DDR_LCD_DATA               DDRA
#define     _PORT_LCD_EN                PORTC.0
#define     _PORT_LCD_RW                PORTC.1
#define     _PORT_LCD_DI_RS             PORTC.2
#define     _PORT_LCD_CS1               PORTC.3
#define     _PORT_LCD_CS2               PORTC.4
#define     _PORT_LCD_RESET             PORTB.0
////////////////////////////////////////////////////

// Necessary includes.
#include <mega32a.h>
#include <delay.h>
#include <stdint.h>
#include <stdbool.h>

// Send GLCD Enable Pulse Signal.
void        __GLCD_SEND_PULSE(void);

// GLCD Display On/Off.
void        GLCD_Display(bool isOn);

// GLCD Set Start Line.
void        GLCD_SetStartLine(uint16_t);
// GLCD Set Column.
void        GLCD_SetColumn(unsigned int);
// GLCD Set Row.
void        GLCD_SetRow(unsigned int);
// GLCD Go To (X, Y).
void        GLCD_GoToXY(unsigned int, unsigned int);

// GLCD Write.
void        GLCD_Write(uint16_t);
// GLCD Read.
uint16_t    GLCD_Read(uint16_t);

// GLCD Initialization.
void        GLCD_Init(void);
// GLCD Clear Line.
void        GLCD_ClearLine(uint16_t);
// GLCD Clear Screen.
void        GLCD_Clear(void);

// GLCD Draw Pixel.
void        GLCD_DrawPixel(uint16_t, uint16_t, uint16_t); 

#endif
