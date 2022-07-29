/************************************ 
     This program is created by
        Mehrbod Molla Kazemi
  Copyright(C) 2022 - 7 Mordad 1401
*************************************/
// File:        ks0108_mmk.h
// Creator:     Mehrbod M.K.
// Date:        7 Mordad 1401

// Primary includes.
#include "ks0108_mmk.h"

// Send GLCD Enable Pulse Signal.
void        __GLCD_SEND_PULSE(void)
{
    _PORT_LCD_EN = 1;
    delay_us(5);
    _PORT_LCD_EN = 0;
    delay_us(5);
}

// GLCD Display On/Off.
void        GLCD_Display(bool isOn)
{
    if(isOn)
    {
        _PORT_LCD_CS1 = 0;
        _PORT_LCD_CS2 = 0;
        _PORT_LCD_DI_RS = 0;
        _PORT_LCD_RW = 0;
        
        _PORT_LCD_DATA_WRITE = 0x3F;
        
        __GLCD_SEND_PULSE();    
    }
    else
    {
        _PORT_LCD_CS1 = 1;
        _PORT_LCD_CS2 = 1;
        _PORT_LCD_DI_RS = 0;
        _PORT_LCD_RW = 0;
        
        _PORT_LCD_DATA_WRITE = 0x3E;
        
        __GLCD_SEND_PULSE();
    }
}

// GLCD Set Start Line.
void        GLCD_SetStartLine(uint16_t lineNum)
{
    _PORT_LCD_DI_RS = 0;
    _PORT_LCD_RW = 0;
    _PORT_LCD_CS1 = 0;
    _PORT_LCD_CS2 = 0;
    
    _PORT_LCD_DATA_WRITE = 0xC0 | lineNum;
    
    __GLCD_SEND_PULSE();
}

// GLCD Set Column.
void        GLCD_SetColumn(unsigned int x)
{
    uint16_t colData;
    
    _PORT_LCD_DI_RS = 0;
    _PORT_LCD_RW = 0;
    
    if(x < 64)
    {
        _PORT_LCD_CS1 = 1;
        _PORT_LCD_CS2 = 0;
        colData = x;
    }               
    else
    {
       _PORT_LCD_CS1 = 0;
       _PORT_LCD_CS2 = 1;
       colData = x - 64; 
    }
    
    colData = (colData | 0x40) & 0x7F;
    
    _PORT_LCD_DATA_WRITE = colData;
    
    __GLCD_SEND_PULSE();
}

// GLCD Set Row.
void        GLCD_SetRow(unsigned int y)
{
    uint16_t rowData;
    
    _PORT_LCD_DI_RS = 0;
    _PORT_LCD_RW = 0;
               
    rowData = (y | 0xB8 ) & 0xBF;
    
    _PORT_LCD_DATA_WRITE =  rowData;
    
    __GLCD_SEND_PULSE();
}

// GLCD Go To (X, Y).
void        GLCD_GoToXY(unsigned int x, unsigned int y)
{
    GLCD_SetColumn(x);
    GLCD_SetRow(y);
}

// GLCD Write.
void        GLCD_Write(uint16_t data)
{
    _PORT_LCD_DI_RS = 1;
    _PORT_LCD_RW = 0;
    
    _PORT_LCD_DATA_WRITE = data;
    
    delay_us(1);
    __GLCD_SEND_PULSE();
}

// GLCD Read.
uint16_t    GLCD_Read(uint16_t colNum)
{
    uint16_t readData = 0;
    _DDR_LCD_DATA = 0x00;
    
    _PORT_LCD_DI_RS = 1;
    _PORT_LCD_RW = 1;
    
    _PORT_LCD_CS1 = (colNum <= 63);
    _PORT_LCD_CS2 = !_PORT_LCD_CS1;
    delay_us(1);
    
    _PORT_LCD_EN = 1;
    delay_us(1);
    
    // DUMMY READ.
    _PORT_LCD_EN = 0;
    delay_us(5);
    _PORT_LCD_EN = 1;
    delay_us(1);
    
    // Read input data now.
    readData = _PIN_LCD_DATA_READ;
    
    _PORT_LCD_EN = 0;
    delay_us(1);
    
    _DDR_LCD_DATA = 0xFF;
    
    return readData;        
}

// GLCD Clear Line.
void        GLCD_ClearLine(uint16_t lineNum)
{
    int i;
    
    GLCD_GoToXY(0, lineNum);
    //GLCD_GoToXY(0, 64); // TODO
    
    //_PORT_LCD_CS1 = 1;
    //_PORT_LCD_CS2 = 0;
    
    for(i = 0; i < 128; i++)
        GLCD_Write(0);
     
    GLCD_GoToXY(64, lineNum);
    for(i = 0; i < 128; i++)
        GLCD_Write(0);
}

// GLCD Clear Screen.
void        GLCD_Clear(void)
{
    int m;
    for(m = 0; m < 8; m++)
        GLCD_ClearLine(m);
}

// GLCD Draw Pixel.
void        GLCD_DrawPixel(uint16_t x, uint16_t y, uint16_t col)
{
    uint16_t colData;
    GLCD_GoToXY(x, (y / 8));
    
    switch(col)
    {
        case 0:
            colData = ~(1<<(y%8)) & GLCD_Read(x);
            break;
        
        case 1:
            colData = (1<<(y%8)) | GLCD_Read(x);
            break;
    }
    
    GLCD_GoToXY(x, (y / 8));
    GLCD_Write(colData);
}

// GLCD Initialization.
void        GLCD_Init(void)
{
    _DDR_LCD_DATA = 0xFF;
    _PORT_LCD_CS1 = 1;
    _PORT_LCD_CS2 = 1;  
    
    _PORT_LCD_RESET = 1;
    
    GLCD_Display(true);
    GLCD_Clear();
    GLCD_SetStartLine(0);
}
