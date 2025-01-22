// mem_cap
`define MEM_CAP_BYTE   67108864    

// selecter
// alu_in1_sel
`define ALU_IN1_SEL_RS1_DATA    1'b0
`define ALU_IN1_SEL_PC          1'b1
`define ALU_IN1_SEL_X           1'bx
// alu_in2_sel
`define ALU_IN2_SEL_RS2_DATA    1'b0
`define ALU_IN2_SEL_IMM         1'b1
`define ALU_IN2_SEL_X           1'bx
// alu_sel # RV32I
// `define ALU_SEL_ADD    4'b0000
// `define ALU_SEL_SUB    4'b1000
// `define ALU_SEL_SLL    4'b0001
// `define ALU_SEL_SLT    4'b0010
// `define ALU_SEL_SLTU   4'b0011
// `define ALU_SEL_XOR    4'b0100
// `define ALU_SEL_SRL    4'b0101
// `define ALU_SEL_SRA    4'b1101
// `define ALU_SEL_OR     4'b0110
// `define ALU_SEL_AND    4'b0111
// `define ALU_SEL_X      4'bx

// alu_sel RV32I
`define ALU_SEL_ADD    6'b000000
`define ALU_SEL_SUB    6'b001000
`define ALU_SEL_SLL    6'b000001
`define ALU_SEL_SLT    6'b000010
`define ALU_SEL_SLTU   6'b000011
`define ALU_SEL_XOR    6'b000100
`define ALU_SEL_SRL    6'b000101
`define ALU_SEL_SRA    6'b001101
`define ALU_SEL_OR     6'b000110
`define ALU_SEL_AND    6'b000111
// M Extension
`define ALU_SEL_MUL    6'b010000
`define ALU_SEL_MULH   6'b010001
`define ALU_SEL_MULHSU 6'b010010
`define ALU_SEL_MULHU  6'b010011
`define ALU_SEL_DIV    6'b010100
`define ALU_SEL_DIVU   6'b010101
`define ALU_SEL_REM    6'b010110
`define ALU_SEL_REMU   6'b010111
// B Extension
`define ALU_SEL_ANDN      6'b011000  // AND NOT
`define ALU_SEL_ORN       6'b011001  // OR NOT
`define ALU_SEL_XNOR      6'b011010  // XOR NOT
`define ALU_SEL_CLZ       6'b011011  // Count Leading Zeros
`define ALU_SEL_CTZ       6'b011100  // Count Trailing Zeros
`define ALU_SEL_CPOP      6'b011101  // Count Population
`define ALU_SEL_MAX       6'b011110  // Signed Maximum
`define ALU_SEL_MAXU      6'b011111  // Unsigned Maximum
`define ALU_SEL_MIN       6'b001001  // Signed Minimum
`define ALU_SEL_MINU      6'b001010  // Unsigned Minimum
`define ALU_SEL_ROL       6'b001011  // Rotate Left
`define ALU_SEL_ROR       6'b001100  // Rotate Right
`define ALU_SEL_RORI      6'b001110  // Rotate Right Immediate
`define ALU_SEL_REV8      6'b001111  // Reverse Bytes
`define ALU_SEL_ORCB      6'b100000  // OR Combine Bytes
`define ALU_SEL_SEXT_B    6'b100001  // Sign Extend Byte
`define ALU_SEL_SEXT_H    6'b100010  // Sign Extend Halfword
`define ALU_SEL_ZEXT_H    6'b100011  // Zero Extend Halfword

