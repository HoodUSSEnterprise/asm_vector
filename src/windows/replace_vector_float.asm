global replace_vector_float
section .text

; bool replace_vector_float(VectorFloat *v, float old_elem, float new_elem);
; rcx = v, xmm1 = old_elem, xmm2 = new_elem
replace_vector_float:

    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 16

    movss [rsp], xmm14
    movss [rsp + 8], xmm15

    mov r14, rcx ; r14 = v

    ; check v
    test r14, r14
    jz no_replace

    mov r14, [rcx] ; r14 = v->data

    ; check v->data
    test r14, r14
    jz no_replace

    mov r14, rcx

    movss xmm14, xmm1 ; xmm14 = old_elem
    movss xmm15, xmm2 ; xmm15 = new_elem
    mov r12, [rcx + 8]

    mov rsi, [r14] ; rsi = v->data
    mov rdi, 0 ; flag
    xor rcx, rcx ; i = 0

calc_number:
    cmp rcx, r12 ; i < len
    jge next_step
    movss xmm0, [rsi + rcx * 4]
    ucomiss xmm0, xmm14 ; judge xmm0 and elem
    je replace_elem

    inc rcx
    jmp calc_number

replace_elem:
    movss [rsi + rcx * 4], xmm15
    mov rdi, 1
    inc rcx
    jmp calc_number

next_step:
    cmp rdi, 0
    je no_replace
    mov rax, 1
    jmp pop_data

no_replace:
    mov rax, 0

pop_data:

    movss xmm15, [rsp + 8]
    movss xmm14, [rsp]
    add rsp, 16
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    ret