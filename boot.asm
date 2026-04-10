BITS 16
ORG 0x7c00

start:
    mov si, welcome_message
    call print
    mov si, welcome_philipp_message
    call print
    jmp $

print:
    mov bx, 0

.print_loop:
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .print_loop

.done:
    ret

print_char:
    mov ah, 0eh
    int 0x10
    ret


welcome_message: db "Bitch ass nigga, EFN!", 0xA, 0
welcome_philipp_message: db "BOAAHHHH PHILIPP DU GEILE SAU, LECK EIER!!!", 0

times 510 - ($ - $$) db 0
dw 0xAA55 ; 0x55AA in big endian