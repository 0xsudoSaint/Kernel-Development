ORG 0
BITS 16
_start:
  jmp short main_start 
  nop
times 33 db 0     ;bios paramtert block (BPB)

main_start:
  jmp 0x7c0:set_segment_registers

set_segment_registers: ;this cannot be done using call, since stack pointer and stack segment is yet to be set
  cli               ;disabling interupts
  mov ax,0x7c0      
  mov es,ax
  mov ds,ax
  mov bx,0x00 
  mov ss,bx
  mov sp,ax
  sti               ;enabling interupts

clr_GP_regs:
  xor ax,ax
  xor bx,bx

print_main:
  mov si,text         ;address to text
print_loop:
  mov byte al,[si]    ;byte of text
  cmp al,0 
  je exit
  call print_char
  add si,1
  jmp print_loop

print_char:
  mov ah,0eh
  int 10h
  ret

exit:
  jmp $


text: db 'Hello From kernel Developer'
times 510 - ($ - $$) db 0 ; commiting memory, boot signature should be at 511 and 12th bytes-> [0000000000..... {0x55AA}]
signature: dw 0xAA55 ;0x55AA -> little endian format
