global replace_vector_double
section .text

; bool replace_vector_double(VectorDouble *v, double old_elem, double new_elem);
; rcx = v, xmm1 = old_elem, xmm2 = new_elem
replace_vector_double:

    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 16

    movsd [rsp], xmm14
    movsd [rsp + 8], xmm15

    mov r14, rcx ; r14 = v

    ; check v
    test r14, r14
    jz no_replace

    mov r14, [rcx] ; r14 = v->data

    ; check v->data
    test r14, r14
    jz no_replace

    mov r14, rcx
    
    movsd xmm14, xmm1 ; xmm14 = old_elem
    movsd xmm15, xmm2 ; xmm15 = new_elem
    mov r12, [rcx + 8]

    mov rsi, [r14] ; rsi = v->data
    mov rdi, 0     ; flag
    xor rcx, rcx ; i = 0

calc_number:
    cmp rcx, r12 ; i < len
    jge next_step
    movsd xmm0, [rsi + rcx * 8]
    ucomisd xmm0, xmm14 ; judge xmm0 and elem
    je replace_elem

    inc rcx
    jmp calc_number

replace_elem:
    movsd [rsi + rcx * 8], xmm15
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

    movsd xmm15, [rsp + 8]
    movsd xmm14, [rsp]
    add rsp, 16
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    ret