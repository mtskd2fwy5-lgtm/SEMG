/* Minimal Cortex-A9 bare-metal startup: vectors, BSS clear, stack, main. */

    .arm
    .section .vectors, "ax"
    .global _start
_start:
    b   reset               /* 0x00 reset */
    b   .                   /* 0x04 undefined */
    b   .                   /* 0x08 swi */
    b   .                   /* 0x0c prefetch abort */
    b   .                   /* 0x10 data abort */
    b   .                   /* 0x14 reserved */
    b   .                   /* 0x18 irq (unused, polled design) */
    b   .                   /* 0x1c fiq */

    .section .text, "ax"
reset:
    /* clear .bss (the DMA buffers live outside .bss and are NOT cleared) */
    ldr r0, =__bss_start
    ldr r1, =__bss_end
    mov r2, #0
1:  cmp r0, r1
    strlo r2, [r0], #4
    blo 1b

    ldr sp, =__stack_top
    bl  main

hang:
    b   hang
