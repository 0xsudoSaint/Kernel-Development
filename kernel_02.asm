ORG 0x7c00
BITS 16
CodeSeg_Selector EQU gdt_code-gdt_struct_start
DataSeg_Selector EQU gdt_data-gdt_struct_start

_start:
    jmp short start
    nop
times 33 db 0


start:
    jmp 0:start2
 
start2:
    cli ; disable interrupts
    mov ax,0x00    ;CS already at 0x7c00 so ax pointes to 0x7c00
    mov ds,ax       
    mov es,ax
    mov ss,ax
    mov sp,0x7c00   ;stack grows from higher to lower
    sti ; enable interrupts
    
init_protected_mode:
  cli
  lgdt[gdt_register]
  mov eax,cr0
  or eax,1 ; set protection bit to 1
  mov cr0,eax
  jmp CodeSeg_Selector:protected_mode_entry


gdt_struct_start:
gdt_descriptor:  
  dd 0 ;struct for CS
  dd 0 ;struct for ES,DS,FS ...

;0x08 offset
gdt_code:
  dw 0xffff ;Limit->4Gib for 32-bit
  dw 0
  db 0
  db 0x9a; 10011010 -> Enabled bits = RW(read write ),E(this is code seg),S(Its Cs seg),P(its a valid seg)
  dw 11001111b ;high and low 4 bit flags
  db 0

;offset->0x08+8bytes = 0x10
gdt_data:
  dw 0xffff
  dw 0
  db 0
  db 0x92;10010010 -> Enable Bits 
  dw 11001111b
  db 0
gdt_end:

gdt_register:
  dw gdt_struct_start - gdt_end -1 ;size of gdt_struct, -1 because gdt_end is +1 byte of last declaration
  dd gdt_struct_start;offset

[BITS 32]
protected_mode_entry:
  mov ax,DataSeg_Selector
  mov ds,ax
  mov fs,ax
  mov gs,ax
  mov ss,ax
  mov ebp,0x0010000
  mov esp,ebp
  jmp $

times 510-($- $$) db 0
dw 0xAA55
