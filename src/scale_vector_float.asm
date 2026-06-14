global scale_vector_float
section .text
extern malloc
extern free

; VectorFloat *scale_vector_float(VectorFloat *v, float scale);
; rcx = v, edx = scale

scale_vector_float:

    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    ; use r14 and r15 to save paraments
    mov r14, rcx ; r14 = v1
    movss [rsp], xmm15
    movss xmm15, xmm1 ; xmm15 = scale
    mov r13, [rcx + 8] ; r3 = v1 -> len

    ; check v1 and v2
    test r14, r14
    jz null_ptr

    ; malloc for res, 16 byte
    mov rcx, 16
    call malloc
    ; judge is or not malloc success
    test rax, rax
    jz failed_res
    mov rbx, rax ; use rbx save the result, rax use new malloc

    ; malloc for data, len * 8 byte
    mov rcx, r13
    shl rcx, 2 ; rcx * 8
    call malloc
    ; judge is or not malloc success
    test rax, rax
    jz failed_data

    ; set the result value
    mov [rbx], rax ; result->data
    mov [rbx + 8], r13 ; result->len

    ; initialize 
    mov rdi, [r14] ; rdi = v1->data
    mov r12, [rbx] ; r12 = result->data
    xor rcx, rcx ; int i = 0

on_loop:
    cmp rcx, r13 ; i < len
    jge end

    movss xmm1, [rdi + rcx * 4]
    mulss xmm1, xmm15
    movss [r12 + rcx * 4], xmm1

    inc rcx ; i++
    jmp on_loop


end:
    mov rax, rbx
    jmp pop_data

failed_res:
    mov rax, 0
    jmp pop_data

failed_data:
    mov rcx, rbx
    call free
    mov rax, 0
    jmp pop_data

null_ptr:
    mov rax, 0
    jmp pop_data

pop_data:
    movss xmm15, [rsp]
    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    pop rbx
    ret