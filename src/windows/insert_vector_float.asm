global insert_vector_float
section .text
extern malloc
extern free

; bool insert_vector_float(VectorFloat *v, size_t pos, float value);
; rcx = v, rdx = pos, xmm2 = value
insert_vector_float:
    
    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    movss [rsp], xmm15

    mov r14, rcx ; r14 = v
    mov r15, rdx ; r15 = pos
    movss xmm15, xmm2 ; xmm15 = value
    mov rdi, [r14] ; rdi = v->data
    mov r12, [r14 + 8] ; r12 = v->len

    test r14, r14 ; jugde nullptr
    jz pop_data

    test rdi, rdi ; jugde nullptr
    jz pop_data

    cmp r15, r12 ; judge parament, pos < v->len
    jge error_pos

    add r12, 1 ; v->len + 1
    mov rcx, r12 ; res->len
    shl rcx, 2 ; rcx *= 4
    call malloc
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

    movss xmm0, [rdi + rsi * 4]
    movss [rbx + rcx * 4], xmm0

    inc rcx ; i++
    inc rsi ; j++
    jmp insert_loop

insert_number:
    movss [rbx + rcx * 4], xmm15
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
    mov rcx, [r14]
    call free
    mov [r14], rbx
    mov [r14 + 8], r12
    mov rax, 1
    
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