global scale_vector_int
section .text
extern malloc
extern free

; VectorInt *scale_vector_int(VectorInt *v, int scale);
; rdi = v, esi = scale

scale_vector_int:

    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15

    ; use r14 and r15 to save paraments
    mov r14, rdi ; r14 = v1
    mov r15d, esi ; r15 = scale
    mov r13, [rdi + 8] ; r3 = v1 -> len

    ; check v1 and v2
    test r14, r14
    jz null_ptr

    mov r14, [rdi]

    ; check v->data
    test r14, r14
    jz pop_data

    mov r14, rdi ; r14 = v
    
    ; malloc for res, 16 byte
    mov rdi, 16
    call malloc wrt ..plt
    ; judge is or not malloc success
    test rax, rax
    jz failed_res
    mov rbx, rax ; use rbx save the result, rax use new malloc

    ; malloc for data, len * 4 byte
    mov rdi, r13
    shl rdi, 2 ; rdi * 4
    call malloc wrt ..plt
    ; judge is or not malloc success
    test rax, rax
    jz failed_data

    ; set the result value
    mov [rbx], rax ; result->data
    mov [rbx + 8], r13 ; result->len

    ; initialize 
    mov rdi, [r14] ; rdi = v1->data
    mov esi, r15d ; esi = scale
    mov r12, [rbx] ; r12 = result->data
    xor rcx, rcx ; int i = 0

on_loop:
    cmp rcx, r13 ; i < len
    jge end

    mov eax, [rdi + rcx * 4]
    imul eax, esi
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
    pop rsi
    pop rdi
    pop rbx
    ret
