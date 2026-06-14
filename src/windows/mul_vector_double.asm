global mul_vector_double_dot, mul_vector_double_cross
section .text
extern malloc
extern free

; double mul_vector_double_dot(VectorDouble *v1, VectorDouble *v2);
; rcx = v1, rdx = v2
mul_vector_double_dot:
    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15

    ; save rcx and rdx
    mov r14, rcx ; r14 = v1
    mov r15, rdx ; r15 = v2

    ; check v1 and v2
    test r14, r14
    jz null_ptr_dot
    test r15, r15
    jz null_ptr_dot

    ; check v1->data and v2->data
    test r14, r14
    jz null_ptr_dot
    test r15, r15
    jz null_ptr_dot

    ; restore r14 and r15
    mov r14, rcx ; r14 = v1
    mov r15, rdx ; r15 = v2

    ; check v1 and v2 length
    mov r13, [r14 + 8] ; rbx = v1->len
    cmp r13, [r15 + 8] ; judge v1->len is or not equal to v2->len
    jne null_ptr_dot

    mov rcx, 0 ; i = 0
    mov rdi, [r14] ; rdi = v1->data
    mov rsi, [r15] ; rsi = v2->data
    xorpd xmm0, xmm0

on_loop:
    cmp rcx, r13 ; i < v1->len
    jge pop_data_dot
    
    movsd xmm1, [rdi + rcx * 8]
    mulsd xmm1, [rsi + rcx * 8]
    addsd xmm0, xmm1

    inc rcx ; i++
    jmp on_loop

null_ptr_dot:
    mov rax, 0x7FFFFFFF        ; rax = INT_MAX
    cvtsi2sd xmm0, rax         ; rax to double 

pop_data_dot:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    pop rbx
    ret

; VectorDouble *mul_vector_double_cross(VectorDouble *v1, VectorDouble *v2);
; rcx = v1, rdx = v2
mul_vector_double_cross:
    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15

    ; save rcx and rdx
    mov r14, rcx ; r14 = v1
    mov r15, rdx ; r15 = v2

    ; check v1 and v2
    test r14, r14
    jz null_ptr_cross
    test r15, r15
    jz null_ptr_cross

    ; check v1->data and v2->data
    test r14, r14
    jz null_ptr_cross
    test r15, r15
    jz null_ptr_cross

    ; restore r14 and r15
    mov r14, rcx ; r14 = v1
    mov r15, rdx ; r15 = v2

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
    mov rcx, 16
    call malloc
    test rax, rax
    jz failed_res_cross
    mov rbx, rax ; use rbx save the result, rax use new malloc

    ; malloc for data, len * 8 byte
    mov rcx, r13 ; rcx = v1->len
    shl rcx, 3 ; rcx * 8
    call malloc
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
    movsd xmm1, [rdi + 8] ; xmm1 = v1->data[1]
    mulsd xmm1, [rsi + 16] ; xmm1 *= v2->data[2]
    movsd xmm0, [rdi + 16] ; xmm0 = v1->data[2]
    mulsd xmm0, [rsi + 8] ; xmm0 *= v2->data[1]
    subsd xmm1, xmm0
    movsd [r12], xmm1

    ; res->data[1]
    movsd xmm1, [rdi + 16] ; xmm1 = v1->data[2]
    mulsd xmm1, [rsi] ; xmm1 *= v2->data[0]
    movsd xmm0, [rdi] ; xmm0 = v1->data[0]
    mulsd xmm0, [rsi + 16] ; xmm0 *= v2->data[2]
    subsd xmm1, xmm0
    movsd [r12 + 8], xmm1

    ; res->data[2]
    movsd xmm1, [rdi] ; xmm1 = v1->data[0]
    mulsd xmm1, [rsi + 8] ; xmm1 *= v2->data[1]
    movsd xmm0, [rdi + 8] ; xmm0 = v1->data[1]
    mulsd xmm0, [rsi] ; xmm0 *= v2->data[0]
    subsd xmm1, xmm0
    movsd [r12 + 16], xmm1

    mov rax, rbx
    jmp pop_data_cross

null_ptr_cross:
    mov rax, 0
    jmp pop_data_cross

failed_res_cross:
    mov rax, 0
    jmp pop_data_cross

failed_data_cross:
    mov rcx, rbx
    call free
    mov rax, 0
    jmp pop_data_cross


pop_data_cross:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    pop rbx
    ret
