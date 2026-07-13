# Encoding Worksheet

One instruction is hand-encoded for each of the six RV32I formats by shifting fields to their bit positions and summing them. These values are verified in `part3_encoding.s` by decoding them back via shift-and-mask.

## Summary Table

| Format | Instruction | Hex Encoding |
| :--- | :--- | :--- |
| **R** | `add x6, x7, x8` | `0x00838333` |
| **I** | `addi x5, x1, -10` | `0xFF608293` |
| **S** | `sw x9, 8(x2)` | `0x00912423` |
| **B** | `beq x3, x4, 12` | `0x00418663` |
| **U** | `lui x10, 0x12345` | `0x12345537` |
| **J** | `jal x1, 16` | `0x010000EF` |

---

## Compact Derivations

### 1. R-Type: `add x6, x7, x8`
* **Fields:** `funct7` = 0, `rs2` = 8, `rs1` = 7, `funct3` = 0, `rd` = 6, `opcode` = `0x33`

### 2. I-Type: `addi x5, x1, -10`
* **Fields:** `imm` = `-10` (`0xFF6`), `rs1` = 1, `funct3` = 0, `rd` = 5, `opcode` = `0x13`

### 3. S-Type: `sw x9, 8(x2)`
* **Fields:** `imm[11:5]` = 0, `rs2` = 9, `rs1` = 2, `funct3` = 2, `imm[4:0]` = 8, `opcode` = `0x23`

### 4. B-Type: `beq x3, x4, 12`
* **Fields:** `imm` = 12 (`0b01100`), `rs2` = 4, `rs1` = 3, `funct3` = 0, `opcode` = `0x63`
* **Bit mapping:** `imm[12]` = 0, `imm[10:5]` = 0, `imm[4:1]` = 6, `imm[11]` = 0

### 5. U-Type: `lui x10, 0x12345`
* **Fields:** `imm[31:12]` = `0x12345`, `rd` = 10, `opcode` = `0x37`

### 6. J-Type: `jal x1, 16`
* **Fields:** `imm` = 16 (`0b10000`), `rd` = 1, `opcode` = `0x6F`
* **Bit mapping:** `imm[20]` = 0, `imm[10:1]` = 8, `imm[11]` = 0, `imm[19:12]` = 0
