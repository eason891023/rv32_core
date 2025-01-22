`default_nettype none
`include "define.vh"
`timescale 1ns/1ps

// Machine mode only
// mtvec MODE is direct only

module csr(
    input wire [11:0] addr,
    input wire [4:0] uimm,
    input wire [31:0] rs1_data,
    input wire [31:0] pc,
    input wire [2:0] funct3,
    input wire zicsr,
    input wire illegal_inst,
    input wire ecall,
    input wire mret,
    input wire rst,
    input wire clk,
    output reg [31:0] r_data
    );

    reg [1:0] privilege_mode = `PRIVILEGE_MODE_M;
    reg mstatus_mie;
    reg mstatus_mpie;
    reg [1:0] mstatus_mpp;
    reg [31:0] mcause, mtvec, mepc;
    reg [31:0] mscratch;

    always @* begin
        if(zicsr) begin
            case(addr)
                // Machine Information Registers
                `CSR_MVENDERID: r_data = 32'h0;
                `CSR_MARCHID:   r_data = 32'h0;
                `CSR_MIMPID:    r_data = 32'h0;
                `CSR_MHARTID:   r_data = 32'h0;
                `CSR_CONFIGPTR: r_data = 32'h0;
                // Machine Trap Setup
                `CSR_MSTATUS:   r_data = {19'b0, mstatus_mpp, 3'b0, mstatus_mpie, 3'b0, mstatus_mie, 3'b0};
                `CSR_MTVEC:     r_data = mtvec;
                // Machine Trap Handling
                `CSR_MSCRATCH:  r_data = mscratch;
                `CSR_MEPC:      r_data = mepc;
                `CSR_MCAUSE:    r_data = mcause;
                default:        r_data = 32'h0;
            endcase
        end else if (illegal_inst) begin
            r_data = mtvec;
        end else if (ecall) begin
            r_data = mtvec;
        end else if (mret) begin
            r_data = mepc;
        end else begin
            r_data = 32'h0;
        end
    end

    wire [31:0] operand;
    assign operand = (funct3[2] == 1'b0) ? rs1_data : {27'b0, uimm};

    wire [31:0] w_data;
    assign w_data =
        (funct3[1:0] == 2'b01) ? operand :
        (funct3[1:0] == 2'b10) ? r_data | operand :
        (funct3[1:0] == 2'b11) ? r_data & ~operand : r_data;

    always @(posedge clk) begin
        if (rst) begin
            mstatus_mie <= 1'b1;
        end else if (illegal_inst) begin
            mcause <= `MCAUSE_ILLEGAL_INST;
            mepc <= pc;
            mstatus_mpp <= privilege_mode;
            mstatus_mpie <= mstatus_mie;
            mstatus_mie <= 1'b0;
        end else if (ecall) begin
            mcause <= `MCAUSE_ECALL_FROM_M;
            mepc <= pc;
            mstatus_mpp <= privilege_mode;
            mstatus_mpie <= mstatus_mie;
            mstatus_mie <= 1'b0;
        end else if (mret) begin
            mstatus_mie <= mstatus_mpie;
            privilege_mode <= mstatus_mpp;
        end else if(zicsr) begin
            if (~((operand == 32'b0) & (funct3[1:0] == 2'b10)) & (addr[11:10] == 2'b11)) begin
                mcause <= `MCAUSE_ILLEGAL_INST;
                mepc <= pc;
                mstatus_mpp <= privilege_mode;
                mstatus_mpie <= mstatus_mie;
                mstatus_mie <= 1'b0;
            end else begin
                case(addr)
                    // Machine Trap Setup
                    `CSR_MSTATUS: begin
                        mstatus_mie <= w_data[3];
                        mstatus_mpie <= w_data[7];
                        mstatus_mpp <= w_data[12:11];
                    end
                    `CSR_MTVEC:     mtvec <= w_data;
                    // Machine Trap Handling
                    `CSR_MSCRATCH:  mscratch <= w_data;
                    `CSR_MEPC:      mepc <= w_data;
                    `CSR_MCAUSE:    mcause <= w_data;
                    default:;
                endcase
            end
        end
    end
    
endmodule

`default_nettype wire