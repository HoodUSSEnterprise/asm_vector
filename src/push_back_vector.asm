global push_back_int
section .text
extern malloc
extern free

; void push_back_int(VectorInt *v, int data);
; rcx = v, rdx = data
push_back_int:

    push rbx
    push rdi
    push rsi
    push r13
    push r14
    push r15

    mov r14, rcx ; r14 = v
    mov r13, [rcx + 8] ; r13 = v->len
    mov r15d, edx ; r15d = data, because eax is 4 bytes(32 bits)

    ; check paraments
    test r14, r14
    jz null_ptr

    ; malloc for data
    mov rcx, r13 ; rcx = len
    add rcx, 1   ; rcx += 1;
    shl rcx, 2 ; sizeof(int) = 4, move left 2 bytes
    call malloc
    test rax, rax
    jz failed_data

    ; save the malloc res->data
    mov rbx, rax

    ; new data
    mov rdi, [r14] ; v->data
    xor rcx, rcx   ; rcx = 0

.loop:
    cmp rcx, r13 ; judge is great than len
    jg pop_data
    cmp rcx, r13 ; arr index is less than length by 1, so we can use this number
    je equal
    
    mov eax, [rdi + rcx * 4] ; use eax 32 bytes in order to fit int
    mov [rbx + rcx * 4], eax

    inc rcx ; rcx++
    jmp .loop

equal:
    mov [rbx + rcx * 4], r15d

    ; free before data
    mov rcx, [r14]
    call free
    mov [r14], rbx
    add r13, 1
    mov [r14 + 8], r13
    jmp pop_data

failed_data:
    jmp pop_data

null_ptr:
    jmp pop_data

pop_data:
    pop r15
    pop r14
    pop r13
    pop rsi
    pop rdi
    pop rbx
    ret
