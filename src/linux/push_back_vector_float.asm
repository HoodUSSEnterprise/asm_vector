global push_back_float
section .text
extern malloc
extern free

; void push_back_float(VectorFloat *v, float data);
; rdi = v, xmm0 = data
push_back_float:

    push rbx
    push r13
    push r14
    push r15
    sub rsp, 8

    movss [rsp], xmm15

    mov r14, rdi ; r14 = v
    mov r13, [rdi + 8] ; r13 = v->len
    movss xmm15, xmm0 ; r15d = data, because eax is 8 bytes(32 bits)

    ; check paraments
    test r14, r14
    jz null_ptr

    mov r14, [rdi]

    ; check v->data
    test r14, r14
    jz null_ptr

    mov r14, rdi ; r14 = v

    ; malloc for data
    mov rdi, r13 ; rcx = len
    add rdi, 1   ; rcx += 1;
    shl rdi, 2 ; sizeof(float) = 4, move left 2 bytes
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
    
    movss xmm0, [rdi + rcx * 4]
    movss [rbx + rcx * 4], xmm0

    inc rcx ; rcx++
    jmp on_loop

equal:
    movss [rbx + rcx * 4], xmm15

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
    movss xmm15, [rsp]
    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop rbx
    ret
