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
