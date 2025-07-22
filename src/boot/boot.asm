ORG 0x7c00
BITS 16
CodeSeg_Selector EQU gdt_code - gdt_struct_start
DataSeg_Selector EQU gdt_data - gdt_struct_start

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
  jmp CodeSeg_Selector:load32


gdt_struct_start:
gdt_null:  
  dd 0x0 ;struct for CS
  dd 0x0 ;struct for ES,DS,FS ...

;0x08 offset
gdt_code:
  dw 0xffff ;Limit->4Gib for 32-bit
  dw 0
  db 0
  db 0x9a; 10011010 -> Enabled bits = RW(read write ),E(this is code seg),S(Its Cs seg),P(its a valid seg)
  db 11001111b ;high and low 4 bit flags
  db 0

;offset->0x08+8bytes = 0x10
gdt_data:
  dw 0xffff
  dw 0
  db 0
  db 0x92;10010010 -> Enable Bits 
  db 11001111b
  db 0
gdt_end:

gdt_register:
  dw gdt_end - gdt_struct_start -1 ;size of gdt_struct, -1 because gdt_end is +1 byte of last declaration
  dd gdt_struct_start;offset

[BITS 32]
load32:
  mov eax,1             ;first sector 
  mov ecx,100           ;number of sectors 
  mov edi,0x0100000     ;mem address
  call ata_lba_read
  jmp CodeSeg_Selector:0x0100000

;-----------------------------------------------------------------------
;A basic disk read driver that we will use to load hard disk sectors    |
;We will talk to different ports and set ports values for this purpose  |
;-----------------------------------------------------------------------

ata_lba_read:
  mov ebx,eax           ;backup
  shr eax,24
  or  al,11100000b       ;set 8 bits for master drive
  mov dx,0x1f6          ; port for selection
  out dx,al

  ;sending number of sector to port
  mov dx,0x1f2
  mov eax,ecx
  out dx,al

  ;sending more bits (0-7)
  mov dx,0x1f3
  mov eax,ebx
  out dx,al

  ;sending bits (8-15)
  mov dx,0x1f4
  mov eax,ebx
  shr eax,8
  out dx,al

  ;sending bits (16-23)
  mov dx,0x1f5
  mov eax,ebx
  shr eax,16
  out dx,al

  ;we will set command port ot retry
  mov dx,0x1f7
  mov al,0x20
  out dx,al

;we have to read all sectors

next_sec:
  push ecx

;since we set the command port to retry, as we know bus is slower
;than processor so we try again and again till the sucessfull
;reading of the sector

retry:
  mov dx,0x1f7
  in al,dx
  test al,8     ;test the bit in al for 1000,0 =failed, 
  jz retry

;reading 256 words at once
  mov ecx,256
  mov dx,0x1f0
  rep insw        ;read from posrt into the es:di pointed mem
  pop ecx
  loop next_sec
  ret 



times 510-($- $$) db 0
dw 0xAA55
