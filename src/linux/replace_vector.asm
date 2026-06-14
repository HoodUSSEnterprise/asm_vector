global replace_vector_int
section .text

; bool replace_vector_int(VectorInt *v, int old_elem, int new_elem);
; rdi = v, esi = old_elem, edx = new_data
replace_vector_int:

    push r12
    push r13
    push r14
    push r15

    mov r14, rdi ; r14 = v
    mov r15d, esi ; r15d = old_elem
    mov r13d, edx ; r13d = new_elem
    mov r12, [rdi + 8]

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
    ret
