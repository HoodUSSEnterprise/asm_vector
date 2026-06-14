global insert_vector_double
section .text
extern malloc
extern free

; bool insert_vector_double(VectorDouble *v, size_t pos, double value);
; rdi = v, rsi = pos, xmm0 = value
insert_vector_double:
    
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    movsd [rsp], xmm15

    mov r14, rdi ; r14 = v
    mov r15, rsi ; r15 = pos
    movsd xmm15, xmm0 ; xmm15 = value
    mov r13, [r14] ; r13 = v->data
    mov r12, [r14 + 8] ; r12 = v->len

    test r14, r14 ; jugde nullptr
    jz pop_data

    test r13, r13 ; jugde nullptr
    jz pop_data

    cmp r15, r12 ; judge parament, pos < v->len
    jge error_pos

    add r12, 1 ; v->len + 1
    mov rdi, r12 ; res->len
    shl rdi, 3 ; rdi *= 8
    call malloc wrt ..plt
    test rax, rax ; judge is or not nullptr
    jz failed_data

    mov rbx, rax ; rbs = res->data

    xor rcx, rcx ; i = 0
    xor rsi, rsi ; j = 0

insert_loop:
    cmp rcx, r12 ; i < len
    jge yes

    cmp rcx, r15 ; insert pos
    je insert_number

    movsd xmm0, [r13 + rsi * 8]
    movsd [rbx + rcx * 8], xmm0

    inc rcx ; i++
    inc rsi ; j++
    jmp insert_loop

insert_number:
    movsd [rbx + rcx * 8], xmm15
    inc rcx
    jmp insert_loop

failed_data:
    mov rax, 0
    jmp pop_data

error_pos:
    mov rax, 0
    jmp pop_data

test_data:
    mov rax, 1
    jmp pop_data

yes:
    mov rdi, [r14]
    call free wrt ..plt
    mov [r14], rbx
    mov [r14 + 8], r12
    mov rax, 1
    
pop_data:
    movsd xmm15, [rsp]
    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
