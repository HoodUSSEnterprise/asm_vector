global remove_vector
section .text
extern malloc
extern free

; bool remove_vector(MyVector *v, int removed_value);
; rcx = v, edx = removed_value

remove_vector:

    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15

    mov r14, rcx ; r14 = v
    mov r15d, edx ; r15d = removed_value
    mov r13, [rcx + 8] ; r13 = v->len

    xor rdi, rdi ; calc number of removed_value
    mov rsi, [r14] ; rsi = v->data
    xor rcx, rcx ; i = 0

calc_number:
    cmp rcx, r13 ; i < len
    jge next
    cmp [rsi + rcx * 4], r15d ; data[i] == removed_value
    je count_plus

    inc rcx
    jmp calc_number

count_plus:
    add rdi, 1 ; number + 1
    jmp calc_number

next:
    cmp rdi, 0
    je no
    cmp rdi, r13
    je zero

    ; malloc new res->data
    mov rcx, r13
    sub rcx, rdi
    call malloc
    test rax, rax
    jz failed_data

    mov rbx, rax ; rbx = new_data

    xor rcx, rcx ; i = 0
    xor rdx, rdx ; j = 0

change_value:
    cmp rcx, r13 ; i < len
    jge yes
    cmp [rsi + rcx * 4], r15d ; compare with every element in orgin array
    je change

    mov eax, [rsi + rcx * 4]
    mov [rbx + rdx * 4], eax
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
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    pop rbx
    ret