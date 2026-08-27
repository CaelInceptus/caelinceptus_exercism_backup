section .text
global leap_year
leap_year:
    ; Provide your implementation here
    ; The function has type signature int leap_year(int year)
    ; The return value and the argument are of type int, which is a 32-bit signed integer
    mov  eax, edi
    cdq
    mov  ecx, 4
    idiv ecx
    test edx, edx
    jne  .not_leap

    mov  eax, edi
    cdq
    mov  ecx, 100
    idiv ecx
    test edx, edx
    jne  .leap

    mov  eax, edi
    cdq
    mov  ecx, 400
    idiv ecx
    test edx, edx
    jne  .not_leap

.leap:
    mov  eax, 1
    ret

.not_leap:
    xor  eax, eax
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
