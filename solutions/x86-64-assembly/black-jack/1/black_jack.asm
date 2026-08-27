; Everything that comes after a semicolon (;) is a comment

C2 equ 2
C3 equ 3
C4 equ 4
C5 equ 5
C6 equ 6
C7 equ 7
C8 equ 8
C9 equ 9
C10 equ 10
CJ equ 11
CQ equ 12
CK equ 13
CA equ 14

TRUE equ 1
FALSE equ 0

section .text

; You should implement functions in the .text section

; the global directive makes a function visible to the test files
global value_of_card
value_of_card:
    mov rax, rdi

    ; Est-ce une figure (11, 12, 13) ?
    cmp rax, 11
    jl  .not_face
    cmp rax, 13
    jg  .not_face

    ; RAX est dans [11, 13] → figure
    mov rax, 10
    ret

.not_face:
    ; Est-ce l'As (14) ?
    cmp rax, 14
    jne .done       ; sinon, carte numérique, RAX déjà bon
    mov rax, 1

.done:
    ret

global higher_card
higher_card:
    ; --- Étape 1 : convertir card_one (RDI) en valeur de scoring dans R10 ---
    mov r10, rdi
    cmp r10, 14
    je  .one_ace                 ; si == 14 (As), R10 = 1
    cmp r10, 11
    jl  .one_done                ; si < 11, R10 est déjà la bonne valeur
    mov r10, 10                  ; sinon (11, 12, 13 → figure), R10 = 10
    jmp .one_done
.one_ace:
    mov r10, 1
.one_done:

    ; --- Étape 2 : idem pour card_two (RSI) dans R11 ---
    mov r11, rsi
    cmp r11, 14
    je  .two_ace
    cmp r11, 11
    jl  .two_done
    mov r11, 10
    jmp .two_done
.two_ace:
    mov r11, 1
.two_done:

    ; --- Étape 3 : comparer les VALEURS de scoring (R10 vs R11) ---
    cmp r10, r11
    je  .equal                   ; valeurs égales → retourner les 2 cartes
    jg  .one_wins                ; A > B en scoring → retourner A seul

    ; Fall-through : B > A en scoring → retourner B seul
    mov rax, rsi                 ; RAX = card_two
    xor edx, edx                 ; RDX = 0
    ret

.one_wins:
    mov rax, rdi                 ; RAX = card_one
    xor edx, edx                 ; RDX = 0
    ret

.equal:
    mov rax, rdi                 ; RAX = card_one
    mov rdx, rsi                 ; RDX = card_two
    ret

global value_of_ace
value_of_ace:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return the value of an upcoming ace
    cmp rdi, 14
    je .bust
    cmp rsi, 14
    je .bust

    mov r10, rdi
    cmp r10, 11 
    jl .one_done
    mov r10, 10
    jmp .one_done
.one_done:
    mov r11, rsi
    cmp r11, 11 
    jl .two_done
    mov r11, 10
    jmp .two_done
.two_done:
    add r10, r11
    cmp r10, 10
    jg .bust
    mov rax, 11
    ret
.bust:
    mov rax, 1
    ret

global is_blackjack
is_blackjack:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards form a blackjack, and FALSE otherwise
    ;
    ; Si A == 14 :
    ;    Si B >= 10
    ;        print 1
    ;    si B < 10:
    ;        print 0
    ;
    ;  Si A != 14
    ;    Si B == 14:
    ;        Si A >= 10
    ;            print 1
    ;        si 1 < 10
    ;            print 0
    ;    Si B != 14:
    ;        print 0
    ;
    
    mov r10, rdi
    mov r11, rsi

    ; Est-ce que A = 14 (AS) ?
    cmp r10, 14
    jne .try_b_ace

    ; Est-ce que B >= 10 ?
    cmp r11, 10
    jl .not_blackjack

    ; Est-ce que B <= 13 ?
    cmp r11, 13
    jg .not_blackjack

    ; Affiche 1 = blackjack !
    mov rax, TRUE
    ret

.try_b_ace:
    mov r10, rdi
    mov r11, rsi

    ; Est-ce que B = 14 (AS) ?
    cmp r11, 14
    jne .not_blackjack

    ; Est-ce que A >= 10 ?
    cmp r10, 10
    jl .not_blackjack

    ; Est-ce que A <= 13 ?
    cmp r10, 13
    jg .not_blackjack

    ; Affiche 1 = blackjack !
    mov rax, TRUE
    ret

.not_blackjack:
    ; Affiche 0 != blackjack ! 
    xor rax, rax
    ret

global can_split_pairs
can_split_pairs:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards can be split into two pairs, and FALSE otherwise
    mov r10, rdi
    cmp r10, 14
    je  .one_ace
    cmp r10, 11
    jl  .one_done
    mov r10, 10
    jmp .one_done
.one_ace:
    mov r10, 1
.one_done:
    mov r11, rsi
    cmp r11, 14
    je  .two_ace
    cmp r11, 11
    jl  .two_done
    mov r11, 10
    jmp .two_done
.two_ace:
    mov r11, 1
.two_done:
    sub r10, r11
    
    ; Est-ce A - B = 0
    cmp r10, 0
    jne .not_equal
    jmp .equal

.not_equal:
    mov rax, FALSE
    ret
    
.equal:
    mov rax, TRUE
    ret

global can_double_down
can_double_down:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards form a hand that can be doubled down, and FALSE otherwise
global can_double_down
can_double_down:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards form a hand that can be doubled down, and FALSE otherwise
    
    mov r10, rdi
    cmp r10, 14
    je  .one_ace
    cmp r10, 11
    jl  .one_done
    mov r10, 10
    jmp .one_done
.one_ace:
    mov r10, 1
.one_done:
    mov r11, rsi
    cmp r11, 14
    je  .two_ace
    cmp r11, 11
    jl  .two_done
    mov r11, 10
    jmp .two_done
.two_ace:
    mov r11, 1
.two_done:
    add r10, r11
    
    ; Est-ce que la somme des deux cartes est entre 9 et 11 points
    cmp r10, 9
    jl .not_equal
    cmp r10, 11
    jg .not_equal
    jmp .equal

.not_equal:
    mov rax, FALSE
    ret

.equal:
    mov rax, TRUE
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
