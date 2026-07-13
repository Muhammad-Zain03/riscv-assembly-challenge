# RISC-V Extension Summary

## Architecture & Overview
The **RISC-V Compressed (C) Extension** enhances the base integer ISA by adding 16-bit short-form instruction encodings alongside standard 32-bit operations. Its primary purpose is to shrink memory footprints without changing the underlying programming model or processor logic. During execution, hardware decode units automatically expand the 16-bit instructions into their native 32-bit RV32I equivalents, preserving transparent compatibility across all 32 general-purpose registers.

## Code Size Savings & Impact
Standard RV32I forces every instruction to occupy four bytes. By compressing high-frequency commands into two bytes, the C extension achieves an approximate **25% reduction in overall code size**. This modular addition adheres to the core RISC-V design philosophy of simplicity—optimizing storage efficiency without complicating execution pipelines.

## Key Instructions
The extension focuses on instructions that dominate compiled binaries, particularly basic math, control flow, and stack manipulation:
* `c.lwsp` / `c.swsp` – Word loads/stores using implicit stack pointer (`sp`) addressing, heavily reducing function prologue and epilogue overhead.
* `c.lw` / `c.sw` – Compact word memory access utilizing a popular subset of general registers.
* `c.addi` – 16-bit immediate addition, frequently used for incrementing loop counters.
* `c.mv` – Fast register-to-register data copying.
* `c.li` / `c.lui` – Compact loading of small constants and upper address bits.
* `c.beqz` / `c.bnez` – Short-range zero-evaluation branches (`== 0` or `!= 0`) for loop and conditional logic.
* `c.j` / `c.jr` / `c.jalr` – 16-bit unconditional jumps, register-indirect jumps, and subroutine returns.

## Real-World Applications
* **Embedded & IoT Devices:** Shorter code allows firmware to fit into smaller, less expensive on-chip Flash and SRAM, reducing hardware manufacturing costs.
* **Performance & Cache Efficiency:** Fetching 16-bit instructions doubles the number of commands retrieved per memory cycle. This drastically increases Instruction Cache (I-cache) hit rates and lowers system bus power consumption.
* **Industry Standards:** Because of its massive efficiency gains, the C extension is a mandatory baseline requirement in modern application processor specifications like the **RVA23 profile** for Linux systems.