`define ALU_SEL_X      6'bx

// br_unit_sel
`define BR_UNIT_SEL_BEQ    3'b000
`define BR_UNIT_SEL_BNE    3'b001
`define BR_UNIT_SEL_BLT    3'b100
`define BR_UNIT_SEL_BGE    3'b101
`define BR_UNIT_SEL_BLTU   3'b110
`define BR_UNIT_SEL_BGEU   3'b111
`define BR_UNIT_SEL_X      3'bx
// byte_len
`define MA_LEN_1B   2'b00
`define MA_LEN_2B   2'b01
`define MA_LEN_4B   2'b10
`define MA_LEN_X    2'bx
// e_out_sel
`define E_OUT_SEL_ALU_OUT       2'b00
`define E_OUT_SEL_IMM           2'b01
`define E_OUT_SEL_PC_PLUS4      2'b10
`define E_OUT_SEL_CSR_R_DATA    2'b11
`define E_OUT_SEL_X             2'bx
// next_pc_sel
`define NEXT_PC_SEL_ALU_OUT     1'b0
`define NEXT_PC_SEL_PC_PLUS4    1'b1
// csr_calc_in2_sel
`define CSR_CALC_IN2_SEL_RS1_DATA   1'b0
`define CSR_CALC_IN2_SEL_IMM        1'b1
`define CSR_CALC_IN2_SEL_X          1'bx
// csr_calc_sel
`define CSR_CALC_SEL_RW     2'b01
`define CSR_CALC_SEL_RS     2'b10
`define CSR_CALC_SEL_RC     2'b11
`define CSR_CALC_SEL_X      2'bx
// rs1_sel
`define RS1_SEL_TMP_RS1_DATA    1'b0
`define RS1_SEL_E_OUT           1'b1
`define RS1_SEL_X               1'bx
// rs2_sel
`define RS2_SEL_TMP_RS2_DATA    1'b0
`define RS2_SEL_E_OUT           1'b1
`define RS2_SEL_X               1'bx

