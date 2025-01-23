`default_nettype none
`include "define.vh"
`timescale 1ns/1ps

module alu(
    input wire signed [31:0] in1, in2,
    //
    //input wire [3:0] sel,
    // input wire [4:0] sel,
    input wire [5:0] sel,
    output reg [31:0] out
    );

    reg signed [63:0] mul_result_signed;   // 有符號乘法結果
    reg [63:0] mul_result_unsigned;       // 無符號乘法結果
    reg [31:0] div_result, rem_result;    // 除法與餘數結果

    always @* begin
        casex(sel)
            `ALU_SEL_ADD:  out = in1 + in2;
            `ALU_SEL_SUB:  out = in1 - in2;
            `ALU_SEL_SLL:  out = in1 << in2[4:0];
            `ALU_SEL_SLT:  out = in1 < in2;
            `ALU_SEL_SLTU: out = $unsigned(in1) < $unsigned(in2);
            `ALU_SEL_XOR:  out = in1 ^ in2;
            `ALU_SEL_SRL:  out = in1 >> in2[4:0];
            `ALU_SEL_SRA:  out = in1 >>> in2[4:0];
            `ALU_SEL_OR:   out = in1 | in2;
            `ALU_SEL_AND:  out = in1 & in2;

            // RV32M extension instructions
            `ALU_SEL_MUL: begin
                mul_result_signed = in1 * in2; // Signed multiplication
                out = mul_result_signed[31:0]; // Lower 32 bits as the result
            end
            `ALU_SEL_MULH: begin
                mul_result_signed = in1 * in2; // Signed multiplication
                out = mul_result_signed[63:32]; // Upper 32 bits as the result
            end
            `ALU_SEL_MULHSU: begin
                mul_result_signed = $signed({{32{in1[31]}}, in1}) * $unsigned({32'b0, in2}); // Signed x Unsigned multiplication
                out = mul_result_signed[63:32]; // Upper 32 bits as the result
            end
            `ALU_SEL_MULHU: begin
                mul_result_unsigned = $unsigned(in1) * $unsigned(in2); // Unsigned multiplication
                out = mul_result_unsigned[63:32]; // Upper 32 bits as the result
            end
            `ALU_SEL_DIV: begin
                if (in2 != 0) begin
                    div_result = in1 / in2; // Signed integer division
                    out = div_result;
                end else begin
                    out = 32'hffffffff;
                end
            end
            `ALU_SEL_DIVU: begin
                if (in2 != 0) begin
                    div_result = $unsigned(in1) / $unsigned(in2); // Unsigned integer division
                    out = div_result;
                end else begin
                    out = 32'hffffffff;
                end
            end
            `ALU_SEL_REM: begin
                if (in2 != 0) begin
                    rem_result = in1 % in2; // Signed remainder
                    out = rem_result;
                end else begin
                    out = in1;
                end
            end
            `ALU_SEL_REMU: begin
                if (in2 != 0) begin
                    rem_result = $unsigned(in1) % $unsigned(in2); // Unsigned remainder
                    out = rem_result;
                end else begin
                    out = $unsigned(in1);
                end
            end

            // RV32 B Extension
            `ALU_SEL_ANDN:      out = in1 & ~in2;                      // AND NOT
            `ALU_SEL_ORN:       out = in1 | ~in2;                      // OR NOT
            `ALU_SEL_XNOR:      out = ~(in1 ^ in2);                    // XOR NOT
            `ALU_SEL_CLZ: begin
                out = (in1[31] == 1) ? 0 :
                    (in1[30] == 1) ? 1 :
                    (in1[29] == 1) ? 2 :
                    (in1[28] == 1) ? 3 :
                    (in1[27] == 1) ? 4 :
                    (in1[26] == 1) ? 5 :
                    (in1[25] == 1) ? 6 :
                    (in1[24] == 1) ? 7 :
                    (in1[23] == 1) ? 8 :
                    (in1[22] == 1) ? 9 :
                    (in1[21] == 1) ? 10 :
                    (in1[20] == 1) ? 11 :
                    (in1[19] == 1) ? 12 :
                    (in1[18] == 1) ? 13 :
                    (in1[17] == 1) ? 14 :
                    (in1[16] == 1) ? 15 :
                    (in1[15] == 1) ? 16 :
                    (in1[14] == 1) ? 17 :
                    (in1[13] == 1) ? 18 :
                    (in1[12] == 1) ? 19 :
                    (in1[11] == 1) ? 20 :
                    (in1[10] == 1) ? 21 :
                    (in1[9]  == 1) ? 22 :
                    (in1[8]  == 1) ? 23 :
                    (in1[7]  == 1) ? 24 :
                    (in1[6]  == 1) ? 25 :
                    (in1[5]  == 1) ? 26 :
                    (in1[4]  == 1) ? 27 :
                    (in1[3]  == 1) ? 28 :
                    (in1[2]  == 1) ? 29 :
                    (in1[1]  == 1) ? 30 :
                    (in1[0]  == 1) ? 31 : 32;
            end

            `ALU_SEL_CTZ: begin
                out = (in1[0] == 1) ? 0 :
                    (in1[1] == 1) ? 1 :
                    (in1[2] == 1) ? 2 :
                    (in1[3] == 1) ? 3 :
                    (in1[4] == 1) ? 4 :
                    (in1[5] == 1) ? 5 :
                    (in1[6] == 1) ? 6 :
                    (in1[7] == 1) ? 7 :
                    (in1[8] == 1) ? 8 :
                    (in1[9] == 1) ? 9 :
                    (in1[10] == 1) ? 10 :
                    (in1[11] == 1) ? 11 :
                    (in1[12] == 1) ? 12 :
                    (in1[13] == 1) ? 13 :
                    (in1[14] == 1) ? 14 :
                    (in1[15] == 1) ? 15 :
                    (in1[16] == 1) ? 16 :
                    (in1[17] == 1) ? 17 :
                    (in1[18] == 1) ? 18 :
                    (in1[19] == 1) ? 19 :
                    (in1[20] == 1) ? 20 :
                    (in1[21] == 1) ? 21 :
                    (in1[22] == 1) ? 22 :
                    (in1[23] == 1) ? 23 :
                    (in1[24] == 1) ? 24 :
                    (in1[25] == 1) ? 25 :
                    (in1[26] == 1) ? 26 :
                    (in1[27] == 1) ? 27 :
                    (in1[28] == 1) ? 28 :
                    (in1[29] == 1) ? 29 :
                    (in1[30] == 1) ? 30 :
                    (in1[31] == 1) ? 31 : 32;
            end

            `ALU_SEL_CPOP: begin
                out = in1[0]  + in1[1]  + in1[2]  + in1[3]  +
                    in1[4]  + in1[5]  + in1[6]  + in1[7]  +
                    in1[8]  + in1[9]  + in1[10] + in1[11] +
                    in1[12] + in1[13] + in1[14] + in1[15] +
                    in1[16] + in1[17] + in1[18] + in1[19] +
                    in1[20] + in1[21] + in1[22] + in1[23] +
                    in1[24] + in1[25] + in1[26] + in1[27] +
                    in1[28] + in1[29] + in1[30] + in1[31];
            end

            `ALU_SEL_MAX:       out = (in1 > in2) ? in1 : in2;         // Signed Maximum
            `ALU_SEL_MAXU:      out = ($unsigned(in1) > $unsigned(in2)) ? in1 : in2; // Unsigned Maximum
            `ALU_SEL_MIN:       out = (in1 < in2) ? in1 : in2;         // Signed Minimum
            `ALU_SEL_MINU:      out = ($unsigned(in1) < $unsigned(in2)) ? in1 : in2; // Unsigned Minimum
            `ALU_SEL_ROL:       out = (in1 << in2[4:0]) | (in1 >> (32 - in2[4:0])); // Rotate Left
            `ALU_SEL_ROR:       out = (in1 >> in2[4:0]) | (in1 << (32 - in2[4:0])); // Rotate Right 、 RORI 
            `ALU_SEL_REV8:      out = {in1[7:0], in1[15:8], in1[23:16], in1[31:24]}; // Reverse Bytes
            `ALU_SEL_ORCB: begin
                out = { 
                    (in1[31:24] == 8'b0) ? 8'b00000000 : 8'b11111111, 
                    (in1[23:16] == 8'b0) ? 8'b00000000 : 8'b11111111, 
                    (in1[15:8]  == 8'b0) ? 8'b00000000 : 8'b11111111, 
                    (in1[7:0]   == 8'b0) ? 8'b00000000 : 8'b11111111 
                };
            end

            `ALU_SEL_SEXT_B:    out = {{24{in1[7]}}, in1[7:0]};         // Sign Extend Byte
            `ALU_SEL_SEXT_H:    out = {{16{in1[15]}}, in1[15:0]};       // Sign Extend Halfword
            `ALU_SEL_ZEXT_H:    out = {16'b0, in1[15:0]};               // Zero Extend Halfword

            default:            out = in1;
        endcase

    end
    
endmodule

`default_nettype wire