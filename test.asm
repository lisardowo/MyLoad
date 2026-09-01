
[bits 16] 
[org 0x7c00] 

; Save the boot drive number provided by BIOS
mov [BOOT_DRIVE], dl

; 16 bits stack configuration
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00 

; reading from disk
mov ah, 0x02        ; BIOS read sector function
mov al, 15          ; Number of sectors to read
mov ch, 0x00        ; Cylinder 0
mov dh, 0x00        ; Head 0
mov cl, 2           ; Sector 2 (Sector 1 is this bootloader)
mov dl, [BOOT_DRIVE]; Drive number
mov bx, 0x1000      ; Destination pointer offset (es:bx = 0x0000:0x1000)
int 0x13            ; BIOS Disk Interrupt
jc disk_error       ; Jump if Carry Flag is set (error handling)

; GDT Configuration
gdt_start:
gdt_null: 
  dd 0x0
  dd 0x0

gdt_code: 
  dw 0xFFFF, 0x0
  db 0x0, 10011010b, 11001111b, 0x0

gdt_data:
  dw 0xFFFF 
  dw 0x0    
  db 0x0    
  db 10010010b 
  db 11001111b  
  db 0x0        
gdt_end:

gdt_descriptor:
  dw gdt_end - gdt_start - 1 
  dd gdt_start               

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

switchTo32Bit:
  cli                   ; Disable interrupts
  lgdt [gdt_descriptor] ; Load GDT
  
  mov eax, cr0
  or eax, 0x1           ; Set protected mode bit
  mov cr0, eax          
  
  jmp CODE_SEG:init32Bit; Far jump to clear pipeline and set CS

[bits 32]
init32Bit:
  mov ax, DATA_SEG      ; Load data segment selector
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000      ; Configure 32-bit stack safe space
  mov esp, ebp

  jmp CODE_SEG:0x1000   ; Jump directly to the loaded kernel

; Infinite loop for fallback errors
disk_error:
  jmp $

; Variables
BOOT_DRIVE db 0

; Boot signature padding
times 510-($-$$) db 0 
dw 0xAA55 

