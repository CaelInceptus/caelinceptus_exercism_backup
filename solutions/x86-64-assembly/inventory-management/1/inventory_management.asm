; Everything that comes after a semicolon (;) is a comment

WEIGHT_OF_EMPTY_BOX equ 500
TRUCK_HEIGHT equ 300
PAY_PER_BOX equ 5
PAY_PER_TRUCK_TRIP equ 220

section .text

; You should implement functions in the .text section
; A skeleton is provided for the first function

; the global directive makes a function visible to the test files
global get_box_weight
get_box_weight:
    ; This function takes the following parameters:
    ; - The number of items for the first product in the box, as a 16-bit non-negative integer
    ; - The weight of each item of the first product, in grams, as a 16-bit non-negative integer
    ; - The number of items for the second product in the box, as a 16-bit non-negative integer
    ; - The weight of each item of the second product, in grams, as a 16-bit non-negative integer
    ; The function must return the total weight of a box, in grams, as a 32-bit non-negative integer
    push rbp
    mov  rbp, rsp
    sub  rsp, 16              

    mov  rax, rdx
    mul  rcx
    mov  [rbp-8], rax

    mov  rax, rdi
    mul  rsi
    add  rax, [rbp-8]
    add  rax, WEIGHT_OF_EMPTY_BOX

    mov  rsp, rbp
    pop  rbp
    ret

global max_number_of_boxes
max_number_of_boxes:
    ; TODO: define the 'max_number_of_boxes' function
    ; This function takes the following parameter:
    ; - The height of the box, in centimeters, as a 8-bit non-negative integer
    ; The function must return how many boxes can be stacked vertically, as a 8-bit non-negative integer
    mov rax, TRUCK_HEIGHT
    xor edx, edx
    div rdi
    ret

global items_to_be_moved
items_to_be_moved:
    ; TODO: define the 'items_to_be_moved' function
    ; This function takes the following parameters:
    ; - The number of items still unaccounted for a product, as a 32-bit non-negative integer
    ; - The number of items for the product in a box, as a 32-bit non-negative integer
    ; The function must return how many items remain to be moved, after counting those in the box, as a 32-bit integer
    mov rax, rdi
    sub rax, rsi
    ret

global calculate_payment
calculate_payment:
    ; TODO: define the 'calculate_payment' function
    ; This function takes the following parameters:
    ; - The upfront payment, as a 64-bit non-negative integer
    ; - The total number of boxes moved, as a 32-bit non-negative integer
    ; - The number of truck trips made, as a 32-bit non-negative integer
    ; - The number of lost items, as a 32-bit non-negative integer
    ; - The value of each lost item, as a 64-bit non-negative integer
    ; - The number of other workers to split the payment/debt with you, as a 8-bit positive integer
    ; The function must return how much you should be paid, or pay, at the end, as a 64-bit integer (possibly negative)
    ; Remember that you get your share and also the remainder of the division

    ; rdi, rsi, rdx, rcx, r8 et r9

    ; Calcul des 3 Produit :
    imul rcx, r8                         ; RCX = broken_items * item_value
    imul rdx, rdx, PAY_PER_TRUCK_TRIP    ; RDX = trips * PAY_PER_TRUCK_TRIP
    imul rsi, rsi, PAY_PER_BOX           ; RSI = boxes * PAY_PER_BOX

    ; Calcul de NET (RAX) :
    mov rax, rsi                         ; boxes * PAY_PER_BOX
    add rax, rdx                         ; boxes * PAY_PER_BOX + trips * PAY_PER_TRUCK_TRIP
    sub rax, rdi                         ; (boxes * PAY_PER_BOX + trips * PAY_PER_TRUCK_TRIP) - up_front
    sub rax, rcx                         ; ((boxes * PAY_PER_BOX + trips * PAY_PER_TRUCK_TRIP) - up_front) - broken_items * item_value

    ; Diviseur = workers + 1
    inc r9                               ; R9 = workers + 1

    ; Division signée : RAX = quotient, RDX = reste
    cqo                                  ; sign-extend RAX dans RDX:RAX
    idiv r9

    ; Résultat = la part + le reste
    add rax, rdx
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
