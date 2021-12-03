// 207375700 Racheli Lilach Lacham

.section .rodata
print_format: .string "%s"
invalid_input: .string "invalid input!\n"

.text
.global pstrlen
.global replaceChar
.global pstrijcpy
.global swapCase
.global pstrijcmp

pstrlen:
    movq $0, %rax
    mov (%rdi),%rax
    ret

 replaceChar:
    call pstrlen
    movzbq %al, %r8  # %r8 = len pstring
    movq %rdi, %rax
    leaq 1(%rdi), %rdi          #pointer on the string of pstring
    leaq (%rdi, %r8, 1),%rcx    # %rcx = end of pstring
    .l1:
        cmp %rdi, %rcx
        je .finish
        movb (%rdi), %r11b
        cmpb %sil, %r11b
        jnz .differ

        #change to the new char
        movb %dl ,(%rdi)
        leaq 1(%rdi), %rdi
        jmp .l1

    .differ:
        leaq 1(%rdi), %rdi
        jmp .l1
    .finish:
        ret

pstrijcpy:
    pushq %r12
    pushq %r13
    call pstrlen
    movzbq %al, %r12     # %r12 = len of dst pstring
    pushq %rdi
    movq %rsi, %rdi
    call pstrlen
    popq %rdi
    movzbq %al, %r13     # %r13 = len of the src pstring

    #check i <= j
    cmpb %dl, %cl
    js .invalidInput

    #check if len dst > j
    cmpb %cl, %r12b
    js .invalidInput
    jz .invalidInput
    #check if len src > j
    cmpb %cl, %r13b
    js .invalidInput
    jz .invalidInput
    #check if len dst > i
    cmpb %dl, %r12b
    js .invalidInput
    jz .invalidInput
    #check if len src > i
    cmpb %dl, %r13b
    js .invalidInput
    jz .invalidInput

    leaq 1(%rdi), %r8   # %r8 = pointer to dst string
    leaq 1(%rsi), %rsi  # %rsi = pointer to src string
    leaq (%r8, %rdx, 1), %r8    # %r8 = pointer to dst string in index i
    leaq (%rsi, %rdx, 1), %rsi  # %rsi = pointer to src string in index i
    leaq (%r8 ,%rcx, 1), %r9    # %r9 = pointer to dst string in index j
    leaq 1(%r9), %r9

    .l2:
        cmp %r9, %r8
        je .finish_pstrijcpy
        movb (%rsi), %r10b   #save the current char
        movb %r10b, (%r8)   #change the char of dst
        leaq 1(%r8), %r8
        leaq 1(%rsi), %rsi
        jmp .l2

    .invalidInput:
        movq $print_format, %rdi
        movq $invalid_input, %rsi
        xorq %rax, %rax
        call printf
        jmp .finish_pstrijcpy

    .finish_pstrijcpy:
        popq %r13
        popq %r12
        movq %rdi, %rax
        ret

swapCase:
    call pstrlen
    movzbq %al, %rsi  #%sil = len of pstring
    leaq 1(%rdi), %rdx  #%rdx = pointer to current char in str
    leaq (%rdx, %rsi, 1), %rcx  #%rcx = pointer to the end of pstring

    .l3:
        cmp %rdx, %rcx
        jz .finish_swapCase
        movb (%rdx), %r8b      #r8 = current char

        #check if big letter
        .big:
            cmp $65, %r8b       #if char < 65, not letter, go next char.
            js .next_char
            mov $90, %r9
            cmp %r8b, %r9b       #if char > 90, check if small letter.
            js .small
            add $32 ,%r8b
            mov %r8b, (%rdx)
            jmp .next_char

        .small:
            cmp $97, %r8b   #if char < 97, no letter, go next char
            js .next_char
            mov $122, %r9
            cmp %r8b, %r9b  # if char > 122, go next char
            js .next_char
            sub $32, %r8b
            mov %r8b, (%rdx)
            jmp .next_char

        .next_char:
            leaq 1(%rdx), %rdx
            jmp .l3

    .finish_swapCase:
        movq %rdi, %rax
        ret

pstrijcmp:
        pushq %r12
        pushq %r13
        call pstrlen
        movzbq %al, %r12     # %r12 = len of pstr1
        pushq %rdi
        movq %rsi, %rdi
        call pstrlen
        popq %rdi
        movzbq %al, %r13     # %r13 = len of pst2

        #check i <= j
        cmpb %dl, %cl
        js .invalidInputPstrijcmp

        #check if len pstr1 > j
        cmpb %cl, %r12b
        js .invalidInputPstrijcmp
        jz .invalidInputPstrijcmp
        #check if len pstr2 > j
        cmpb %cl, %r13b
        js .invalidInputPstrijcmp
        jz .invalidInputPstrijcmp
        #check if len pstr1 > i
        cmpb %dl, %r12b
        js .invalidInputPstrijcmp
        jz .invalidInputPstrijcmp
        #check if len pstr2 > i
        cmpb %dl, %r13b
        js .invalidInputPstrijcmp
        jz .invalidInputPstrijcmp

        # inceremnt the pointers to the atart of the strings
        leaq 1(%rdi), %rdi
        leaq 1(%rsi), %rsi
        #save pointer to the end of the compare
        leaq (%rdi, %rcx, 1), %r8   # %r8 = pointer to the end of the cmp for pstr1
        leaq 1(%r8), %r8

        # increment the pointers to index i
        leaq (%rdi, %rdx, 1), %rdi
        leaq (%rsi, %rdx, 1), %rsi

        .l4:
            cmp %rdi, %r8
            je .equal
            mov (%rdi), %r10
            mov (%rsi), %r11
            cmp %r10b, %r11b  #compare between the current chars
            je .increment       #chars are equals, continue to next chars
            jns .not_bigger     #char1 < char2
            mov $1, %rax        #char1 > char2
            jmp .finish_pstrijcmp

        .not_bigger:
            mov $-1, %rax
            jmp .finish_pstrijcmp

        .increment:
            leaq 1(%rdi), %rdi
            leaq 1(%rsi), %rsi
            jmp .l4

        .equal:
            mov $0, %rax
            jmp .finish_pstrijcmp

        .invalidInputPstrijcmp:
            movq $print_format, %rdi
            movq $invalid_input,%rsi
            xorq %rax, %rax
            call printf
            mov $-2, %rax
            jmp .finish_pstrijcmp

        .finish_pstrijcmp:
            popq %r13
            popq %r12
            ret