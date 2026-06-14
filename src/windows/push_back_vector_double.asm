global push_back_double
section .text
extern malloc
extern free

; void push_back_double(VectorDouble *v, double data);
; rcx = v, xmm0 = data
push_back_double:

    push rbx
    push rdi
    push rsi
    push r13
    push r14
    push r15
    sub rsp, 8

    movsd [rsp], xmm15

    mov r14, rcx ; r14 = v
    mov r13, [rcx + 8] ; r13 = v->len
    movsd xmm15, xmm1 ; r15d = data, because eax is 8 bytes(32 bits)

    ; check paraments
    test r14, r14
    jz null_ptr

    mov r14, [rcx]
    
    test r14, r14
    jz null_ptr
    
    mov r14, rcx

    ; malloc for data
    mov rcx, r13 ; rcx = len
    add rcx, 1   ; rcx += 1;
    shl rcx, 3 ; sizeof(int) = 4, move left 2 bytes
    call malloc
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
    
    movsd xmm0, [rdi + rcx * 8]
    movsd [rbx + rcx * 8], xmm0

    inc rcx ; rcx++
    jmp on_loop

equal:
    movsd [rbx + rcx * 8], xmm15

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
    movsd xmm15, [rsp]
    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop rsi
    pop rdi
    pop rbx
    ret
