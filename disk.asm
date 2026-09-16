
; this file contains the disk reading operations

load_disk:
  push dx     ; push to the stack work registers
  mov di, 3   ; selects 3 as the number of attempts

.disk_retry:
  push ax                  ; saves reading parameters now
  int 0x13                 ; Disk reading interruption 
  jc .fail_on_reading      ; Jump if carry checks if the reading has the "Carry Flag" (if it does, something failed) then jumps to an designated address (a fallback)

.fail_on_reading:
  pop ax                  ; Restores previous saved ax from the stack
  dec di                  ; Reduces the # of attempts by 1
  jz  .disk_fatal_error   ; If no more attepts available triggers a fatal error
  
  ;If the jupm did not happened we still have some tries 
  ;We restore the values for the next attempt 
  push ax
  xor ah, ah
  mov dl, 0
  int 0x13
  pop ax

  jmp .disk_retry ; tries reading again

.disk_fatal_error:
  ; if we fail in every attempt reading the disk, we frezze the CPU to avoid reading/exucting gargabe
  cli
  hlt
