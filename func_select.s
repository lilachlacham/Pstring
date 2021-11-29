.extern printf

.section .rodata
print_format: .string "%s\n"
invalid_option: .string "invalid option!\n"

.section .text
.globl func_select
.type func_select, @function

fun_select:
    pushq %rbp
    movq %rsp, %rbp

    #%rsi = n
    switch_jt:
    leaq -50(%rdi), %rsi  #increae 50 from n
    cmpq $10, %rsi
    ja .L11         #if n>10, go to default.
    jmp *.L12(, %rsi,8)

    .L2   #case 52

    .L3   #case 53

    .L4   #case 54

    .L5   #case 55

    .L11:    #default
    #set up for printf function
    pushq %rsi
    movq $print_pormat, %rdi
    movq $invalid_option, %rsi
    xorq %rax, %rax
    call printf
    pop %rsi

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

    pop %r12
    pop %rbp
