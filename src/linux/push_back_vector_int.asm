global push_back_int
section .text
extern malloc
extern free

; void push_back_int(VectorInt *v, int data);
; rdi = v, esi = data
push_back_int:

    push rbx
    push r13
    push r14
    push r15

    mov r14, rdi ; r14 = v
    mov r13, [rdi + 8] ; r13 = v->len
    mov r15d, esi ; r15d = data, because eax is 4 bytes(32 bits)

    ; check paraments
    test r14, r14
    jz null_ptr

    ; malloc for data
    mov rdi, r13 ; rdi = len
    add rdi, 1   ; rdi += 1;
    shl rdi, 2 ; sizeof(int) = 4, move left 2 bytes
    call malloc wrt ..plt
    test rax, rax
    jz failed_data

    ; save the malloc res->data
    mov rbx, rax

    ; new data
    mov rdi, [r14] ; v->data
    xor rcx, rcx   ; rcx = 0

on_loop:
    cmp rcx, r13 ; judge is great than len
    jg pop_data
    cmp rcx, r13 ; arr index is less than length by 1, so we can use this number
    je equal
    
    mov eax, [rdi + rcx * 4] ; use eax 32 bytes in order to fit int
    mov [rbx + rcx * 4], eax

    inc rcx ; rcx++
    jmp on_loop

equal:
    mov [rbx + rcx * 4], r15d

    ; free before data
    mov rdi, [r14]
    call free wrt ..plt
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
    pop rbx
    ret
