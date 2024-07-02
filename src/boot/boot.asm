ORG 0x7c00
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

_start:
    jmp short start
    nop
    times 33 db 0 ; Used by the assembler, not executed by the CPU

start:
    jmp 0:step2

step2:
    cli ; Clear Interrups
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti ; Enable Interrups

.load_protected:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    ; jmp CODE_SEG:load32
    jmp $


; GDT
gdt_start:
gdt_null:
    dd 0x00
    dd 0x00

; offset 0x08
gdt_code:     ; CS should point to this 
    dw 0xffff ; Segment limit first 0-15 bits
    dw 0      ; Base first 0-15 bits
    db 0      ; Base 16-23 bits
    db 0x9a   ; Access byte
    db 11001111b ; High 4 bit flags and the low 4 bit flags
    db 0      ; Base 24-31 bits
; offset 0x10
gdt_data:     ; DS, SS, ES, FS, GS 
    dw 0xffff ; Segment limit first 0-15 bits
    dw 0      ; Base first 0-15 bits
    db 0      ; Base 16-23 bits
    db 0x92   ; Access byte
    db 11001111b ; High 4 bit flags and the low 4 bit flags
    db 0      ; Base 24-31 bits
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start-1
    dd gdt_start

times 510-($ - $$) db 0
dw 0xAA55






















