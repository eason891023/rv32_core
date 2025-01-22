`default_nettype none
`include "define.vh"
`timescale 1ns/1ps

module ram(
    input wire [31:0] addr1,
    input wire ce1,
    output reg [31:0] r_data1,

    input wire clk,
    input wire [31:0] addr2,
    input wire [3:0] we2,
    input wire [31:0] w_data2, 
    output reg [31:0] r_data2
    );

    reg [31:0] mem [0:`MEM_CAP_BYTE/4 - 1];

    always @(posedge clk) begin
        if (ce1) begin
            r_data1 <= mem[addr1[31:2]];
        end
        r_data2 <= mem[addr2[31:2]];
    end

    always @(posedge clk) begin
        if(we2[0]) mem[addr2[31:2]][7:0] <= w_data2[7:0];
        if(we2[1]) mem[addr2[31:2]][15:8] <= w_data2[15:8];
        if(we2[2]) mem[addr2[31:2]][23:16] <= w_data2[23:16];
        if(we2[3]) mem[addr2[31:2]][31:24] <= w_data2[31:24];
    end

endmodule

`default_nettype wire