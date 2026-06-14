global remove_vector_double
section .text
extern malloc
extern free

; bool remove_vector_double(VectorDouble *v, double removed_value);
; rcx = v, xmm1 = removed_value

remove_vector_double:

    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    movsd [rsp], xmm15

    mov r14, rcx ; r14 = v
    movsd xmm15, xmm1 ; xmm15 = removed_value
    mov r13, [rcx + 8] ; r13 = v->len

    xor rdi, rdi ; calc number of removed_value
    mov rsi, [r14] ; rsi = v->data
    xor rcx, rcx ; i = 0

calc_number:
    cmp rcx, r13 ; i < len
    jge next
    movsd xmm0, [rsi + rcx * 8]
    ucomisd xmm0, xmm15 ; judge xmm0 and elem
    je count_plus

    inc rcx
    jmp calc_number

count_plus:
    add rdi, 1 ; number + 1
    inc rcx
    jmp calc_number

next:
    cmp rdi, 0
    je no
    cmp rdi, r13
    je zero

    ; malloc new res->data
    mov rcx, r13
    sub rcx, rdi
    shl rcx, 3
    call malloc
    test rax, rax
    jz failed_data

    mov rbx, rax ; rbx = new_data

    xor rcx, rcx ; i = 0
    xor rdx, rdx ; j = 0

change_value:
    cmp rcx, r13 ; i < len
    jge yes
    movsd xmm2, [rsi + rcx * 8]
    ucomisd xmm2, xmm15 ; judge xmm0 and elem
    je change

    movsd xmm0, [rsi + rcx * 8]
    movsd [rbx + rdx * 8], xmm0
    inc rdx ; j++
    inc rcx ; i++
    jmp change_value

change:
    inc rcx ; j++
    jmp change_value

no:
    mov rax, 0 ; return false
    jmp pop_data

yes:
    mov rcx, [r14]
    call free
    mov [r14], rbx
    mov rcx, r13
    sub rcx, rdi
    mov [r14 + 8], rcx
    jmp pop_data

zero:
    mov rcx, [r14]
    call free
    mov qword [r14], 0
    mov qword [r14 + 8], 0 ; zreo vector means len = 0
    mov rax, 1 ; return true
    jmp pop_data

failed_data:
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