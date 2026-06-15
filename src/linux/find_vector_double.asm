global find_vector_double
section .text

; bool find_vector_double(VectorDouble *v, double elem, int *index);
; rdi = v, xmm0 = elem, rsi = index
find_vector_double:

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    movsd [rsp], xmm15
    mov r14, rdi ; r14 = v
    
    ; check v1
    test r14, r14
    jz null_ptr

    mov r14, [rdi]

    ; check v1->data
    test r14, r14
    jz null_ptr

    mov r14, rdi

    movsd xmm15, xmm0 ; xmm15 = elem
    mov r13, rsi ; r13 = index

    mov rdi, [r14 + 8] ; rsi = v->len
    mov rsi, [r14] ; rdi = v->data

    xor rcx, rcx ; i = 0

on_loop:
    cmp rcx, rdi ; i < rdi
    jge no
    movsd xmm0, [rsi + rcx * 8] ; xmm0 = v->data[i]
    ucomisd xmm0, xmm15 ; judge xmm0 and elem
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
    movsd xmm15, [rsp]
    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
