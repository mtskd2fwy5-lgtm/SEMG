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
    APP (rwx) : ORIGIN = 0x10000000, LENGTH = 4M
    DMA (rw)  : ORIGIN = 0x11000000, LENGTH = 1M
    LEARNING (rw) : ORIGIN = 0x11100000, LENGTH = 4K
    HDC (rw)  : ORIGIN = 0x12000000, LENGTH = 64M
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
        . += 0x100000;             /* 128 x 8 KB acquisition buffers */
        __dma_buf_end = .;
    } > DMA

    .learning_scratch (NOLOAD) : ALIGN(4096) {
        __learning_scratch = .; . += 0x1000;
    } > LEARNING

    .hdc_storage (NOLOAD) : ALIGN(4096) {
        __hdc_bank0 = .; . += 0x2000000;
        __hdc_bank1 = .; . += 0x2000000;
        __hdc_storage_end = .;
    } > HDC

    __stack_top = ORIGIN(APP) + LENGTH(APP) - 16;
    ASSERT(__bss_end + 0x10000 < __stack_top, "APP leaves less than 64 KiB stack")
}
