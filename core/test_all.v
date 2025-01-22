`default_nettype none
`include "define.vh"

/* test bench */
`timescale 1ns/1ps

module test;
    parameter STEP = 10;
    reg clk, rst;

    reg test_pass [0:127];
    reg [64*8-1:0] test_file_name;
    reg [64*8-1:0] test_files [0:127];
    integer fd_r = 0;
    integer fd_w = 0;
    integer test_file_num = 0;
    integer num_test_file = 0;
    integer rtn;

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);

        fd_r = $fopen("test_file_name.txt","r");
        fd_w = $fopen("test_result.txt","w");
        while ($feof(fd_r) == 0) begin
            rtn = $fscanf(fd_r,"%s\n",test_file_name);
            // rtn = $fgets(test_file_name, fd);
            test_files[test_file_num] = test_file_name;
            $fdisplay(fd_w, "%s", test_files[test_file_num]);
            test_file_num = test_file_num + 1;
        end
        $fclose(fd_r);
        num_test_file = test_file_num;
        test_file_num = 0;
        $fdisplay(fd_w, "----------------------");
        $fdisplay(fd_w, "%s", test_files[test_file_num]);
        $readmemh(test_files[test_file_num], core_0.ram_0.mem);
    end

    core core_0 (.clk(clk), .rst(rst));

    initial begin
        clk <= 0;
        rst <= 1;
        #(STEP*9/4)
        rst <= 0;
    end

    initial begin
        forever #(STEP/2) clk <= ~clk;
    end
    

    initial begin
        #(STEP/2-1)
        forever begin
            #STEP
            $fdisplay(fd_w, "time:%d pc:%h inst:%h x1:%h x2:%h x3:%h x4:%h x5:%h x6:%h x7:%h", $realtime, core_0.fd_pc, core_0.fd_inst, core_0.reg_file_0.mem[1], core_0.reg_file_0.mem[2], core_0.reg_file_0.mem[3], core_0.reg_file_0.mem[4], core_0.reg_file_0.mem[5], core_0.reg_file_0.mem[6], core_0.reg_file_0.mem[7]);
            if ((core_0.mw_rd_addr == 5'd3) & (core_0.mw_reg_we == 1'b1)) begin
                $fdisplay(fd_w, "gp:%d", core_0.mw_rd_data);
            end
            if(core_0.fd_pc == 32'h44) begin
                if (core_0.reg_file_0.mem[3] == 32'd1) begin
                    $fdisplay(fd_w, "test pass");
                    test_pass[test_file_num] = 1'b1;
                end else begin
                    $fdisplay(fd_w, "test fail");
                    test_pass[test_file_num] = 1'b0;
                end
                test_file_num = test_file_num + 1;
                if (test_file_num == num_test_file) begin
                    $fdisplay(fd_w, "----------------------");
                    $display("----------------------");
                    for (test_file_num = 0; test_file_num < num_test_file; test_file_num = test_file_num + 1) begin
                        if (test_pass[test_file_num] == 1'b1) begin
                            $display("%s  pass", test_files[test_file_num]);
                            $fdisplay(fd_w, "%s  pass", test_files[test_file_num]);
                        end else begin
                            $display("%s  fail", test_files[test_file_num]);
                            $fdisplay(fd_w, "%s  fail", test_files[test_file_num]);
                        end
                    end
                    $fclose(fd_w);
                    $finish;
                end
                $fdisplay(fd_w, "----------------------");
                $fdisplay(fd_w, "%s", test_files[test_file_num]);
                rst <= 1;
                #STEP
                $readmemh(test_files[test_file_num], core_0.ram_0.mem);
                #STEP
                rst <= 0;
            end
        end
    end

    initial #(STEP*100000) $finish;

endmodule

`default_nettype wire