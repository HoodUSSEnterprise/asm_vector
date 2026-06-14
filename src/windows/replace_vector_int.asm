global replace_vector_int
section .text

; bool replace_vector_int(VectorInt *v, int old_elem, int new_elem);
; rcx = v, edx = old_elem, r8d = new_data
replace_vector_int:

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
    mov rdi, 0    ; flag
    xor rcx, rcx ; i = 0

calc_number:
    cmp rcx, r12 ; i < len
    jge next_step
    cmp [rsi + rcx * 4], r15d ; data[i] == old_elem
    je replace_elem

    inc rcx
    jmp calc_number

replace_elem:
    mov [rsi + rcx * 4], r13d
    mov rdi, 1
    inc rcx
    jmp calc_number

next_step:
    cmp rdi, 0
    je no_replace
    mov rax, 1
    jmp pop data
no_replace:
    mov rax, 0

pop_data:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    ret