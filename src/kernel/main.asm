BITS 16
ORG 0x7c00

%define ENDL 0xD, 0xA

start:
; Initialize the data segment registers
    mov ax, 0
    mov ds, ax
    mov es, ax

; Set up the stack
    mov sp, 0x7c00 
    mov ss, ax

    call clear_screen

    mov si, welcome_message
    call print
    jmp $

; Clear the screen using BIOS interrupt 0x10
clear_screen:
    mov ax, 0x0003
    int 0x10 ; Clear the screen 
    ret

; Prints a null-terminated string pointed to by SI
print:
.print_loop:
    lodsb               ; Load byte at SI into AL and increment SI
    cmp al, 0
    je .done
    mov ah, 0eh
    int 0x10
    jmp .print_loop

.done:
    ret

welcome_message: db "Welcome to BubbleOS!", ENDL, 0

; Pad the rest of the boot sector with zeros
times 510 - ($ - $$) db 0

; Boot signature
dw 0xAA55 ; 0x55AA in big endian