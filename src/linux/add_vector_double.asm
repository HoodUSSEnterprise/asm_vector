global add_vector_double
section .text
extern malloc
extern free

;VectorDouble *add_vector_double(VectorDouble *v1, VectorDouble *v2);
;rdi = v1, rsi = v2
add_vector_double:

    ; [rdi] = v1.data
    ; [rdi + 8] = v1->len
    ; [rsi] = v2.data
    ; [rsi + 8] = v2->len

    push rbx
    push r12
    push r13
    push r14
    push r15

    ; use r14 and r15 to save paraments
    mov r14, rdi ; r14 = v1
    mov r15, rsi ; r15 = v2

    ; check v1 and v2
    test r14, r14
    jz null_ptr
    test r15, r15
    jz null_ptr

    ; check v1 and v2 length
    mov r13, [r14 + 8] ; rbx = v1->len
    cmp r13, [r15 + 8] ; judge v1->len is or not equal to v2->len
    jne null_ptr

    ; malloc for res, 16 byte
    mov rdi, 16
    call malloc wrt ..plt
    test rax, rax
    jz failed_res
    mov rbx, rax ; use rbx save the result, rax use new malloc

    ; malloc for data, len * 8 byte
    mov rdi, r13
    shl rdi, 3 ; sizeof(double) = 8
    call malloc wrt ..plt
    test rax, rax
    jz failed_data

    ; set the result value
    mov [rbx], rax ; result->data
    mov [rbx + 8], r13 ; result->len

    ; initialize 
    mov rdi, [r14] ; rdi = v1->data
    mov rsi, [r15] ; rsi = v2->data
    mov r12, [rbx] ; r12 = result->data
    xor rcx, rcx ; int i = 0

on_loop:
    cmp rcx, r13 ; i < len
    jge end

    movsd xmm0, [rdi + rcx * 8]
    addsd xmm0, [rsi + rcx * 8]
    movsd [r12 + rcx * 8], xmm0

    inc rcx ; i++
    jmp on_loop


end:
    mov rax, rbx
    jmp pop_data

failed_res:
    mov rax, 0
    jmp pop_data

failed_data:
    mov rdi, rbx
    call free wrt ..plt
    mov rax, 0
    jmp pop_data

null_ptr:
    mov rax, 0
    jmp pop_data

pop_data:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
