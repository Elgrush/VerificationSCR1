.section .init
.global main

/* set stack pointer */
lui sp, %hi(4096) //16*1024
addi sp, sp, %lo(4096)

/* call main */
jal ra, main

/* break */
ebreak
