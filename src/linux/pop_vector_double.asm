global pop_double
section .text

; void pop_double(VectorDouble *v, double *data);
; rdi = v, rsi = data
pop_double:

    push rbx
    push r13
    push r14
    push r15

    ; save rdi and rsi
    mov r14, rdi
    mov r15, rsi

    ; check c
    test r14, r14
    jz error

    mov r14, [rdi]

    ;check v->data
    test r14, r14
    jz error

    mov r14, rdi

    mov r13, [r14 + 8] ; r13 = v->len
    cmp r13, 0
    je error
    sub [r14 + 8], 1
    sub r13, 1
    
    mov rdi, [r14]
    movsd xmm0, [rdi + r13 * 4]
    movsd [r15], xmm0

error:
    pop r15
    pop r14
    pop r13
    pop rbx
    ret
