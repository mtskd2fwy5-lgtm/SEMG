/* Cortex-A9 identity mapping for the existing freestanding application.
 * Attribute encodings follow AMD standalone_v9_4 cortexa9/xil_mmu.h:
 * DDR (including PL-owned HDC and learning scratch) is normal noncacheable;
 * APP and the 6 MB framebuffer reserve
 * use INNER write-back, OUTER noncacheable (0x14de6). Thus no L2 cache
 * maintenance is needed, and EMG DMA @ 0x11000000 stays noncacheable.
 */
    .arm
    .section .text, "ax"
    .global display_memory_prepare
display_memory_prepare:
    cpsid if
    /* Clean/invalidate L1 by set/way before changing inherited attributes.
     * A9 implements 4 ways; derive its set count and line size from CCSIDR.
     * No stack accesses while disabling the inherited mapping/cache.
     */
    mov r0, #0
    mcr p15, 2, r0, c0, c0, 0
    isb
    mrc p15, 1, r1, c0, c0, 0
    ubfx r2, r1, #13, #15
    and r3, r1, #7
    add r3, r3, #4
    mov r4, #3
1:  mov r5, r2
2:  lsl r6, r4, #30
    orr r6, r6, r5, lsl r3
    mcr p15, 0, r6, c7, c14, 2
    subs r5, r5, #1
    bpl 2b
    subs r4, r4, #1
    bpl 1b
    dsb sy
    mrc p15, 0, r0, c1, c0, 0
    bic r0, r0, #5              /* M, C */
    bic r0, r0, #0x1000         /* I */
    mcr p15, 0, r0, c1, c0, 0
    isb
    mov r0, #0
    mcr p15, 0, r0, c7, c5, 0  /* invalidate I cache */
    mcr p15, 0, r0, c7, c5, 6  /* invalidate branch predictor */
    mcr p15, 0, r0, c8, c7, 0  /* invalidate unified TLB */
    dsb sy
    isb
    bx lr

    .global display_memory_init
display_memory_init:
    /* Shareable inner-cacheable sections require ACTLR.SMP, as in AMD boot.S. */
    ldr r0, =0xf8f00000
    ldr r1, [r0]
    orr r1, r1, #1
    str r1, [r0]
    mrc p15, 0, r0, c1, c0, 1
    orr r0, r0, #0x41
    mcr p15, 0, r0, c1, c0, 1
    mov r0, #0
    mcr p15, 0, r0, c2, c0, 2  /* TTBCR: entire VA space uses TTBR0 */
    ldr r0, =display_mmu_table
    mcr p15, 0, r0, c2, c0, 0
    mvn r0, #0
    mcr p15, 0, r0, c3, c0, 0  /* all domains manager, BSP convention */
    ldr r0, =_start
    mcr p15, 0, r0, c12, c0, 0 /* VBAR */
    mrc p15, 0, r0, c1, c0, 0
    bic r0, r0, #0x10000000     /* TRE=0: use descriptor TEX/C/B */
    bic r0, r0, #0x20000000     /* AFE=0 */
    bic r0, r0, #0x2000         /* V=0: use VBAR */
    orr r0, r0, #0x800000       /* XP=1: extended section descriptors */
    orr r0, r0, #0x1000         /* I=1 */
    orr r0, r0, #5              /* M=1, C=1 */
    dsb sy
    mcr p15, 0, r0, c1, c0, 0
    isb
    bx lr

    /* Clean each modified cache line to DDR before handing a frame to VDMA.
     * r0 = address, r1 = bytes; called in small slices at runtime.
     */
    .global display_memory_clean
display_memory_clean:
    add r1, r0, r1
    bic r0, r0, #31
1:  cmp r0, r1
    bhs 2f
    mcr p15, 0, r0, c7, c10, 1
    add r0, r0, #32
    b 1b
2:  dsb sy
    bx lr

    .section .rodata.mmu, "a"
    .balign 16384
display_mmu_table:
    .set section_number, 0
    .rept 4096
    .if (section_number == 0x100) || (section_number == 0x101) || ((section_number >= 0x180) && (section_number < 0x186))
    .word (section_number << 20) | 0x14de6
    .elseif section_number < 0x400
    .word (section_number << 20) | 0x11de2
    .else
    .word (section_number << 20) | 0xc06
    .endif
    .set section_number, section_number + 1
    .endr
