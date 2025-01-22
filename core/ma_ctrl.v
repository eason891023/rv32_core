`default_nettype none
`include "define.vh"
`timescale 1ns/1ps
module ma_ctrl(
    input wire [31:0] in_addr,
    input wire [31:0] in_data,
    input wire [1:0] len,
    input wire load,
    input wire store,
    input wire clk,
    output reg [31:0] out_addr,
    output reg [31:0] out_data,
    output reg [3:0] we,
    output wire stall
    );

    wire [55:0] shifted_data;
    reg misaligned;

    assign shifted_data = {24'b0, in_data} << (in_addr[1:0] * 8);

    // check alignment
    always @* begin
        case(len)
            `MA_LEN_1B: begin
                misaligned = 1'b0;
            end
            `MA_LEN_2B: begin
                case(in_addr[1:0])
                    2'b00: misaligned = 1'b0;
                    2'b01: misaligned = 1'b0;
                    2'b10: misaligned = 1'b0;
                    2'b11: misaligned = 1'b1;
                    default: misaligned = 1'b0;
                endcase
            end
            `MA_LEN_4B: begin
                case(in_addr[1:0])
                    2'b00: misaligned = 1'b0;
                    2'b01: misaligned = 1'b1;
                    2'b10: misaligned = 1'b1;
                    2'b11: misaligned = 1'b1;
                    default: misaligned = 1'b0;
                endcase
            end
            default: misaligned = 1'b0;
        endcase
    end
    
    reg [31:0] prev_addr;
    reg second_access;
    // state register
    always @(posedge clk) begin
        prev_addr <= {in_addr[31:2], 2'b0};
        if (misaligned & (load | store)) second_access <= ~second_access;
        else second_access <= 1'b0;
    end

    assign stall = ~second_access & misaligned & (load | store);

    always @* begin
        if (second_access) begin
            out_addr = prev_addr + 32'h00000004;
            out_data = {8'b0, shifted_data[55:32]};
            if (store) begin
                case(len)
                    `MA_LEN_2B: we = 4'b0001;
                    `MA_LEN_4B: we = ~(4'b1111 << in_addr[1:0]);
                    default: we = 4'b0;
                endcase
            end else begin
                we = 4'b0;
            end
        end else begin
            out_addr = {in_addr[31:2], 2'b0};
            out_data = shifted_data[31:0];
            if (store) begin
                case(len)
                    `MA_LEN_1B: we = 4'b0001 << in_addr[1:0];
                    `MA_LEN_2B: we = 4'b0011 << in_addr[1:0];
                    `MA_LEN_4B: we = 4'b1111 << in_addr[1:0];
                    default: we = 4'b0;
                endcase
            end else begin
                we = 4'b0;
            end
        end
    end

endmodule

`default_nettype wire