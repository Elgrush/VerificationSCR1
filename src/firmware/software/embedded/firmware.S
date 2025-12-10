.section .init

/* set stack pointer */
lui sp, %hi(_stack_end) //16*1024
addi sp, sp, %lo(_stack_end)

/* call main */
jal ra, main

/* break */
ebreak
