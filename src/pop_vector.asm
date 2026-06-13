global pop_int
section .text

; void pop_int(MyVector *v, int *data);
; rcx = v, rdx = data
pop_int:

    push rbx
    push rdi
    push rsi
    push r13
    push r14
    push r15

    ; save rcx and rdx
    mov r14, rcx
    mov r15, rdx

    mov r13, [r14 + 8] ; r13 = v->len
    cmp r13, 0
    je .error
    sub [r14 + 8], 1
    sub r13, 1
    
    mov rdi, [r14]
    mov esi, [rdi + r13 * 4]
    mov [r15], esi

.error
    pop r15
    pop r14
    pop r13
    pop rsi
    pop rdi
    pop rbx
    ret
