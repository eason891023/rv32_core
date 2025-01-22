`default_nettype none
`timescale 1ns/1ps
module reg_file(
    input wire clk, we,
    input wire [4:0] r_addr1, r_addr2, w_addr,
    input wire [31:0] w_data,
    output wire [31:0] r_data1, r_data2
    );

    reg [31:0] mem [0:31];

    assign r_data1 = 
        (r_addr1 == 5'b0) ? 32'b0 :
        (we & r_addr1 == w_addr) ? w_data : mem[r_addr1];
    assign r_data2 = 
        (r_addr2 == 5'b0) ? 32'b0 :
        (we & r_addr2 == w_addr) ? w_data : mem[r_addr2];

    always @(posedge clk) begin
        if (we && w_addr != 5'b0) begin
            mem[w_addr] <= w_data;
        end
    end
    
endmodule

`default_nettype wire