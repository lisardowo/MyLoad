[bits 16] ; all bootloader starts as 16 real bytes
[org 0x7c00] ; the address of the kernel in memory

; 16 bits stck configuration

xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00 ; Assigns the kernel to the bottom(start) of the pile 

; reading from disk

mov ah, 0x02 ; read mode
mov al, 15 ;reading 15 sectors of the memory
mov cl, 2 ; starts reading from the 2nd sector (since the first is the bootloader itself)
mov bx, 0x1000 ; direction where we are putting the loaded kernel
int 0x13 ; Disk interrupt (BIOS)

; Group descriptor table ;

gdt_start:

gdt_null: ; Intel architecture mandates to have an 8 byte block of zeros for security reasons
  dd 0x0
  dd 0x0

gdt_code: ; code section for locating the kernel and construct reading
  ; for compatibility reasons both code and data section should 
  ; be 16 bytes long

  dw 0xFFFF, 0x0
  db 0x0, 10011010b, 11001111b 0x0

gdt_data:
  ; functionally code and data maps the same memory layout
  ; The difference is just that this way lets me to be more verbose about
  ; the reason of each directive
  dw 0xFFFF ; segmenth length (bits 0 - 15)
  dw 0x0    ; segment base, bits 0-15
  db 0x0    ; segment base, 16 - 23
  db 10010010b ; flags (8 bits)
  db 11001111b  ; flags (4 bits) + segment length (bits 16 - 19)
  db 0x0        ; segment base, bits 24 - 31

gdt_end:

; GDT descriptor
gdt_descriptor:
  dw gdt_end - gdt start - 1 ; size 16 bit
  dd gdt_start               ; address (32 bit)

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

switchTo32Bit:
  cli   ; disable keyboard interrupt
  lgdt [gdt_descriptor] ; load GDT descriptor
  ;
  mov eax, cr0
  or eax, 0x1             ; start as protected mode
  mov cr0, eax            ; Enable protected mode bit in cr0
  ;
  jmp CODE_SEG:init32Bit  ; far jump to clean CPU pipeline

[bits 32]
init32bit:
  mov ax, DATA_SEG  ; Load the new segment to ax register
  ; Update segment registers using ax
  mov ds, ax
  mov ss, ax
  mov cs, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000 ; setup stack
  mov esp, ebp

