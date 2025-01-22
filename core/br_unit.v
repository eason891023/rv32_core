`default_nettype none
`include "define.vh"
`timescale 1ns/1ps

module br_unit(
    input wire signed [31:0] in1,
    input wire signed [31:0] in2,
    input wire [2:0] sel,
    output reg br_en
    );

    always @* begin
        casex(sel)
            `BR_UNIT_SEL_BEQ:  br_en = (in1 == in2);
            `BR_UNIT_SEL_BNE:  br_en = (in1 != in2);
            `BR_UNIT_SEL_BLT:  br_en = (in1 < in2);
            `BR_UNIT_SEL_BGE:  br_en = (in1 >= in2);
            `BR_UNIT_SEL_BLTU: br_en = ($unsigned(in1) < $unsigned(in2));
            `BR_UNIT_SEL_BGEU: br_en = ($unsigned(in1) >= $unsigned(in2));
            default:                br_en = 1'b0;
        endcase
    end
        
endmodule

`default_nettype wire