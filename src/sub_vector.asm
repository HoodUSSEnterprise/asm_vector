global sub_vector_int
section .text
extern malloc
extern free

;VectorInt *sub_vector_int(VectorInt *v1, VectorInt *v2);
;rcx = v1, rdx = v2
sub_vector_int:

    ; [rcx] = v1.data
    ; [rcx + 8] = v1->len
    ; [rdx] = v2.data
    ; [rdx + 8] = v2->len
    ; 易失寄存器：rax, rcx, rdx, r8 - r11
    ; 非易失寄存器：rbx, rbp, rdi, rsi, r12 - r15 

    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15

    ; use r14 and r15 to save paraments
    mov r14, rcx ; r14 = v1
    mov r15, rdx ; r15 = v2

    ; check v1 and v2
    test r14, r14
    jz .null_ptr
    test r15, r15
    jz .null_ptr

    ; check v1 and v2 length
    mov r13, [r14 + 8] ; rbx = v1->len
    cmp r13, [r15 + 8] ; judge v1->len is or not equal to v2->len
    jne .null_ptr

    ; malloc for res, 16 byte
    mov rcx, 16
    call malloc
    test rax, rax
    jz .failed_res
    mov rbx, rax ; use rbx save the result, rax use new malloc

    ; malloc for data, len * 4 byte
    mov rcx, r13
    shl rcx, 2
    call malloc
    test rax, rax
    jz .failed_data

    ; set the result value
    mov [rbx], rax ; result->data
    mov [rbx + 8], r13 ; result->len

    ; initialize 
    mov rdi, [r14] ; rdi = v1->data
    mov rsi, [r15] ; rsi = v2->data
    mov r12, [rbx] ; r12 = result->data
    xor rcx, rcx ; int i = 0

.loop:
    cmp rcx, r13 ; i < len
    jge .end

    mov eax, [rdi + rcx * 4]
    sub eax, [rsi + rcx * 4]
    mov [r12 + rcx * 4], eax

    inc rcx ; i++
    jmp .loop


.end:
    mov rax, rbx
    jmp pop_data

.failed_res:
    mov rax, 0
    jmp pop_data

.failed_data:
    mov rcx, rbx
    call free
    mov rax, 0
    jmp pop_data

.null_ptr:
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