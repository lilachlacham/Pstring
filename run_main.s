.section .rodata
scan_num: .string "%d"
scan_string: .string "%s"

.section .text
.globl run_main
.type run_main, @function

run_main:
    pushq %rbp
    movq %rsp, %rbp

    movq $0, %rax
    movq $scan_num, %rdi
    subq $4, %rsp
    movq %rsp, %rsi
    call scanf
    movl (%rsp), %edx
    addq $4, %rsp

    movq $0, %rax
    movq $scan_string, %rdi
    subq 255, %rsp
    movq %rsp, %rsi
    call scanf
    


    movq %rbp, %rsp
    popq %rbp
    ret




