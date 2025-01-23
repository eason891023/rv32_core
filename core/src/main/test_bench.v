// `default_nettype none
// `include "define.vh"

// `timescale 1ns/1ps

// module test;
//     parameter STEP = 10;
//     reg clk = 0;
//     reg rst = 1;

//     // ============== 實例化你的 CPU core ==============
//     // core_0 需含有 ram_0 和 e_trap 等訊號
//     core core_0 (
//         .clk(clk),
//         .rst(rst)
//     );

//     // ============== 時脈產生 ==============
//     always #(STEP/2) clk <= ~clk;

//     // ============== 波形輸出 ==============
//     initial begin
//         $dumpfile("test.vcd");
//         $dumpvars(0, test);
//     end

//     // ============== 讀入 code.mem，並解除 reset ==============
//     initial begin
//         // 將 arch test 建好的 code.mem 載入到 ram_0.mem
//         $readmemh("code.mem", core_0.ram_0.mem);

//         // 先維持 reset 一段時間
//         #(STEP*5) rst <= 0;
//     end
    
//     // ============== 週期性印出部分訊息 ==============
//     // (與你舊程式類似)
//     initial begin
//         #(STEP/2 - 1);
//         forever begin
//             #STEP;
//             $display("time:%d pc:%h inst:%h x1:%h x2:%h x3:%h x4:%h x5:%h x7:%h x14:%h",
//                 $time,
//                 core_0.fd_pc,
//                 core_0.fd_inst,
//                 core_0.reg_file_0.mem[1],
//                 core_0.reg_file_0.mem[2],
//                 core_0.reg_file_0.mem[3],
//                 core_0.reg_file_0.mem[4],
//                 core_0.reg_file_0.mem[5],
//                 core_0.reg_file_0.mem[7],
//                 core_0.reg_file_0.mem[14]
//             );
//         end
//     end

//     // ============== 設定最大執行週期，避免卡死 ==============
//     integer cycle_count = 0;
//     localparam MAX_CYCLE = 200000; // 視需求
//     always @(posedge clk) begin
//         cycle_count <= cycle_count + 1;
//         if (cycle_count >= MAX_CYCLE) begin
//             $display("ERROR: Timeout after %0d cycles, no test completion!", MAX_CYCLE);
//             $finish;
//         end
//     end

//     // ============== 偵測結束(e_trap) & 輸出 signature ==============
//     // 假設 signature 區段位於 [0x80001000..0x80001FFF]
//     localparam SIGNATURE_BEGIN = 32'h80001000;
//     localparam SIGNATURE_END   = 32'h80002000;

//     // 用 reg [1023:0] 存放 +signature=xxx 的路徑 (非 SystemVerilog string)
//     reg [1023:0] sig_file;
//     integer ret;  // 接收 $value$plusargs 的回傳

//     // 先在 initial 裏面抓取 +signature 參數
//     initial begin
//         ret = $value$plusargs("signature=%s", sig_file);
//         if (ret) begin
//             $display("Signature file will be dumped to: %0s", sig_file);
//         end else begin
//             $display("No +signature=<file> argument found. Signature won't be dumped.");
//             sig_file = "";
//         end
//     end

//     // 宣告給 for迴圈使用
//     integer i, f;

//     // 每個 clock 檢查 e_trap(或 test_done) 來輸出 .signature
//     always @(posedge clk) begin
//         if (core_0.e_trap) begin
//             $display("Test finished with e_trap=1 at time %t (cycle=%d)", $time, cycle_count);

//             // 若帶了 signature 參數則寫檔
//             if (sig_file != "") begin
//                 f = $fopen(sig_file, "w");
//                 if (f == 0) begin
//                     $display("ERROR: Cannot open signature file: %0s", sig_file);
//                 end else begin
//                     // Dump [SIGNATURE_BEGIN..SIGNATURE_END) 內容
//                     // 以 word 為單位: address >> 2
//                     for (i = SIGNATURE_BEGIN[31:2]; i < SIGNATURE_END[31:2]; i = i + 1) begin
//                         $fwrite(f, "%08x\n", core_0.ram_0.mem[i]);
//                     end
//                     $fclose(f);
//                     $display("Signature dumped to %s", sig_file);
//                 end
//             end

//             $finish;
//         end
//     end

//     // ============== 預設在 1000個 STEP 後結束(備用) ==============
//     initial #(STEP*20000) $finish;

// endmodule

// `default_nettype wire

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

    // 獲取簽章範圍
    reg [1023:0] sig_file;
    integer ret;
    reg [31:0] SIGNATURE_BEGIN;
    reg [31:0] SIGNATURE_END;

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

            // mem_dump_file = $fopen("memory_dump.txt", "w");
            // if (mem_dump_file == 0) begin
            //     $fatal(1, "Failed to open memory_dump.txt for writing");
            // end

            // // 導出記憶體的內容，假設記憶體範圍是 0 到 MEM_CAP_BYTE (以 4-byte 為單位)
            // for (i = 0; i < (`MEM_CAP_BYTE / 4); i = i + 1) begin
            //     $fwrite(mem_dump_file, "Address: %08x, Value: %08x\n", i * 4, core_0.ram_0.mem[i]);
            // end

            // $fclose(mem_dump_file);
            f = $fopen(sig_file, "w");
            if (f == 0) begin
                $fatal(1, "Failed to open memory_dump.txt for writing");
            end

            // 導出記憶體的內容，假設記憶體範圍是 0 到 MEM_CAP_BYTE (以 4-byte 為單位)
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
