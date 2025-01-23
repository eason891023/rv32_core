`default_nettype none
`include "define.vh"

`timescale 1ns/1ps

module test;
    parameter STEP = 10;
    reg clk = 0;
    reg rst = 1;

    integer start_idx, end_idx;

    core core_0 (
        .clk(clk),
        .rst(rst)
    );

    always #(STEP/2) clk <= ~clk;

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
    end

    initial begin
        $readmemh("code.mem", core_0.ram_0.mem);
        #(STEP*5) rst <= 0;
    end

    integer cycle_count = 0;
    localparam MAX_CYCLE = 200000;

    always @(posedge clk) begin
        cycle_count <= cycle_count + 1;
        if (cycle_count >= MAX_CYCLE) begin
            $display("ERROR: Timeout after %0d cycles, no test completion!", MAX_CYCLE);
            $finish;
        end
    end

    reg [1023:0] sig_file;
    integer ret;
    reg [31:0] SIGNATURE_BEGIN;
    reg [31:0] SIGNATURE_END;
    // get the signature range
    initial begin
        ret = $value$plusargs("signature=%s", sig_file);
        if (!ret) begin
            sig_file = "";
            $fatal(1, "Missing +signature parameter. Provide it with +signature=<file>");
        end

        ret = $value$plusargs("begin_signature=%h", SIGNATURE_BEGIN);
        if (!ret) begin
            $fatal(1, "Missing +begin_signature parameter. Provide it with +begin_signature=<hex_address>");
        end

        ret = $value$plusargs("end_signature=%h", SIGNATURE_END);
        if (!ret) begin
            $fatal(1, "Missing +end_signature parameter. Provide it with +end_signature=<hex_address>");
        end

        $display("Signature range: 0x%08x - 0x%08x", SIGNATURE_BEGIN, SIGNATURE_END);
    end

    integer i, f, mem_dump_file;
    integer addr;
    localparam BASEADDR = 32'h80000000;
    always @(posedge clk) begin
        if (core_0.e_trap) begin
            $display("Test finished with e_trap=1 at time %t (cycle=%d)", $time, cycle_count);
            // try to dump the hole memory file to check
            // mem_dump_file = $fopen("memory_dump.txt", "w");
            // if (mem_dump_file == 0) begin
            //     $fatal(1, "Failed to open memory_dump.txt for writing");
            // end

            // for (i = 0; i < (`MEM_CAP_BYTE / 4); i = i + 1) begin
            //     $fwrite(mem_dump_file, "Address: %08x, Value: %08x\n", i * 4, core_0.ram_0.mem[i]);
            // end

            // $fclose(mem_dump_file);
            f = $fopen(sig_file, "w");
            if (f == 0) begin
                $fatal(1, "Failed to open memory_dump.txt for writing");
            end

            // for (i = (SIGNATURE_BEGIN - BASEADDR); i < (SIGNATURE_END - BASEADDR); i = i + 1) begin
                // $fwrite(f, "%08x\n", core_0.ram_0.mem[i]);
            for (i = 0; i < (SIGNATURE_END - SIGNATURE_BEGIN); i = i + 4) begin
                $fwrite(f, "%08x\n", core_0.ram_0.mem[i + (SIGNATURE_BEGIN - BASEADDR) >> 2]);
            end

            $fclose(f);
            $finish;
        end
    end


    initial #(STEP*20000) $finish;

endmodule

`default_nettype wire
