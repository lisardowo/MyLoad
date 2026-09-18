
; this file contains the disk reading operations

load_disk:
  push dx     ; push to the stack work registers
  mov di, 3   ; selects 3 as the number of attempts

.disk_retry:
  mov ah, 0x02             ; activates read mode
  push ax                  ; saves reading parameters now
  int 0x13                 ; Disk reading interruption 
  jnc .disk_done     ; Jump if not carry instruction, if we do not have a carry flag then we can jump directly to disk_done and skip retry logic

.fail_on_reading:
  pop ax                  ; Restores previous saved ax from the stack
  dec di                  ; Reduces the # of attempts by 1
  jz  .disk_fatal_error   ; If no more attepts available triggers a fatal error
  
  ;If the jupm did not happened we still have some tries 
  ;We restore the values for the next attempt 
  push ax
  xor ah, ah ; Bios function, reset disk system
  mov dl, 0  ; Harcoded drive 0, (first drive), booting from a different device resets the wrong drive
  int 0x13
  pop ax

  jmp .disk_retry ; tries reading again

.disk_done:
  pop ax  ; discard saved ax since read has succeded
  pop dx  ; restore the dx saved at the start
  ret     ; return to the caller

.disk_fatal_error:
  ; if we fail in every attempt reading the disk, we frezze the CPU to avoid reading/exucting gargabe
  mov si, disk_error_msg
  call print_string_16
  cli
  hlt

print_string_16:
  pusha
  mov ah, 0x0E      ; BIOS function 0x0E: "teletype output" - prints al and advances the cursor
.print_loop:
  lodsb             ; loads [si] into al and increments si
  cmp al, 0
  je .print_done
  int 0x10
  jmp .print_loop
.print_done:
  popa
  ret
 
disk_error_msg db "Disk read error: could not load kernel", 0

