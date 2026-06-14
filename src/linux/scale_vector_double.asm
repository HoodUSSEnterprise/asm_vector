global scale_vector_double
section .text
extern malloc
extern free

; VectorDouble *scale_vector_double(VectorDouble *v, double scale);
; rdi = v, xmm0 = scale

scale_vector_double:

    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    ; use r14 and r15 to save paraments
    mov r14, rdi ; r14 = v1
    movsd [rsp], xmm15
    movsd xmm15, xmm0 ; xmm15 = scale
    mov r13, [rdi + 8] ; r3 = v1 -> len

    ; check v1 and v2
    test r14, r14
    jz null_ptr

    ; malloc for res, 16 byte
    mov rdi, 16
    call malloc wrt ..plt
    ; judge is or not malloc success
    test rax, rax
    jz failed_res
    mov rbx, rax ; use rbx save the result, rax use new malloc

    ; malloc for data, len * 8 byte
    mov rdi, r13
    shl rdi, 3 ; rdi * 8
    call malloc wrt ..plt
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

    movsd xmm1, [rdi + rcx * 8]
    mulsd xmm1, xmm15
    movsd [r12 + rcx * 8], xmm1

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
    call free wrt ..plt
    mov rax, 0
    jmp pop_data

null_ptr:
    mov rax, 0
    jmp pop_data

pop_data:
    movsd xmm15, [rsp]
    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    pop rbx
    ret
