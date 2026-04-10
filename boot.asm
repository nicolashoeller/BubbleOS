BITS 16
ORG 0x7c00

start:
    mov si, welcome_message
    call print
    jmp $


; Prints a null-terminated string pointed to by SI
print:
.print_loop:
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .print_loop

.done:
    ret

; Prints a single character in AL
print_char:
    mov ah, 0eh
    int 0x10
    ret


welcome_message: db "Welcome to BubbleOS!", 0xA, 0

; Pad the rest of the boot sector with zeros
times 510 - ($ - $$) db 0

; Boot signature
dw 0xAA55 ; 0x55AA in big endian