`default_nettype none
`include "define.vh"
`timescale 1ns/1ps

module core(
    input wire clk, rst
    );

    ////////////////////////////////////
    //******** Fetch & Decode ********//
    ////////////////////////////////////
    reg [31:0] fd_pc;
    wire [31:0] next_pc;
    wire e_ma_stall;
    wire fd_lduse;
    always @(posedge clk) begin
        if (rst) begin
            fd_pc <= 32'b0;
        end else if (~(e_ma_stall | fd_lduse)) begin
            fd_pc <= next_pc;
        end
    end

    // Memory
    wire [31:0] fd_inst;
    wire [31:0] e_mem_rw_addr;
    wire [31:0] e_mem_w_data;
    wire [3:0] e_mem_we;
    wire [31:0] mw_mem_raw_r_data;
    ram ram_0(
        .addr1(next_pc),
        .ce1(~e_ma_stall & ~fd_lduse),
        .clk(clk),
        .r_data1(fd_inst),

        .addr2(e_mem_rw_addr),
        .w_data2(e_mem_w_data),
        .we2(e_mem_we),
        .r_data2(mw_mem_raw_r_data)
    );
    
    // Register File
    reg [4:0] mw_rd_addr;
    wire [31:0] mw_rd_data;
    reg mw_reg_we;
    wire [31:0] fd_tmp_rs1_data;
    wire [31:0] fd_tmp_rs2_data;
    reg_file reg_file_0(
        .r_addr1(fd_inst[19:15]), 
        .r_addr2(fd_inst[24:20]), 
        .w_addr(mw_rd_addr), 
        .w_data(mw_rd_data), 
        .we(mw_reg_we), 
        .clk(clk), 
        .r_data1(fd_tmp_rs1_data), 
        .r_data2(fd_tmp_rs2_data)
    );

    // Instruction Decoder
    reg [4:0] e_rd_addr;
    reg e_reg_we;
    reg e_load;
    wire [31:0] fd_imm;
    wire fd_alu_in1_sel;
    wire fd_alu_in2_sel;
    //wire [3:0] fd_alu_sel;
    // wire [4:0] fd_alu_sel;
    wire [5:0] fd_alu_sel;
    wire fd_reg_we;
    wire [1:0] fd_e_out_sel;
    wire fd_jump;
    wire fd_branch;
    wire fd_load;
    wire fd_store;
    wire fd_zicsr;
    wire fd_ecall;
    wire fd_mret;
    wire fd_illegal_inst;
    wire fd_rs1_sel;
    wire fd_rs2_sel;
    decoder decoder_0(
        .inst(fd_inst),
        .e_rd_addr(e_rd_addr),
        .e_reg_we(e_reg_we),
        .e_load(e_load),
        .imm(fd_imm),
        .alu_in1_sel(fd_alu_in1_sel),
        .alu_in2_sel(fd_alu_in2_sel),
        .alu_sel(fd_alu_sel),
        .reg_we(fd_reg_we),
        .e_out_sel(fd_e_out_sel),
        .jump(fd_jump),
        .branch(fd_branch),
        .load(fd_load),
        .store(fd_store),
        .zicsr(fd_zicsr),
        .ecall(fd_ecall),
        .mret(fd_mret),
        .illegal_inst(fd_illegal_inst),
        .rs1_sel(fd_rs1_sel),
        .rs2_sel(fd_rs2_sel),
        .lduse(fd_lduse)
    );

    // Multiplexer
    wire [31:0] fd_rs1_data;
    wire [31:0] fd_rs2_data;
    wire [31:0] e_out;
    assign fd_rs1_data = (fd_rs1_sel == `RS1_SEL_TMP_RS1_DATA) ? fd_tmp_rs1_data : e_out; 
    assign fd_rs2_data = (fd_rs2_sel == `RS2_SEL_TMP_RS2_DATA) ? fd_tmp_rs2_data : e_out;

    ////////////////////////////
    //******** Excute ********//
    ////////////////////////////
    wire e_br_pred_miss;
    wire e_trap;
    reg [11:0] e_inst_31_20;
    reg [4:0] e_rs1_addr;
    reg [2:0] e_funct3;
    reg [31:0] e_pc;
    reg [31:0] e_rs1_data;
    reg [31:0] e_rs2_data;
    reg [31:0] e_imm;
    reg e_alu_in1_sel;
    reg e_alu_in2_sel;
    // RV32I
    // reg [3:0] e_alu_sel;
    // M extension
    // reg [4:0] e_alu_sel;
    reg [5:0] e_alu_sel;
    reg [1:0] e_out_sel;
    reg e_jump;
    reg e_branch;
    reg e_store;
    reg e_zicsr;
    reg e_ecall;
    reg e_mret;
    reg e_illegal_inst;
    always @(posedge clk) begin
        if (rst | (fd_lduse & ~e_ma_stall) | e_br_pred_miss | e_trap) begin
            e_inst_31_20 <= 12'b0;
            e_rs1_addr <= 5'b0;
            e_funct3 <= 3'b0;
            e_rd_addr <= 5'b0;
            e_pc <= 31'b0;
            e_rs1_data <= 31'b0;
            e_rs2_data <= 31'b0;
            e_imm <= 31'b0;
            e_alu_in1_sel <= 1'b0;
            e_alu_in2_sel <= 1'b0;
            //
            //e_alu_sel <= 4'b0;
            // e_alu_sel <= 5'b0;
            e_alu_sel <= 6'b0;
            e_reg_we <= 1'b0;
            e_out_sel <= 2'b0;
            e_jump <= 1'b0;
            e_branch <= 1'b0;
            e_load <= 1'b0;
            e_store <= 1'b0;
            e_zicsr <= 1'b0;
            e_ecall <= 1'b0;
            e_mret <= 1'b0;
            e_illegal_inst <= 1'b0;
        end else if (~e_ma_stall) begin
            e_inst_31_20 <= fd_inst[31:20];
            e_rs1_addr <= fd_inst[19:15];
            e_funct3 <= fd_inst[14:12];
            e_rd_addr <= fd_inst[11:7];
            e_pc <= fd_pc;
            e_rs1_data <= fd_rs1_data;
            e_rs2_data <= fd_rs2_data;
            e_imm <= fd_imm;
            e_alu_in1_sel <= fd_alu_in1_sel;
            e_alu_in2_sel <= fd_alu_in2_sel;
            e_alu_sel <= fd_alu_sel;
            e_reg_we <= fd_reg_we;
            e_out_sel <= fd_e_out_sel;
            e_jump <= fd_jump;
            e_branch <= fd_branch;
            e_load <= fd_load;
            e_store <= fd_store;
            e_zicsr <= fd_zicsr;
            e_ecall <= fd_ecall;
            e_mret <= fd_mret;
            e_illegal_inst <= fd_illegal_inst;
        end
    end

    // Control and Status Registers
    wire [31:0] e_csr_r_data;
    csr csr_0(
        .addr(e_inst_31_20),
        .uimm(e_rs1_addr),
        .rs1_data(e_rs1_data),
        .pc(e_pc),
        .funct3(e_funct3),
        .zicsr(e_zicsr),
        .ecall(e_ecall),
        .mret(e_mret),
        .illegal_inst(e_illegal_inst),
        .rst(rst),
        .clk(clk),
        .r_data(e_csr_r_data)
    );

    // Incrementer
    wire [31:0] e_pc_plus4;
    assign e_pc_plus4 = e_pc + 4;

    // Multiplexer
    wire [31:0] e_alu_in1, e_alu_in2;
    assign e_alu_in1 = (e_alu_in1_sel == `ALU_IN1_SEL_RS1_DATA) ? e_rs1_data : e_pc;
    assign e_alu_in2 = (e_alu_in2_sel == `ALU_IN2_SEL_RS2_DATA) ? e_rs2_data : e_imm;

    // Arithmetic Logic Unit
    wire [31:0] e_alu_out;
    alu alu_0(
        .in1(e_alu_in1),
        .in2(e_alu_in2),
        .sel(e_alu_sel), 
        .out(e_alu_out)
    );

    //adder
    wire [31:0] e_rs1_plus_imm;
    assign e_rs1_plus_imm = e_rs1_data + e_imm;

    // Branch Judgment Unit
    wire e_br_en;
    br_unit br_unit_0(
        .in1(e_rs1_data),
        .in2(e_rs2_data),
        .sel(e_funct3),
        .br_en(e_br_en)
    );

    assign e_br_pred_miss = e_jump | (e_branch & e_br_en);
    assign e_trap = e_ecall | e_illegal_inst;

    // Multiplexer
    assign e_out =
        (e_out_sel == `E_OUT_SEL_ALU_OUT) ? e_alu_out :
        (e_out_sel == `E_OUT_SEL_IMM) ? e_imm :
        (e_out_sel == `E_OUT_SEL_PC_PLUS4) ? e_pc_plus4 : e_csr_r_data;

    // Memory Access Controller
    wire e_second_access;
    ma_ctrl ma_ctrl_0(
        .in_addr(e_rs1_plus_imm),
        .in_data(e_rs2_data),
        .len(e_funct3[1:0]),
        .load(e_load),
        .store(e_store),
        .clk(clk),
        .out_addr(e_mem_rw_addr),
        .out_data(e_mem_w_data),
        .we(e_mem_we),
        .stall(e_ma_stall)
    );

    ////////////////////////////////////////
    //******** Memory & Writeback ********//
    ////////////////////////////////////////
    reg [2:0] mw_funct3;
    reg [31:0] mw_e_out;
    reg mw_load;
    always @(posedge clk) begin
        if (rst) begin
            mw_funct3 <= 3'b0;
            mw_rd_addr <= 5'b0;
            mw_e_out <= 31'b0;
            mw_reg_we <= 1'b0;
            mw_load <= 1'b0;
        end else if (~e_ma_stall) begin
            mw_funct3 <= e_funct3;
            mw_rd_addr <= e_rd_addr;
            mw_e_out <= e_out;
            mw_reg_we <= e_reg_we;
            mw_load <= e_load;
        end
    end

    // Read Data Formatter
    wire [31:0] mw_mem_fmt_r_data;
    r_data_fmt r_data_fmt_0(
        .low_addr(mw_e_out[1:0]),
        .in_data(mw_mem_raw_r_data),
        .len(mw_funct3[1:0]),
        .uns(mw_funct3[2]),
        .e_ma_stall(e_ma_stall),
        .clk(clk),
        .out_data(mw_mem_fmt_r_data)
    );

    assign mw_rd_data = (mw_load) ? mw_mem_fmt_r_data : mw_e_out;

    // Incrementer
    wire [31:0] fd_pc_plus4;
    assign fd_pc_plus4 = fd_pc + 4;
    
    // Multiplexer
    assign next_pc =
        (rst) ? 32'b0 :
        (e_br_pred_miss) ? {e_alu_out[31:2], 2'b0} :
        (e_trap) ? {e_csr_r_data[31:2], 2'b0} :
        fd_pc_plus4;

endmodule

`default_nettype wire