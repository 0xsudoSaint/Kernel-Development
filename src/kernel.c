#include "kernel.h"
#include <stdint.h>
#include <stddef.h>

size_t row_pos=0;
size_t col_pos=0;

uint16_t* VIDEO_MEM_ADD=(uint16_t*)(0xB8000);//each index covers 2 byts, so 1 index increase means we jump to second pixel of screen

uint16_t make_terminal_letter(char character,char color)
{
    //shifted color to higher 8 bits and OR with 8 bits of character, 
    //so return word(16 bit) has Higher Bits=Attributes , Lower Bits=ASCI
    
    return((color<<8) | character); 
}

void put_char_on_terminal(int r_pos,int c_pos,char character,char color)
{
    VIDEO_MEM_ADD[r_pos*VIDEO_MEM_WIDTH+c_pos]=make_terminal_letter(character,color);
}

void print_char_terminal(char character,char color)
{  
    if(character=='\n')
    {
        row_pos+=1;
        col_pos=0;
        return;
    }
    put_char_on_terminal(row_pos,col_pos,character,color);
    col_pos+=1;
    if(col_pos>=VIDEO_MEM_WIDTH)
    {
        row_pos+=1;
        col_pos=0;
    }
}

void terminal_init()
{
    for(int x=0;x<VIDEO_MEM_HEIGHT;x++)
    {
        for(int y=0;y<VIDEO_MEM_WIDTH;y++)
        {
            put_char_on_terminal(x,y,' ',15); //vider mem is linear, so for 2nd row, we have to reach 81st index.
        }
    }
}

size_t strlen(const char* str)
{
    size_t len=0;
    while (str[len])
    {
        len+=1;
    }
    return len;
}

void Print(const char* string)
{
    size_t str_len=strlen(string);
    for(int i=0;i<str_len;i++)
    {
        print_char_terminal(string[i],12);
    }
}

void kernel_main()
{
    terminal_init();
    Print("Well Well\nWell");
}