`default_nettype none
`include "define.vh"

/* test bench */
`timescale 1ns/1ps

module test;
    parameter STEP = 10;
    reg clk, rst;

    core core_0 (.clk(clk), .rst(rst));

    initial begin
        forever #(STEP/2) clk <= ~clk;
    end
    
    initial begin
        $dumpfile("/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/asm/test.vcd");
        $dumpvars(0, test);
        $readmemh("/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/asm/shift_and_add_mul.S.mem", core_0.ram_0.mem);
        clk <= 0;
        rst <= 1;
        #(STEP*9/4)
        rst <= 0;
    end

    initial begin
        #(STEP/2-1)
        forever begin
            #STEP
            $display("time:%d pc:%h inst:%h x1:%h x2:%h x3:%h x4:%h x5:%h x7:%h x14:%h", $realtime, core_0.fd_pc, core_0.fd_inst, core_0.reg_file_0.mem[1], core_0.reg_file_0.mem[2], core_0.reg_file_0.mem[3], core_0.reg_file_0.mem[4], core_0.reg_file_0.mem[5], core_0.reg_file_0.mem[7], core_0.reg_file_0.mem[14]);
        end
    end

    // initial #(STEP*1000) $finish;
    initial begin
        #(STEP*500)
        $display("Result in memory: %h", core_0.ram_0.mem[1026]);
        $finish;
    end
endmodule

`default_nettype wire