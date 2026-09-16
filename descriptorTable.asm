
; File dedicated to cntain the global descriptor Table

gdt_start: ; start of the table, each entry is 8 bytes blocks

gdt_null: ; 

  dd  0x0
  dd  0x0 ; Intel x86-64 architecture mandates to have an sector full of zeros

gdt_code: ; This sector defines the region of memory the cpu can load instructions from
  
  dw  0xFFFF ; in 32 bits architecture (the one we are curently using) both descriptors should be 8 bytes long
  db  0x0,  10011010b,  11001111b,  0x0

gdt_data:

; functionally code and data maps the same memory layout since its just defining the reach the cpu have
; Following implementation is way more verbose about the meaning of each value

dw 0xFFFF    ; segment length(bits 0 - 15)
dw 0x0       ; segment base, bits 0 -15
db 0x0       ; segment base, 16-23
db 10010010b ; Access byte Flag (present, ring 0, executable, readable) //permisions it has when reading information
db 11001111b ; Granularity Flag (4GB limit/32-bit default) how much memory and how it should be interpreted
db 0x0

gdt_end:

gdt_descriptor:
  dw gdt_end - gdt_start - 1 ; GDT size
  dd gdt_start               ; Start Address

; Constants for the CPU segments 

CODE_SEG equ gdt_code - gdt_start ; Gets the offset between code and start sections
DATA_SEG equ gdt_data - gdt_start 
