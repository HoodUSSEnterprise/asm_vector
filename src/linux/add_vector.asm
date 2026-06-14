global add_vector_int
section .text
extern malloc
extern free

;VectorInt *add_vector_int(VectorInt *v1, VectorInt *v2);
;rcx = v1, rdx = v2
add_vector_int:

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

    ; malloc for data, len * 4 byte
    mov rdi, r13
    shl rdi, 2
    call malloc wrt ..plt
    test rax, rax
    jz failed_data

    ; set the result value
    mov [rbx], rax ; result->data
    mov [rbx + 8], r13 ; result->len

    ; initialize 
    mov r8, [r14] ; r8 = v1->data
    mov r9, [r15] ; r9 = v2->data
    mov r12, [rbx] ; r12 = result->data
    xor rcx, rcx ; int i = 0

on_loop:
    cmp rcx, r13 ; i < len
    jge end

    mov eax, [r8 + rcx * 4]
    add eax, [r9 + rcx * 4]
    mov [r12 + rcx * 4], eax

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
