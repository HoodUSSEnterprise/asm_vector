global remove_vector_int
section .text
extern malloc
extern free

; bool remove_vector_int(VectorInt *v, int removed_value);
; rdi = v, esi = removed_value

remove_vector_int:

    push rbx
    push r12
    push r13
    push r14
    push r15

    mov r14, rdi ; r14 = v
    mov r15d, esi ; r15d = removed_value
    mov r13, [rdi + 8] ; r13 = v->len

    ; check paraments
    test r14, r14
    jz null_ptr

    mov r14, [rdi]

    ; check v->data
    test r14, r14
    jz null_ptr

    mov r14, rdi ; r14 = v
    
    mov r12, 0 ; calc number of removed_value
    mov rdx, [r14] ; r12 = v->data
    xor rcx, rcx ; i = 0

calc_number:
    cmp rcx, r13 ; i < len
    jge next
    cmp [rdx + rcx * 4], r15d ; data[i] == removed_value
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
    shl rdi, 2
    call malloc wrt ..plt
    test rax, rax
    jz failed_data

    mov rbx, rax ; rbx = new_data

    xor rcx, rcx ; i = 0
    xor rdx, rdx ; j = 0
    mov r8, [r14]

change_value:
    cmp rcx, r13 ; i < len
    jge yes
    cmp [r8 + rcx * 4], r15d ; compare with every element in orgin array
    je change

    mov eax, [r8 + rcx * 4]
    mov [rbx + rdx * 4], eax
    inc rdx ; j++
    inc rcx ; i++
    jmp change_value

change:
    inc rcx ; i++
    jmp change_value

no:
    mov rax, 0 ; return false
    jmp pop_data

yes:
    mov rdi, [r14]
    call free wrt ..plt
    mov [r14], rbx
    mov rdi, r13
    sub rdi, r12
    mov [r14 + 8], rdi
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
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
