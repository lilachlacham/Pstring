.extern printf
.extern scanf

.section .rodata
scan_num: .string "%d"
scan_string: .string "%s"
print_format: .string "%s\n"

.section .text
.globl run_main
.type run_main, @function

run_main:
    pushq %rbp
    movq %rsp, %rbp
    #save place on stack for p1,p2,opt
    leaq -560(%rbp), %rsp
    #back up the calle save registers
    pushq %r14 # = p1
    pushq %r15 # = p2

    #get the len of the first string
    movq $scan_num, %rdi   #the first parameter to scanf
    leaq -560(%rbp), %rsi  #the seconed parameter to scanf
    xorq %rax, %rax
    call scanf
    movb -560(%rbp), %dl
    movb %dl, -545(%rbp)

    #get the first string
    movq $scan_string, %rdi  #the first parameter to scanf
    leaq -544(%rbp), %rsi    #the seconed parameter to scanf
    xorq %rax, %rax
    call scanf
    leaq -545(%rbp),%r14

    #get the len of the seconed string
    movq $scan_num, %rdi   #the first parameter to scanf
    leaq -288(%rbp), %rsi  #the seconed parameter to scanf
    xorq %rax, %rax
    call scanf
    movb -288(%rbp), %dl
    movb %dl, -273(%rbp)

    #get the seconed string
    movq $scan_string, %rdi  #the first parameter to scanf
    leaq -272(%rbp), %rsi    #the seconed parameter to scanf
    xorq %rax, %rax
    call scanf
    leaq -273(%rbp),%r14

    #get opt
    movq $scan_num, %rdi   #the first parameter to scanf
    leaq -16(%rbp), %rsi  #the seconed parameter to scanf
    xorq %rax, %rax
    call scanf

    #call run func
    movq -16(%rbp), %rdi
    movq %r14, %rsi
    movq %r15, %rdx
    #call run_func

    xorq %rax, %rax
    popq %r15
    popq %r14
    leaq 560(%rsp), %rsp
    popq %rbp
    ret
