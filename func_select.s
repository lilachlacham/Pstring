// 207375700 Racheli Lilach Lacham
.extern printf

.section .rodata
print_format: .string "%s"
scanf_char: .string " %c"
scanf_int: .string " %d"
invalid_option: .string "invalid option!\n"
pstrlen_format: .string "first pstring length: %d, second pstring length: %d\n"
replaceChar_format: .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
lenght_string_format: .string "length: %d, string: %s\n"
compare_format: .string "compare result: %d\n"


.section .text
.globl run_func
.type run_func, @function

run_func:
    pushq %rbx
    mov %rsp, %rbx
    and $-16, %rsp
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp
    pushq %r12
    pushq %r12
    pushq %r13 # = opt
    pushq %r14 # = p1
    pushq %r15 # = p2
    movq %rdi, %r13
    movq %rsi, %r14
    movq %rdx, %r15

#%r13 = opt
.switch_jt:
    subq $50, %r13  #increae 50 from opt
    cmpq $10, %r13
    ja .L11         #if opt > 10, go to default.
    jmp *.L12(, %r13,8)

    .L0:   #case 50 or 60
        movq %r14, %rdi
        call pstrlen
        movb %al, %r10b     #%r10 = len of p1
        movq %r15, %rdi
        call pstrlen
        movb %al, %r11b     #%r11 = len of p2
        movq $pstrlen_format, %rdi
        movzbq %r10b, %rsi
        movzbq %r11b, %rdx
        xorq %rax, %rax
        call printf
        jmp .finish

    .L2:   #case 52
        #get old char
        movq $scanf_char, %rdi
        leaq -16(%rbp), %rsi
        xorq %rax,%rax
        call scanf

        #get new char
        movq $scanf_char, %rdi
        leaq -32(%rbp), %rsi
        xorq %rax,%rax
        call scanf

        #set up for call replace char function for p1.
        leaq -16(%rbp), %r10    # %r10 = old char
        leaq -32(%rbp), %r11    # %r11 = new char
        movq %r14, %rdi
        movzbq (%r10), %rsi
        movzbq (%r11), %rdx
        call replaceChar
        movq %rax, %r12      # %r12 = new p1

        #set up for call replace char function for p2.
        leaq -16(%rbp), %r10    # %r10 = old char
        leaq -32(%rbp), %r11    # %r11 = new char
        movq %r15, %rdi
        movzbq (%r10), %rsi
        movzbq (%r11), %rdx
        call replaceChar
        movq %rax, %r13     # %r13 = new p2

        #set up for call printf
        movq $replaceChar_format, %rdi
        leaq -16(%rbp), %r10    # %r10 = old char
        leaq -32(%rbp), %r11    # %r11 = new char
        movzbq (%r10), %rsi
        movzbq (%r11), %rdx
        leaq 1(%r12), %rcx
        leaq 1(%r13), %r8
        xorq %rax, %rax
        call printf
        jmp .finish

    .L3:   #case 53
        #get start index
        movq $scanf_int, %rdi
        leaq -16(%rbp), %rsi  #pointer to i
        xorq %rax, %rax
        call scanf
        #get end index
        movq $scanf_int, %rdi
        leaq -32(%rbp), %rsi    #pointer to j
        xorq %rax, %rax
        call scanf

        # call pstrijcpy
        movq %r14, %rdi
        movq %r15, %rsi
        leaq -16(%rbp), %r12    #r12 = i
        leaq -32(%rbp), %r13    #r13 = j
        movzbq (%r12), %rdx
        movzbq (%r13), %rcx
        call pstrijcpy

        #call pstrlen for dst
        movq %r14, %rdi
        call pstrlen
        #call printf for dst
        movzbq %al, %rsi
        movq $lenght_string_format ,%rdi
        leaq 1(%r14), %rdx
        xorq %rax, %rax
        call printf

        #call pstrlen for src
        movq %r15, %rdi
        call pstrlen
        #call printf for src
        movzbq %al, %rsi
        movq $lenght_string_format ,%rdi
        leaq 1(%r15), %rdx
        xorq %rax, %rax
        call printf
        jmp .finish

    .L4:   #case 54
        #call pstrlen for p1
        movq %r14, %rdi
        call pstrlen
        movzbq %al, %r12    #r12 = len of p1

        #call swapCase with p1
        movq %r14, %rdi
        call swapCase

        #print new p1
        movq $lenght_string_format, %rdi
        movq %r12, %rsi
        leaq 1(%r14), %rdx
        xorq %rax, %rax
        call printf

        #call pstrlen for p2
        movq %r15, %rdi
        call pstrlen
        movzbq %al, %r12    #r12 = len of p2

        #call swapCase with p1
        movq %r15, %rdi
        call swapCase

        #print new p2
        movq $lenght_string_format, %rdi
        movq %r12, %rsi
        leaq 1(%r15), %rdx
        xorq %rax, %rax
        call printf
        jmp .finish

    .L5:   #case 55
        #get start index
        movq $scanf_int, %rdi
        leaq -16(%rbp), %rsi  #pointer to i
        xorq %rax, %rax
        call scanf
        #get end index
        movq $scanf_int, %rdi
        leaq -32(%rbp), %rsi    #pointer to j
        xorq %rax, %rax
        call scanf

        #call pstrijcmp
        mov %r14, %rdi
        mov %r15, %rsi
        leaq -16(%rbp), %r12
        leaq -32(%rbp), %r13
        movzbq (%r12), %rdx
        movzbq (%r13), %rcx
        call pstrijcmp

        #call printf
        mov $compare_format, %rdi
        mov %rax, %rsi
        xorq %rax, %rax
        call printf
        jmp .finish


    .L11:    #default
    #set up for printf function
    pushq %rdi
    movq $print_format, %rdi
    movq $invalid_option, %rsi
    xorq %rax, %rax
    call printf
    pop %rdi
    jmp .finish

    .L12:   #jump table
        .quad .L0  #case 50
        .quad .L11 #case 51 - default
        .quad .L2  #case 52
        .quad .L3  #case 53
        .quad .L4  #case 54
        .quad .L5  #case 55
        .quad .L11 #case 56 - default
        .quad .L11 #case 57 - default
        .quad .L11 #case 58 - default
        .quad .L11 #case 59 - default
        .quad .L0 #case 60

.finish:

    pop %r15
    pop %r14
    pop %r13
    pop %r12
    pop %r12
    mov %rbp, %rsp
    pop %rbp
    mov %rbx, %rsp
    pop %rbx
    xorq %rax, %rax
    ret
