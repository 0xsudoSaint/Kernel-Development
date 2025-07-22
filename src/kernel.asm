[BITS 32]
global _start
extern  kernel_main 

CodeSeg_Selector EQU 0x08
DataSeg_Selector EQU 0x10

_start:
  mov ax,DataSeg_Selector
  mov ds,ax
  mov es,ax
  mov fs,ax
  mov gs,ax
  mov ss,ax
  mov ebp,0x00200000
  mov esp,ebp

  ;A20 line enable 
  in al,0x92
  or al,2
  out 0x92,al

  call kernel_main
  jmp $