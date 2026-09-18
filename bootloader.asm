[ORG 0x7C00]   ; Bios is assigned this address in memory
[bits 16] ; Tells the assembler to produce 16 bits instructions(because every CPU starts in 16 bit mode for compatibility)

; Cleanup of the segments for the descriptor table to avoid have garbage in case of an error

xor ax, ax ; xoring a value with itself is way more efficient way to get a 0 than directly loading it into memory
mov ds, ax ; then we just need to use or freshly produced 0 with every other register
mov es, ax
mov ss, ax
mov sp, 0x7C00 ; Sets the stack pointer to the start of the program so the bootloader dont overwrites itself 

; in x86 systems, usually the stacks grows downard

; Reading from disk

mov bx, 0x1000 ; Address we are loading the kernel to
mov al, 15     ; Number of sectors to read
mov ch, 0      ; Cilinder 0 
mov dh, 0      ; Head 0 
mov cl, 2      ; Starts reading from the 2nd sector (first one is the bootloader itself)

call load_disk    ; Invoques the read function from disk.asm 

; 32 Bits protected mode

cli                    ; Deactivates BIOS interruptions 
lgdt  [gdt_descriptor] ; Loads GDT 

mov eax, cr0  ; cr0 can't be modified directly by bit-operations, so we copy it into eax first 
or  eax, 0x1  ; Start as protected mode byte for the flag
mov cr0, eax  ; enables the flag in the cr0 register

jmp CODE_SEG:init_32_Bit  ; Far Jump to clean the CPU pipe and enters 32 bits mode

; include both modules we just created 

%include "disk.asm"
%include "descriptorTable.asm" 

[bits 32] ; Since we have configured everything properly we now tell the assmebler to produce 32 bits instructions

init_32_Bit:
  
  ; Real-mode segment values mean nothing in protected mode, so every segment
  ; register has to be reloaded with a valid GDT selector. We use DATA_SEG for
  ; all of them (flat model, no distinction between stack/extra/etc segments).

  mov ax, DATA_SEG
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000 ; we pick an address away from the kernel (0x1000) and video memory (0xB8000) to set up the stack
  mov esp, ebp     ; stack is now empty so esp starts at the same place as ebp
  
  jmp 0x1000 ; jumps to expected kernel address and hands down the control

times 510-($-$$) db 0 ; fills the nedeed bytes so the next instruction lands in 510/11 bytes
dw 0xAA55 ; Magic number, signs the drive is bootable
