global mul_vector_int_dot, mul_vector_int_cross
section .text
extern malloc
extern free

; int mul_vector_int_dot(VectorInt *v1, VectorInt *v2);
; rdi = v1, rsi = v2
mul_vector_int_dot:
    push rbx
    push r12
    push r13
    push r14
    push r15

    ; save rdi and rsi
    mov r14, rdi ; r14 = v1
    mov r15, rsi ; r15 = v2

    ; check v1 and v2
    test r14, r14
    jz null_ptr_dot
    test r15, r15
    jz null_ptr_dot

    ; check v1 and v2 length
    mov r13, [r14 + 8] ; rbx = v1->len
    cmp r13, [r15 + 8] ; judge v1->len is or not equal to v2->len
    jne null_ptr_dot

    mov rcx, 0 ; i = 0
    mov rdi, [r14] ; rdi = v1->data
    mov rsi, [r15] ; rsi = v2->data
    xor eax, eax
    
on_loop:
    cmp rcx, r13 ; i < v1->len
    jge pop_data_dot
    
    mov ebx, [rdi + rcx * 4]
    imul ebx, [rsi + rcx * 4]
    add eax, ebx

    inc rcx ; i++
    jmp on_loop

null_ptr_dot:
    mov rax, 0x7FFFFFFF

pop_data_dot:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret

; VectorInt *mul_vector_int_cross(VectorInt *v1, VectorInt *v2);
; rdi = v1, rsi = v2
mul_vector_int_cross:
    push rbx
    push r12
    push r13
    push r14
    push r15

    ; save rdi and rsi
    mov r14, rdi ; r14 = v1
    mov r15, rsi ; r15 = v2

    ; check v1 and v2
    test r14, r14
    jz null_ptr_cross
    test r15, r15
    jz null_ptr_cross

    ; check v1 and v2 length
    mov r13, [r14 + 8] ; rbx = v1->len
    cmp r13, [r15 + 8] ; judge v1->len is or not equal to v2->len
    jne null_ptr_cross

    ; judge dim of vector, our cross only for 3 dim
    cmp [r14 + 8], 3
    jne null_ptr_cross
    cmp [r15 + 8], 3
    jne null_ptr_cross

    ; malloc for res, 16 byte
    mov rdi, 16
    call malloc wrt ..plt
    test rax, rax
    jz failed_res_cross
    mov rbx, rax ; use rbx save the result, rax use new malloc

    ; malloc for data, len * 4 byte
    mov rdi, r13 ; rdi = v1->len
    shl rdi, 2 ; rdi * 4
    call malloc wrt ..plt
    test rax, rax
    jz failed_data_cross

    ; set the result value
    mov [rbx], rax ; result->data
    mov [rbx + 8], r13 ; result->len

    ; initialize 
    mov rcx, 0 ; i = 0
    mov rdi, [r14] ; rdi = v1->data
    mov rsi, [r15] ; rsi = v2->data
    mov r12, [rbx] ; r12 = res->data
    
    ; res->data[0]
    mov r13, [rdi + 4] ; r13 = v1->data[1]
    imul r13, [rsi + 8] ; r13 *= v2->data[2]
    mov rax, [rdi + 8] ; rax = v1->data[2]
    imul rax, [rsi + 4] ; rax *= v2->data[1]
    sub r13, rax
    mov [r12], r13

    ; res->data[1]
    mov r13, [rdi + 8] ; r13 = v1->data[2]
    imul r13, [rsi] ; r13 *= v2->data[0]
    mov rax, [rdi] ; rax = v1->data[0]
    imul rax, [rsi + 8] ; rax *= v2->data[2]
    sub r13, rax
    mov [r12 + 4], r13

    ; res->data[2]
    mov r13, [rdi] ; r13 = v1->data[0]
    imul r13, [rsi + 4] ; r13 *= v2->data[1]
    mov rax, [rdi + 4] ; rax = v1->data[1]
    imul rax, [rsi] ; rax *= v2->data[0]
    sub r13, rax
    mov [r12 + 8], r13

    mov rax, rbx
    jmp pop_data_cross

null_ptr_cross:
    mov rax, 0x7FFFFFFF

failed_res_cross:
    mov rax, 0
    jmp pop_data_cross

failed_data_cross:
    mov rcx, rbx
    call free wrt ..plt
    mov rax, 0
    jmp pop_data_cross


pop_data_cross:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
