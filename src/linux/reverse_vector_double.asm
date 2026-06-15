global reverse_vector_double
section .text
extern malloc
extern free

; void reverse_vector_double(VectorDouble *v);
; rdi = v
reverse_vector_double:
    
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15

    mov r14, rdi ; r14 = v
    mov r13, [rdi + 8] ; r13 = v->len
    mov r15, [rdi] ; r15 = v->data

    test r14, r14
    jz pop_data

    mov r14, [rdi]

    ; check v->data
    test r14, r14
    jz pop_data

    mov r14, rdi ; r14 = v
    
    ; malloc new data
    mov rdi, r13
    shl rdi, 3 ; double size = 8
    call malloc wrt ..plt
    test rax, rax
    jz failed_data

    ; save the malloc res
    mov rbx, rax ; rbx = (array)new_data

    ; reverse old_data
    ; init params
    xor rcx, rcx ; i = 0
    mov rdi, r13 ; len

reverse_data:
    cmp rcx, rdi ; i < len
    jge end

    movsd xmm0, [r15 + rcx * 8]
    mov rsi, r13 ; len
    sub rsi, rcx ; len - i
    sub rsi, 1 ; len - i - 1
    movsd [rbx + rsi * 8], xmm0
    inc rcx
    jmp reverse_data

failed_data:
    mov rax, 0
    jmp pop_data

end:
    mov rdi, [r14]
    call free wrt ..plt
    mov [r14], rbx

pop_data:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    ret
