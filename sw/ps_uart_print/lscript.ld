/* Bare-metal link layout for the PS stream monitor.
 *
 * The ELF is downloaded by XSCT into DDR (initialized by ps7_init), so
 * load and run addresses are identical and no data copy is needed.
 * Application sits at 256 MB; DMA ping-pong buffers at 272 MB, inside
 * the S_AXI_HP0 DDR window (0x0..0x1FFFFFFF) and far from the app.
 */

ENTRY(_start)

MEMORY
{
    APP (rwx) : ORIGIN = 0x10000000, LENGTH = 2M
    DMA (rw)  : ORIGIN = 0x11000000, LENGTH = 64K
}

SECTIONS
{
    .vectors : { KEEP(*(.vectors)) } > APP

    .text : {
        *(.text*)
        . = ALIGN(4);
    } > APP

    .rodata : {
        *(.rodata*)
        . = ALIGN(4);
    } > APP

    .data : {
        __data_start = .;
        *(.data*)
        __data_end = .;
        . = ALIGN(4);
    } > APP

    .bss (NOLOAD) : {
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        __bss_end = .;
        . = ALIGN(4);
    } > APP

    .dma_buffer (NOLOAD) : ALIGN(4096) {
        __dma_buf = .;
        . += 0x2000;               /* 2 x 4096-byte ping-pong buffers */
        __dma_buf_end = .;
    } > DMA

    __stack_top = ORIGIN(APP) + LENGTH(APP) - 16;
}
