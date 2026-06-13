global replace_vector
section .text

; bool replace_vector(VectorInt *v, int old_elem, int new_elem);
; rcx = v, edx, old_elem, r8d
replace_vector:

    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15

    mov r14, rcx ; r14 = v
    mov r15d, edx ; r15d = old_elem
    mov r13d, r8d ; r13d = new_elem
    mov r12, [rcx + 8]

    mov rsi, [r14] ; rsi = v->data
    xor rcx, rcx ; i = 0

calc_number:
    cmp rcx, r12 ; i < len
    jge pop_data
    cmp [rsi + rcx * 4], r15d ; data[i] == old_elem
    je replace_elem

    inc rcx
    jmp calc_number

replace_elem:
    mov [rsi + rcx * 4], r13d
    inc rcx
    jmp calc_number


pop_data:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    ret