default rel

section .data
    last_week db 0, 2, 5, 3, 7, 8, 4, 0

section .bss
    current_week   resb 8   ; 7 jours + 1 byte de padding à zéro
    days_recorded  resq 1   ; compteur de jours renseignés (0..7)

section .text

; ============================================================================
; Task 1 — last_week_counts() -> rax
; ============================================================================
global last_week_counts
last_week_counts:
    mov rax, qword [last_week]
    ret

; ============================================================================
; Task 2 — current_week_counts() -> rax, rdx
; ============================================================================
global current_week_counts
current_week_counts:
    mov rax, qword [current_week]
    mov rdx, qword [days_recorded]
    ret

; ============================================================================
; Task 3 — save_count(count: u8 in dil)
; ============================================================================
global save_count
save_count:
    mov rcx, qword [days_recorded]
    cmp rcx, 7
    jne .append

    mov rax, qword [current_week]
    mov qword [last_week], rax
    mov qword [current_week], 0
    xor rcx, rcx

.append:
    lea rax, [current_week]         ; RIP-relative LEA
    mov [rax + rcx], dil            ; indexation sur registre → OK
    inc rcx
    mov qword [days_recorded], rcx
    ret

; ============================================================================
; Task 4 — today_count() -> al
; ============================================================================
global today_count
today_count:
    mov rcx, qword [days_recorded]
    dec rcx
    lea rax, [current_week]
    movzx rax, byte [rax + rcx]     ; safe : source évaluée avant écriture dest
    ret

; ============================================================================
; Task 5 — update_today_count(count: u8 in dil)
; ============================================================================
global update_today_count
update_today_count:
    mov rcx, qword [days_recorded]
    dec rcx
    lea rax, [current_week]
    add byte [rax + rcx], dil
    ret

; ============================================================================
; Task 6 — update_week_counts(week: u64 in rdi)
; ============================================================================
global update_week_counts
update_week_counts:
    mov rax, qword [current_week]
    mov qword [last_week], rax
    mov qword [current_week], rdi
    mov byte [current_week + 7], 0
    mov qword [days_recorded], 7
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif