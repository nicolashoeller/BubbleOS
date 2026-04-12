BITS 16
ORG 0x7c00

%define ENDL 0xD, 0xA

; FAT 12 header

jmp short start
nop 

bdb_oem:                    db 'MSWIN4.1' ; 8 bytes
bdb_bytes_per_sector:       dw 512
bdb_sectors_per_cluster:    db 1
bdb_reserved_sectors:       dw 1
bdb_num_fats:               db 2
bdb_dir_entries_count:      dw 0x0E0
bdb_total_sectors:          dw 2880
bdb_media_descriptor:       db 0xF0
bdb_sectors_per_fat:        dw 9
bdb_sectors_per_track:      dw 18
bdb_num_heads:              dw 2
bdb_hidden_sectors:         dd 0
bdb_total_sectors_large:    dd 0


; extended boot record (FAT 12)
ebr_drive_number:           db 0
ebr_reserved:               db 0
ebr_signature:              db 0x29
ebr_volume_id:              dd 0x12345678
ebr_volume_label:           db 'BubbleOS   ' ; 11 bytes
ebr_system_id:              db 'FAT12   ' ; 8 bytes


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