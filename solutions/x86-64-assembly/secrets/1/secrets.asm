section .rodata
    PRIVATE_KEY equ 0b1011_0011_0011_1100

section .text

; ============================================================================
; Task 1 — extract_higher_bits(uint16_t) -> uint8_t
; Retourne le high byte (bits 15:8) du paramètre 16-bit.
; ============================================================================
global extract_higher_bits
extract_higher_bits:
    movzx eax, di
    shr eax, 8
    ret

; ============================================================================
; Task 2 — extract_lower_bits(uint16_t) -> uint8_t
; Retourne le low byte (bits 7:0) du paramètre 16-bit.
; ============================================================================
global extract_lower_bits
extract_lower_bits:
    movzx eax, dil
    ret

; ============================================================================
; Task 3 — extract_redundant_bits(uint16_t) -> uint8_t
; Bits communs entre le high byte (mask) et le low byte (message) : AND.
; ============================================================================
global extract_redundant_bits
extract_redundant_bits:
    movzx eax, di
    mov ecx, eax
    shr eax, 8
    and eax, ecx
    movzx eax, al
    ret

; ============================================================================
; Task 4 — set_message_bits(uint16_t) -> uint8_t
; Force à 1 les bits du message qui sont set dans le mask : OR.
; ============================================================================
global set_message_bits
set_message_bits:
    movzx eax, di
    mov ecx, eax
    shr eax, 8
    or eax, ecx
    movzx eax, al
    ret

; ============================================================================
; Task 5 — rotate_private_key(uint16_t) -> uint16_t
; Rotation à gauche de PRIVATE_KEY d'un nombre de positions égal au
; popcount du résultat de extract_redundant_bits.
; ============================================================================
global rotate_private_key
rotate_private_key:
    call extract_redundant_bits
    popcnt eax, eax
    mov cl, al
    mov ax, PRIVATE_KEY
    rol ax, cl
    movzx eax, ax
    ret

; ============================================================================
; Task 6 — format_private_key(uint16_t) -> uint8_t
; Rotate → XOR base avec mask (flip conditionnel) → NOT (flip total).
; ============================================================================
global format_private_key
format_private_key:
    call rotate_private_key
    mov ecx, eax
    shr ecx, 8
    xor eax, ecx
    not al
    movzx eax, al
    ret

; ============================================================================
; Task 7 — decrypt_message(uint16_t) -> uint16_t
; Compose : bits hauts = format_private_key, bits bas = set_message_bits.
; ============================================================================
global decrypt_message
decrypt_message:
    push rbx
    sub rsp, 8

    mov ebx, edi

    call format_private_key
    shl eax, 8
    mov r8d, eax

    mov edi, ebx
    call set_message_bits

    or eax, r8d
    movzx eax, ax

    add rsp, 8
    pop rbx
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif