global insert_vector
section .text
extern malloc
extern free

; void insert_vector(MyVector *v, size_t pos, int value);
; rcx = v, rdx = pos, r8d = value
insert_vector:
    
    push rbx
    push rdi
    push rsi
    push r11
    push r12
    push r13
    push r14
    push r15

    mov r14, rcx ; r14 = v
    mov r15, rdx ; r15 = pos
    mov r13d, r8d ; r13d = value
    mov r11, [rcx] ; r11 = v->data
    mov r12, [rcx + 8] ; r14 = v->len

    sub r12, 1 ; v->len - 1
    cmp r15, r12 ; judge parament
    jge error_pos

    add r12, 2 ; v->len + 1
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

    mov eax, [r11 + rsi * 4]
    mov [rbx + rcx * 4], eax

    inc rcx ; i++
    inc rsi ; j++
    jmp insert_loop

insert_number:
    mov [rbx + rcx * 4], r13
    inc rcx
    jmp insert_loop

failed_data:
    mov rax, 0
    jmp pop_data

error_pos:
    mov rax, 0
    jmp pop_data

yes:
    mov rcx, [r14]
    call free
    mov [r14], rbx
    mov [r14 + 8], r12
    mov rax, 1
    
pop_data:
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop rsi
    pop rdi
    pop rbx
    ret