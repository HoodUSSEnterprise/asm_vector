global find_vector_int
section .text

; bool find_vector_int(VectorInt *v, int elem, int *index);
; rcx = v, edx = elem, r8 = index
find_vector_int:

    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15

    mov r14, rcx ; r14 = v
    mov r15d, edx ; r15d = elem
    mov r13, r8 ; r13 = index

    mov rdi, [r14 + 8] ; rsi = v->len
    mov rsi, [r14] ; rdi = v->data

    xor rcx, rcx ; i = 0

on_loop
    cmp rcx, rdi ; i < rdi
    jge no
    cmp [rsi + rcx * 4], r15d ; compare v->data[i] and elem
    je yes

    inc rcx; ; i++
    jmp on_loop


yes:
    mov [r13], rcx
    mov rax, 1
    jmp pop_data

no:
    mov rax, 0

pop_data:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    pop rbx
    ret