// instruction
// OP
`define BITPAT_OP       32'bxxxxxxx_xxxxx_xxxxx_xxx_xxxxx_0110011
`define BITPAT_ADD      32'b0000000_xxxxx_xxxxx_000_xxxxx_0110011
`define BITPAT_SUB      32'b0100000_xxxxx_xxxxx_000_xxxxx_0110011
`define BITPAT_SLL      32'b0000000_xxxxx_xxxxx_001_xxxxx_0110011
`define BITPAT_SLT      32'b0000000_xxxxx_xxxxx_010_xxxxx_0110011
`define BITPAT_SLTU     32'b0000000_xxxxx_xxxxx_011_xxxxx_0110011
`define BITPAT_XOR      32'b0000000_xxxxx_xxxxx_100_xxxxx_0110011
`define BITPAT_SRL      32'b0000000_xxxxx_xxxxx_101_xxxxx_0110011
`define BITPAT_SRA      32'b0100000_xxxxx_xxxxx_101_xxxxx_0110011
`define BITPAT_OR       32'b0000000_xxxxx_xxxxx_110_xxxxx_0110011
`define BITPAT_AND      32'b0000000_xxxxx_xxxxx_111_xxxxx_0110011

// M Extension
`define BITPAT_MUL      32'b0000001_xxxxx_xxxxx_000_xxxxx_0110011 // 有符號乘法 (低 32 位)
`define BITPAT_MULH     32'b0000001_xxxxx_xxxxx_001_xxxxx_0110011 // 有符號乘法 (高 32 位)
`define BITPAT_MULHSU   32'b0000001_xxxxx_xxxxx_010_xxxxx_0110011 // 有符號 x 無符號乘法 (高 32 位)
`define BITPAT_MULHU    32'b0000001_xxxxx_xxxxx_011_xxxxx_0110011 // 無符號乘法 (高 32 位)
`define BITPAT_DIV      32'b0000001_xxxxx_xxxxx_100_xxxxx_0110011 // 有符號除法
`define BITPAT_DIVU     32'b0000001_xxxxx_xxxxx_101_xxxxx_0110011 // 無符號除法
`define BITPAT_REM      32'b0000001_xxxxx_xxxxx_110_xxxxx_0110011 // 有符號餘數
`define BITPAT_REMU     32'b0000001_xxxxx_xxxxx_111_xxxxx_0110011 // 無符號餘數

// B Extension
`define BITPAT_ANDN      32'b0100000_xxxxx_xxxxx_111_xxxxx_0110011
`define BITPAT_MAX       32'b0000101_xxxxx_xxxxx_110_xxxxx_0110011
`define BITPAT_MAXU      32'b0000101_xxxxx_xxxxx_111_xxxxx_0110011
`define BITPAT_MIN       32'b0000101_xxxxx_xxxxx_100_xxxxx_0110011
`define BITPAT_MINU      32'b0000101_xxxxx_xxxxx_101_xxxxx_0110011
`define BITPAT_ORN       32'b0100000_xxxxx_xxxxx_110_xxxxx_0110011
`define BITPAT_ROL       32'b0110000_xxxxx_xxxxx_001_xxxxx_0110011 // Rotate Left   
`define BITPAT_ROR       32'b0110000_xxxxx_xxxxx_101_xxxxx_0110011 // Rotate Right
`define BITPAT_XNOR      32'b0100000_xxxxx_xxxxx_100_xxxxx_0110011 // XOR NOT
`define BITPAT_ZEXT_H    32'b0000100_00000_xxxxx_100_xxxxx_0110011 // Zero Extend Halfword

// OP_IMM
`define BITPAT_OP_IMM   32'bxxxxxxxxxxxx_xxxxx_xxx_xxxxx_0010011
`define BITPAT_ADDI     32'bxxxxxxxxxxxx_xxxxx_000_xxxxx_0010011
`define BITPAT_SLTI     32'bxxxxxxxxxxxx_xxxxx_010_xxxxx_0010011
`define BITPAT_SLTIU    32'bxxxxxxxxxxxx_xxxxx_011_xxxxx_0010011
`define BITPAT_XORI     32'bxxxxxxxxxxxx_xxxxx_100_xxxxx_0010011
`define BITPAT_ORI      32'bxxxxxxxxxxxx_xxxxx_110_xxxxx_0010011
`define BITPAT_ANDI     32'bxxxxxxxxxxxx_xxxxx_111_xxxxx_0010011
`define BITPAT_SLLI     32'b0000000_xxxxx_xxxxx_001_xxxxx_0010011
`define BITPAT_SRLI     32'b0000000_xxxxx_xxxxx_101_xxxxx_0010011
`define BITPAT_SRAI     32'b0100000_xxxxx_xxxxx_101_xxxxx_0010011

// B Extension
`define BITPAT_ORCB      32'b001010000111_xxxxx_101_xxxxx_0010011
`define BITPAT_REV8      32'b011010011000_xxxxx_101_xxxxx_0010011
`define BITPAT_CLZ       32'b0110000_00000_xxxxx_001_xxxxx_0010011
`define BITPAT_CPOP      32'b0110000_00010_xxxxx_001_xxxxx_0010011
`define BITPAT_CTZ       32'b0110000_00001_xxxxx_001_xxxxx_0010011
`define BITPAT_RORI      32'b0110000_xxxxx_xxxxx_101_xxxxx_0010011 // Rotate Right Immediate
`define BITPAT_SEXT_B    32'b0110000_00100_xxxxx_001_xxxxx_0010011 // Sign Extend Byte
`define BITPAT_SEXT_H    32'b0110000_00101_xxxxx_001_xxxxx_0010011 // Sign Extend Halfword

// LUI
`define BITPAT_LUI      32'bxxxxxxxxxxxxxxxxxxxx_xxxxx_0110111
// AUIPC
`define BITPAT_AUIPC    32'bxxxxxxxxxxxxxxxxxxxx_xxxxx_0010111
// JAL
`define BITPAT_JAL      32'bxxxxxxxxxxxxxxxxxxxx_xxxxx_1101111
// JALR
`define BITPAT_JALR     32'bxxxxxxxxxxxxxxxxxxxx_xxxxx_1100111
// BRANCH
`define BITPAT_BRANCH   32'bxxxxxxx_xxxxx_xxxxx_xxx_xxxxx_1100011
`define BITPAT_BEQ      32'bxxxxxxx_xxxxx_xxxxx_000_xxxxx_1100011
`define BITPAT_BNE      32'bxxxxxxx_xxxxx_xxxxx_001_xxxxx_1100011
`define BITPAT_BLT      32'bxxxxxxx_xxxxx_xxxxx_100_xxxxx_1100011
`define BITPAT_BGE      32'bxxxxxxx_xxxxx_xxxxx_101_xxxxx_1100011
`define BITPAT_BLTU     32'bxxxxxxx_xxxxx_xxxxx_110_xxxxx_1100011
`define BITPAT_BGEU     32'bxxxxxxx_xxxxx_xxxxx_111_xxxxx_1100011
// LOAD
`define BITPAT_LOAD     32'bxxxxxxxxxxxx_xxxxx_xxx_xxxxx_0000011
`define BITPAT_LB       32'bxxxxxxxxxxxx_xxxxx_000_xxxxx_0000011
`define BITPAT_LH       32'bxxxxxxxxxxxx_xxxxx_001_xxxxx_0000011
`define BITPAT_LW       32'bxxxxxxxxxxxx_xxxxx_010_xxxxx_0000011
`define BITPAT_LBU      32'bxxxxxxxxxxxx_xxxxx_100_xxxxx_0000011
`define BITPAT_LHU      32'bxxxxxxxxxxxx_xxxxx_101_xxxxx_0000011
// STORE
`define BITPAT_STORE    32'bxxxxxxx_xxxxx_xxxxx_xxx_xxxxx_0100011
`define BITPAT_SB       32'bxxxxxxx_xxxxx_xxxxx_000_xxxxx_0100011
`define BITPAT_SH       32'bxxxxxxx_xxxxx_xxxxx_001_xxxxx_0100011
`define BITPAT_SW       32'bxxxxxxx_xxxxx_xxxxx_010_xxxxx_0100011
// FENCE
`define BITPAT_FENCE    32'bxxxx_xxxx_xxxx_xxxxx_000_xxxxx_0001111
// SYSTEM
`define BITPAT_SYSTEM   32'bxxxxxxxxxxxx_xxxxx_xxx_xxxxx_1110011
`define BITPAT_ECALL    32'b000000000000_00000_000_00000_1110011
`define BITPAT_EBREAK   32'b000000000001_00000_000_00000_1110011
`define BITPAT_CSRRW    32'bxxxxxxxxxxxx_xxxxx_001_xxxxx_1110011
`define BITPAT_CSRRS    32'bxxxxxxxxxxxx_xxxxx_010_xxxxx_1110011
`define BITPAT_CSRRC    32'bxxxxxxxxxxxx_xxxxx_011_xxxxx_1110011
`define BITPAT_CSRRWI   32'bxxxxxxxxxxxx_xxxxx_101_xxxxx_1110011
`define BITPAT_CSRRSI   32'bxxxxxxxxxxxx_xxxxx_110_xxxxx_1110011
`define BITPAT_CSRRCI   32'bxxxxxxxxxxxx_xxxxx_111_xxxxx_1110011
`define FUNCT3_CSRRW    3'b001
`define FUNCT3_CSRRS    3'b010
`define FUNCT3_CSRRC    3'b011
`define FUNCT3_CSRRWI   3'b101
`define FUNCT3_CSRRSI   3'b110
`define FUNCT3_CSRRCI   3'b111
`define BITPAT_MRET     32'b0011000_00010_00000_000_00000_1110011

// privilege_level
`define PRIVILEGE_MODE_U   2'b00
`define PRIVILEGE_MODE_S   2'b01
`define PRIVILEGE_MODE_H   2'b10
`define PRIVILEGE_MODE_M   2'b11

// CSR
// Unprivileged CSR
// Unprivileged Floating-Point CSRs
`define CSR_FFLAGS          12'h001
`define CSR_FRM             12'h002
`define CSR_FCSR            12'h003
// Unprivileged Zicfiss extension CSR
`define CSR_SSP             12'h011
// Unprivileged Counter/Timers
`define CSR_CYCLE           12'hC00
`define CSR_TIME            12'hC01
`define CSR_INSTRET         12'hC02
`define CSR_HPMCOUNTER3     12'hC03
`define CSR_HPMCOUNTER4     12'hC04
`define CSR_HPMCOUNTER5     12'hC05
`define CSR_HPMCOUNTER6     12'hC06
`define CSR_HPMCOUNTER7     12'hC07
`define CSR_HPMCOUNTER8     12'hC08
`define CSR_HPMCOUNTER9     12'hC09
`define CSR_HPMCOUNTER10    12'hC0A
`define CSR_HPMCOUNTER11    12'hC0B
`define CSR_HPMCOUNTER12    12'hC0C
`define CSR_HPMCOUNTER13    12'hC0D
`define CSR_HPMCOUNTER14    12'hC0E
`define CSR_HPMCOUNTER15    12'hC0F
`define CSR_HPMCOUNTER16    12'hC10
`define CSR_HPMCOUNTER17    12'hC11
`define CSR_HPMCOUNTER18    12'hC12
`define CSR_HPMCOUNTER19    12'hC13
`define CSR_HPMCOUNTER20    12'hC14
`define CSR_HPMCOUNTER21    12'hC15
`define CSR_HPMCOUNTER22    12'hC16
`define CSR_HPMCOUNTER23    12'hC17
`define CSR_HPMCOUNTER24    12'hC18
`define CSR_HPMCOUNTER25    12'hC19
`define CSR_HPMCOUNTER26    12'hC1A
`define CSR_HPMCOUNTER27    12'hC1B
`define CSR_HPMCOUNTER28    12'hC1C
`define CSR_HPMCOUNTER29    12'hC1D
`define CSR_HPMCOUNTER30    12'hC1E
`define CSR_HPMCOUNTER31    12'hC1F
`define CSR_CYCLEH          12'hC80
`define CSR_TIMEH           12'hC81
`define CSR_INSTRETH        12'hC82
`define CSR_HPMCOUNTER3H    12'hC83
`define CSR_HPMCOUNTER4H    12'hC84
`define CSR_HPMCOUNTER5H    12'hC85
`define CSR_HPMCOUNTER6H    12'hC86
`define CSR_HPMCOUNTER7H    12'hC87
`define CSR_HPMCOUNTER8H    12'hC88
`define CSR_HPMCOUNTER9H    12'hC89
`define CSR_HPMCOUNTER10H   12'hC8A
`define CSR_HPMCOUNTER11H   12'hC8B
`define CSR_HPMCOUNTER12H   12'hC8C
`define CSR_HPMCOUNTER13H   12'hC8D
`define CSR_HPMCOUNTER14H   12'hC8E
`define CSR_HPMCOUNTER15H   12'hC8F
`define CSR_HPMCOUNTER16H   12'hC90
`define CSR_HPMCOUNTER17H   12'hC91
`define CSR_HPMCOUNTER18H   12'hC92
`define CSR_HPMCOUNTER19H   12'hC93
`define CSR_HPMCOUNTER20H   12'hC94
`define CSR_HPMCOUNTER21H   12'hC95
`define CSR_HPMCOUNTER22H   12'hC96
`define CSR_HPMCOUNTER23H   12'hC97
`define CSR_HPMCOUNTER24H   12'hC98
`define CSR_HPMCOUNTER25H   12'hC99
`define CSR_HPMCOUNTER26H   12'hC9A
`define CSR_HPMCOUNTER27H   12'hC9B
`define CSR_HPMCOUNTER28H   12'hC9C
`define CSR_HPMCOUNTER29H   12'hC9D
`define CSR_HPMCOUNTER30H   12'hC9E
`define CSR_HPMCOUNTER31H   12'hC9F
// machine-level CSR
// Machine Information Registers
`define CSR_MVENDERID       12'hf11
`define CSR_MARCHID         12'hf12
`define CSR_MIMPID          12'hf13
`define CSR_MHARTID         12'hf14
`define CSR_CONFIGPTR       12'hf15
// Machine Trap Setup
`define CSR_MSTATUS         12'h300
`define CSR_MISA            12'h301
`define CSR_MEDELEG         12'h302
`define CSR_MIDELEG         12'h303
`define CSR_MIE             12'h304
`define CSR_MTVEC           12'h305
`define CSR_MCOUNTEREN      12'h306
`define CSR_MSTATUSH        12'h310
`define CSR_MEDELEGH        12'h312
// Machine Trap Handling
`define CSR_MSCRATCH        12'h340     
`define CSR_MEPC            12'h341     
`define CSR_MCAUSE          12'h342
`define CSR_MTVAL           12'h343
`define CSR_MIP             12'h344
`define CSR_MTINST          12'h34A
`define CSR_MTVAL2          12'h34B
// Machine Configuration
`define CSR_MENVCFG         12'h30A
`define CSR_MENVCFGH        12'h31A
`define CSR_MSECCFG         12'h747
`define CSR_MSECCFGH        12'h757
// Machine Memory Protection
`define CSR_PMPCFG0         12'h3A0
`define CSR_PMPCFG1         12'h3A1
`define CSR_PMPCFG2         12'h3A2
`define CSR_PMPCFG3         12'h3A3
`define CSR_PMPCFG4         12'h3A4
`define CSR_PMPCFG5         12'h3A5
`define CSR_PMPCFG6         12'h3A6
`define CSR_PMPCFG7         12'h3A7
`define CSR_PMPCFG8         12'h3A8
`define CSR_PMPCFG9         12'h3A9
`define CSR_PMPCFG10        12'h3AA
`define CSR_PMPCFG11        12'h3AB
`define CSR_PMPCFG12        12'h3AC
`define CSR_PMPCFG13        12'h3AD
`define CSR_PMPCFG14        12'h3AE
`define CSR_PMPCFG15        12'h3AF
`define CSR_PMPADDR0        12'h3B0
`define CSR_PMPADDR1        12'h3B1
`define CSR_PMPADDR2        12'h3B2
`define CSR_PMPADDR3        12'h3B3
`define CSR_PMPADDR4        12'h3B4
`define CSR_PMPADDR5        12'h3B5
`define CSR_PMPADDR6        12'h3B6
`define CSR_PMPADDR7        12'h3B7
`define CSR_PMPADDR8        12'h3B8
`define CSR_PMPADDR9        12'h3B9
`define CSR_PMPADDR10       12'h3BA
`define CSR_PMPADDR11       12'h3BB
`define CSR_PMPADDR12       12'h3BC
`define CSR_PMPADDR13       12'h3BD
`define CSR_PMPADDR14       12'h3BE
`define CSR_PMPADDR15       12'h3BF
`define CSR_PMPADDR16       12'h3C0
`define CSR_PMPADDR17       12'h3C1
`define CSR_PMPADDR18       12'h3C2
`define CSR_PMPADDR19       12'h3C3
`define CSR_PMPADDR20       12'h3C4
`define CSR_PMPADDR21       12'h3C5
`define CSR_PMPADDR22       12'h3C6
`define CSR_PMPADDR23       12'h3C7
`define CSR_PMPADDR24       12'h3C8
`define CSR_PMPADDR25       12'h3C9
`define CSR_PMPADDR26       12'h3CA
`define CSR_PMPADDR27       12'h3CB
`define CSR_PMPADDR28       12'h3CC
`define CSR_PMPADDR29       12'h3CD
`define CSR_PMPADDR30       12'h3CE
`define CSR_PMPADDR31       12'h3CF
`define CSR_PMPADDR32       12'h3D0
`define CSR_PMPADDR33       12'h3D1
`define CSR_PMPADDR34       12'h3D2
`define CSR_PMPADDR35       12'h3D3
`define CSR_PMPADDR36       12'h3D4
`define CSR_PMPADDR37       12'h3D5
`define CSR_PMPADDR38       12'h3D6
`define CSR_PMPADDR39       12'h3D7
`define CSR_PMPADDR40       12'h3D8
`define CSR_PMPADDR41       12'h3D9
`define CSR_PMPADDR42       12'h3DA
`define CSR_PMPADDR43       12'h3DB
`define CSR_PMPADDR44       12'h3DC
`define CSR_PMPADDR45       12'h3DD
`define CSR_PMPADDR46       12'h3DE
`define CSR_PMPADDR47       12'h3DF
`define CSR_PMPADDR48       12'h3E0
`define CSR_PMPADDR49       12'h3E1
`define CSR_PMPADDR50       12'h3E2
`define CSR_PMPADDR51       12'h3E3
`define CSR_PMPADDR52       12'h3E4
`define CSR_PMPADDR53       12'h3E5
`define CSR_PMPADDR54       12'h3E6
`define CSR_PMPADDR55       12'h3E7
`define CSR_PMPADDR56       12'h3E8
`define CSR_PMPADDR57       12'h3E9
`define CSR_PMPADDR58       12'h3EA
`define CSR_PMPADDR59       12'h3EB
`define CSR_PMPADDR60       12'h3EC
`define CSR_PMPADDR61       12'h3ED
`define CSR_PMPADDR62       12'h3EE
`define CSR_PMPADDR63       12'h3EF
// Machine State Enable Registers
`define CSR_MSTATEEN0       12'h30C
`define CSR_MSTATEEN1       12'h30D
`define CSR_MSTATEEN2       12'h30E
`define CSR_MSTATEEN3       12'h30F
`define CSR_MSTATEEN0H      12'h31C
`define CSR_MSTATEEN1H      12'h31D
`define CSR_MSTATEEN2H      12'h31E
`define CSR_MSTATEEN3H      12'h31F
// Machine Non-Maskable Interrupt Handling
`define CSR_MNSCRATCH       12'h740
`define CSR_MNEPC           12'h741
`define CSR_MNCAUSE         12'h742
`define CSR_MNSTATUS        12'h744
// Machine Counter/Timers
`define CSR_MCYCLE          12'hB00
`define CSR_MINSTRET        12'hB02
`define CSR_MHPMCOUNTER3    12'hB03
`define CSR_MHPMCOUNTER4    12'hB04
`define CSR_MHPMCOUNTER5    12'hB05
`define CSR_MHPMCOUNTER6    12'hB06
`define CSR_MHPMCOUNTER7    12'hB07
`define CSR_MHPMCOUNTER8    12'hB08
`define CSR_MHPMCOUNTER9    12'hB09
`define CSR_MHPMCOUNTER10   12'hB0A
`define CSR_MHPMCOUNTER11   12'hB0B
`define CSR_MHPMCOUNTER12   12'hB0C
`define CSR_MHPMCOUNTER13   12'hB0D
`define CSR_MHPMCOUNTER14   12'hB0E
`define CSR_MHPMCOUNTER15   12'hB0F
`define CSR_MHPMCOUNTER16   12'hB10
`define CSR_MHPMCOUNTER17   12'hB11
`define CSR_MHPMCOUNTER18   12'hB12
`define CSR_MHPMCOUNTER19   12'hB13
`define CSR_MHPMCOUNTER20   12'hB14
`define CSR_MHPMCOUNTER21   12'hB15
`define CSR_MHPMCOUNTER22   12'hB16
`define CSR_MHPMCOUNTER23   12'hB17
`define CSR_MHPMCOUNTER24   12'hB18
`define CSR_MHPMCOUNTER25   12'hB19
`define CSR_MHPMCOUNTER26   12'hB1A
`define CSR_MHPMCOUNTER27   12'hB1B
`define CSR_MHPMCOUNTER28   12'hB1C
`define CSR_MHPMCOUNTER29   12'hB1D
`define CSR_MHPMCOUNTER30   12'hB1E
`define CSR_MHPMCOUNTER31   12'hB1F
`define CSR_MCYCLEH         12'hB80
`define CSR_MINSTRETH       12'hB82
`define CSR_MHPMCOUNTER3H   12'hB83
`define CSR_MHPMCOUNTER4H   12'hB84
`define CSR_MHPMCOUNTER5H   12'hB85
`define CSR_MHPMCOUNTER6H   12'hB86
`define CSR_MHPMCOUNTER7H   12'hB87
`define CSR_MHPMCOUNTER8H   12'hB88
`define CSR_MHPMCOUNTER9H   12'hB89
`define CSR_MHPMCOUNTER10H  12'hB8A
`define CSR_MHPMCOUNTER11H  12'hB8B
`define CSR_MHPMCOUNTER12H  12'hB8C
`define CSR_MHPMCOUNTER13H  12'hB8D
`define CSR_MHPMCOUNTER14H  12'hB8E
`define CSR_MHPMCOUNTER15H  12'hB8F
`define CSR_MHPMCOUNTER16H  12'hB90
`define CSR_MHPMCOUNTER17H  12'hB91
`define CSR_MHPMCOUNTER18H  12'hB92
`define CSR_MHPMCOUNTER19H  12'hB93
`define CSR_MHPMCOUNTER20H  12'hB94
`define CSR_MHPMCOUNTER21H  12'hB95
`define CSR_MHPMCOUNTER22H  12'hB96
`define CSR_MHPMCOUNTER23H  12'hB97
`define CSR_MHPMCOUNTER24H  12'hB98
`define CSR_MHPMCOUNTER25H  12'hB99
`define CSR_MHPMCOUNTER26H  12'hB9A
`define CSR_MHPMCOUNTER27H  12'hB9B
`define CSR_MHPMCOUNTER28H  12'hB9C
`define CSR_MHPMCOUNTER29H  12'hB9D
`define CSR_MHPMCOUNTER30H  12'hB9E
`define CSR_MHPMCOUNTER31H  12'hB9F
// Machine Counter Setup
`define CSR_MCOUNTINHIBIT   12'h320
`define CSR_MHPMEVENT3      12'h323
`define CSR_MHPMEVENT4      12'h324
`define CSR_MHPMEVENT5      12'h325
`define CSR_MHPMEVENT6      12'h326
`define CSR_MHPMEVENT7      12'h327
`define CSR_MHPMEVENT8      12'h328
`define CSR_MHPMEVENT9      12'h329
`define CSR_MHPMEVENT10     12'h32A
`define CSR_MHPMEVENT11     12'h32B
`define CSR_MHPMEVENT12     12'h32C
`define CSR_MHPMEVENT13     12'h32D
`define CSR_MHPMEVENT14     12'h32E
`define CSR_MHPMEVENT15     12'h32F
`define CSR_MHPMEVENT16     12'h330
`define CSR_MHPMEVENT17     12'h331
`define CSR_MHPMEVENT18     12'h332
`define CSR_MHPMEVENT19     12'h333
`define CSR_MHPMEVENT20     12'h334
`define CSR_MHPMEVENT21     12'h335
`define CSR_MHPMEVENT22     12'h336
`define CSR_MHPMEVENT23     12'h337
`define CSR_MHPMEVENT24     12'h338
`define CSR_MHPMEVENT25     12'h339
`define CSR_MHPMEVENT26     12'h33A
`define CSR_MHPMEVENT27     12'h33B
`define CSR_MHPMEVENT28     12'h33C
`define CSR_MHPMEVENT29     12'h33D
`define CSR_MHPMEVENT30     12'h33E
`define CSR_MHPMEVENT31     12'h33F
`define CSR_MHPMEVENT3H     12'h723
`define CSR_MHPMEVENT4H     12'h724
`define CSR_MHPMEVENT5H     12'h725
`define CSR_MHPMEVENT6H     12'h726
`define CSR_MHPMEVENT7H     12'h727
`define CSR_MHPMEVENT8H     12'h728
`define CSR_MHPMEVENT9H     12'h729
`define CSR_MHPMEVENT10H    12'h72A
`define CSR_MHPMEVENT11H    12'h72B
`define CSR_MHPMEVENT12H    12'h72C
`define CSR_MHPMEVENT13H    12'h72D
`define CSR_MHPMEVENT14H    12'h72E
`define CSR_MHPMEVENT15H    12'h72F
`define CSR_MHPMEVENT16H    12'h730
`define CSR_MHPMEVENT17H    12'h731
`define CSR_MHPMEVENT18H    12'h732
`define CSR_MHPMEVENT19H    12'h733
`define CSR_MHPMEVENT20H    12'h734
`define CSR_MHPMEVENT21H    12'h735
`define CSR_MHPMEVENT22H    12'h736
`define CSR_MHPMEVENT23H    12'h737
`define CSR_MHPMEVENT24H    12'h738
`define CSR_MHPMEVENT25H    12'h739
`define CSR_MHPMEVENT26H    12'h73A
`define CSR_MHPMEVENT27H    12'h73B
`define CSR_MHPMEVENT28H    12'h73C
`define CSR_MHPMEVENT29H    12'h73D
`define CSR_MHPMEVENT30H    12'h73E
`define CSR_MHPMEVENT31H    12'h73F
// Debug/Trace Registers (shared with Debug Mode)
`define CSR_TSELECT         12'h7A0
`define CSR_TDATA1          12'h7A1
`define CSR_TDATA2          12'h7A2
`define CSR_TDATA3          12'h7A3
`define CSR_MCONTEXT        12'h7A8
// Debug Mode Registers
`define CSR_DCSR            12'h7B0
`define CSR_DPC             12'h7B1
`define CSR_DSCRATCH0       12'h7B2
`define CSR_DSCRATCH1       12'h7B3

