global find_vector_float
section .text

; bool find_vector_float(VectorFloat *v, float elem, int *index);
; rdi = v, xmm0 = elem, rsi = index
find_vector_float:

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    movss [rsp], xmm15
    mov r14, rdi ; r14 = v
        
    ; check v1
    test r14, r14
    jz null_ptr

    mov r14, [rdi]

    ; check v1->data
    test r14, r14
    jz null_ptr

    mov r14, rdi

    movss xmm15, xmm0 ; xmm15 = elem
    mov r13, rsi ; r13 = index

    mov r12, [r14 + 8] ; rsi = v->len
    mov r15, [r14] ; rdi = v->data

    xor rcx, rcx ; i = 0

on_loop:
    cmp rcx, r12 ; i < rdi
    jge no
    movss xmm0, [r15 + rcx * 4] ; xmm0 = v->data[i]
    ucomiss xmm0, xmm15 ; judge xmm0 and elem
    je yes

    inc rcx; ; i++
    jmp on_loop

null_ptr:
    mov rax, 0
    jmp pop_data

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
    pop rbx
    ret
