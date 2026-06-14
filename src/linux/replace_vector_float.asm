global replace_vector_float
section .text

; bool replace_vector_float(VectorFloat *v, float old_elem, float new_elem);
; rdi = v, xmm0 = old_elem, xmm1 = new_elem
replace_vector_float:

    push r12
    push r13
    push r14
    push r15
    sub rsp, 16

    movss [rsp], xmm14
    movss [rsp + 8], xmm15

    mov r14, rdi ; r14 = v
    movss xmm14, xmm0 ; xmm14 = old_elem
    movss xmm15, xmm1 ; xmm15 = new_elem
    mov r12, [rdi + 8]

    mov rsi, [r14] ; rsi = v->data
    xor rcx, rcx ; i = 0

calc_number:
    cmp rcx, r12 ; i < len
    jge pop_data
    movss xmm0, [rsi + rcx * 4]
    ucomiss xmm0, xmm14 ; judge xmm0 and elem
    je replace_elem

    inc rcx
    jmp calc_number

replace_elem:
    movss [rsi + rcx * 4], xmm15
    inc rcx
    jmp calc_number


pop_data:

    movss xmm15, [rsp + 8]
    movss xmm14, [rsp]
    add rsp, 16
    pop r15
    pop r14
    pop r13
    pop r12
    ret
