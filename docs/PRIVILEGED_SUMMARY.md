# RISC-V Privileged Architecture

## 1. Privilege Modes
* **M-Mode (Machine - `11`):** Mandatory, highest privilege mode used for low-level firmware and bare-metal execution.
* **H-Mode (Hypervisor - `10`):** Optional virtualization layer for running Type-1 virtual machine monitors.
* **S-Mode (Supervisor - `01`):** Optional operating system layer that manages demand-paged virtual memory and handles `ecall` requests.
* **U-Mode (User - `00`):** Optional, lowest privilege mode for application code.

---

## 2. Essential Machine CSRs
* **`mstatus`:** Controls general operating state, global interrupt enables (`MIE`), previous mode (`MPP`), and virtual memory (`VM`).
* **`mtvec`:** Stores the base memory address of the trap handler vector.
* **`mepc`:** Automatically captures the Program Counter (`PC`) of the interrupted or faulting instruction.
* **`mcause`:** Indicates the trap trigger event, where the most significant bit distinguishes interrupts (`1`) from exceptions (`0`).
* **`mbadaddr` / `mtval`:** Records supplementary trap data such as the faulting memory address.

---

## 3. Trap Handling Workflow
* **Hardware Entry (Automatic):** Saves `PC` into `mepc`, copies active mode into `MPP`, disables interrupts (`MIE=0`), elevates mode to M, and jumps to `mtvec`.
* **Software Handler:** Saves integer registers to the stack, reads `mcause` to service the event, increments `mepc` by 4 for synchronous calls (`ecall`), and restores registers.
* **Hardware Exit (`mret`):** Restores interrupts (`MIE=MPIE`), restores privilege mode from `MPP`, and resumes execution by jumping to `mepc`.
