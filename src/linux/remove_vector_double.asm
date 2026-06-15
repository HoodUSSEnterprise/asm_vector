global remove_vector_double
section .text
extern malloc
extern free

; bool remove_vector_double(VectorDouble *v, double removed_value);
; rdi = v, xmm0 = removed_value

remove_vector_double:

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    movsd [rsp], xmm15

    mov r14, rdi ; r14 = v
    movsd xmm15, xmm0 ; xmm15 = removed_value
    mov r13, [rdi + 8] ; r13 = v->len

    ; check paraments
    test r14, r14
    jz null_ptr

    mov r14, [rdi]

    ; check v->data
    test r14, r14
    jz null_ptr

    mov r14, rdi ; r14 = v
    
    xor r12, r12 ; calc number of removed_value
    mov r15, [r14] ; r15 = v->data
    xor rcx, rcx ; i = 0

calc_number:
    cmp rcx, r13 ; i < len
    jge next
    movsd xmm0, [r15 + rcx * 8]
    ucomisd xmm0, xmm15 ; judge xmm0 and elem
    je count_plus

    inc rcx
    jmp calc_number

count_plus:
    add r12, 1 ; number + 1
    inc rcx
    jmp calc_number

next:
    cmp r12, 0
    je no
    cmp r12, r13
    je zero

    ; malloc new res->data
    mov rdi, r13
    sub rdi, r12
    shl rdi, 3
    call malloc wrt ..plt
    test rax, rax
    jz failed_data

    mov rbx, rax ; rbx = new_data

    xor rcx, rcx ; i = 0
    xor rdx, rdx ; j = 0

change_value:
    cmp rcx, r13 ; i < len
    jge yes
    movsd xmm2, [r15 + rcx * 8]
    ucomisd xmm2, xmm15 ; judge xmm0 and elem
    je change

    movsd xmm0, [r15 + rcx * 8]
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
    mov rdi, [r14]
    call free wrt ..plt
    mov [r14], rbx
    mov rcx, r13
    sub rcx, r12
    mov [r14 + 8], rcx
    jmp pop_data

zero:
    mov rdi, [r14]
    call free wrt ..plt
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
    pop rbx
    ret
