global find_vector_float
section .text

; bool find_vector_float(VectorFloat *v, float elem, int *index);
; rcx = v, xmm1 = elem, r8 = index
find_vector_float:

    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    movss [rsp], xmm15
    mov r14, rcx ; r14 = v
    movss xmm15, xmm1 ; xmm15 = elem
    mov r13, r8 ; r13 = index

    mov rdi, [r14 + 8] ; rsi = v->len
    mov rsi, [r14] ; rdi = v->data

    xor rcx, rcx ; i = 0

on_loop:
    cmp rcx, rdi ; i < rdi
    jge no
    movss xmm0, [rsi + rcx * 4] ; xmm0 = v->data[i]
    ucomiss xmm0, xmm15 ; judge xmm0 and elem
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
    movss xmm15, [rsp]
    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    pop rbx
    ret