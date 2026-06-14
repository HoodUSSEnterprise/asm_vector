global insert_vector_int
section .text
extern malloc
extern free

; bool insert_vector_int(VectorInt *v, size_t pos, int value);
; rdi = v, rsi = pos, edx = value
insert_vector_int:
    
    push rbx
    push r12
    push r13
    push r14
    push r15

    mov r14, rdi ; r14 = v
    mov r15, rsi ; r15 = pos
    mov r13d, edx ; r13d = value
    mov r8, [r14] ; r8 = v->data
    mov r12, [r14 + 8] ; r12 = v->len

    test r14, r14 ; jugde nullptr
    jz pop_data

    test r8, r8 ; jugde nullptr
    jz pop_data

    cmp r15, r12 ; judge parament, pos < v->len
    jge error_pos

    add r12, 1 ; v->len + 1
    mov rdi, r12 ; res->len
    shl rdi, 2 ; rdi *= 4
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

    mov eax, [r8 + rsi * 4]
    mov [rbx + rcx * 4], eax

    inc rcx ; i++
    inc rsi ; j++
    jmp insert_loop

insert_number:
    mov [rbx + rcx * 4], r13d
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
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