// mcause
`define MCAUSE_INST_ADDR_MISALIGNED         32'h00000000
`define MCAUSE_INST_ACCESS_FAULT            32'h00000001
`define MCAUSE_ILLEGAL_INST                 32'h00000002
`define MCAUSE_BREAKPOINT                   32'h00000003
`define MCAUSE_LOAD_ADDR_MISALIGNED         32'h00000004
`define MCAUSE_LOAD_ACCESS_FAULT            32'h00000005
`define MCAUSE_STORE_ADDR_MISALIGNED        32'h00000006
`define MCAUSE_STORE_ACCESS_FAULT           32'h00000007
`define MCAUSE_ECALL_FROM_U                 32'h00000008
`define MCAUSE_ECALL_FROM_S                 32'h00000009
`define MCAUSE_ECALL_FROM_H                 32'h0000000a
`define MCAUSE_ECALL_FROM_M                 32'h0000000b

// exc_code
`define EXC_INST_ADDR_MISALIGNED    5'b00000
`define EXC_INST_ACCESS_FAULT       5'b00001
`define EXC_ILLEGAL_INST            5'b00010
`define EXC_BREAKPOINT              5'b00011
`define EXC_LOAD_ADDR_MISALIGNED    5'b00100
`define EXC_LOAD_ACCESS_FAULT       5'b00101
`define EXC_STORE_ADDR_MISALIGNED   5'b00110
`define EXC_STORE_ACCESS_FAULT      5'b00111
`define EXC_ECALL_FROM_U            5'b01000
`define EXC_ECALL_FROM_S            5'b01001
`define EXC_ECALL_FROM_H            5'b01010
`define EXC_ECALL_FROM_M            5'b01011
`define EXC_INST_PAGE_FAULT         5'b01100
`define EXC_LOAD_PAGE_FAULT         5'b01101
// Reserved
`define EXC_STORE_PAGE_FAULT        5'b01111
`define EXC_DOUBLE_TRAP             5'b10000
// Reserved
`define EXC_SOFTWARE_CHECK          5'b10010
`define EXC_HARDWARE_ERROR          5'b10011
