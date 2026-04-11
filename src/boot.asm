BITS 16
ORG 0x7c00

start:
    call init_segments

    call clear_screen

    mov si, welcome_message
    call print
    jmp $

; Initialize the segment registers and stack
init_segments:
; Initialize the data segment registers
    mov ax, 0
    mov ds, ax
    mov es, ax

; Set up the stack
    mov sp, 0x7c00
    mov ss, ax
    ret

; Clear the screen using BIOS interrupt 0x10
clear_screen:
    mov ax, 0x0003
    int 0x10 ; Clear the screen 
    ret

; Prints a null-terminated string pointed to by SI
print:
.print_loop:
    lodsb
    cmp al, 0
    je .done
    mov ah, 0eh
    int 0x10
    jmp .print_loop

.done:
    ret

welcome_message: db "Welcome to BubbleOS!", 0xD, 0xA, 0

; Pad the rest of the boot sector with zeros
times 510 - ($ - $$) db 0

; Boot signature
dw 0xAA55 ; 0x55AA in big endian