//==============================================================================
// tb_sect233r1_pt_mul.sv
//
// Testbench of module sect233r1_pt_mul.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


`timescale 1ns / 1ps


module tb_sect233r1_pt_mul;

//------------------------------------------------------------------------------
// Parameters
parameter ClkPeriod = 10.0;
parameter Dly = 1.0;
parameter string TcRefDir = "../../case/sect233r1/ref";
parameter string TcRtlDir = "../../case/sect233r1/rtl";


// Global variables
string testname;
bit [232:0] d_ref;
bit [232:0] x_ref;
bit [232:0] y_ref;
bit [232:0] x_rtl;
bit [232:0] y_rtl;
int fp_ref;
int fp_rtl;
int num_test;
int num_fail;


// Signals
logic clk;
logic rst_n;
logic clr;
logic start;
logic [232:0] d;
logic done;
logic [232:0] x;
logic [232:0] y;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Instance
sect233r1_pt_mul u_sect233r1_pt_mul (.*);


// System signals
initial begin
    clk = 1'b0;
    #(ClkPeriod/2);
    forever #(ClkPeriod/2)    clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    #(ClkPeriod*4);
    rst_n = 1'b1;
end
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Driver
task driver;
    #(ClkPeriod*10);
    @(posedge clk);    #Dly;
    start = 1'b1;
    d = d_ref;
    @(posedge clk);    #Dly;
    start = 1'b0;
    d = 233'h0;
endtask


// Monitor
task monitor;
    @(posedge done);
    @(posedge clk);    #Dly;
    x_rtl = x;
    y_rtl = y;

    $fwrite(fp_rtl, "%x\n", d_ref);
    $fwrite(fp_rtl, "%x\n", x_rtl);
    $fwrite(fp_rtl, "%x\n\n", y_rtl);
endtask


// Compare reference and RTL data
task compare;
    if (x_ref != x_rtl || y_ref != y_rtl) begin
        $display("Fail");
        num_fail++;
    end
    else begin
        $display("Pass");
    end
endtask


// Run each testcase data
task run_tc;
    num_test++;
    $display("[INFO]  Running testcase #%0d", num_test);

    fork
        driver;
        monitor;
    join
    #(ClkPeriod*10);
    compare;
endtask


// Parse testcase file
task parse_tc;
    string fn_ref;
    string fn_rtl;
    string str_line;
    int code;
    int str_len;
    int state_rd;

    fn_ref = {TcRefDir, "/", testname, ".txt"};
    fp_ref = $fopen(fn_ref, "r");
    if (fp_ref == 0) begin
        $display("[ERROR]  Fail to open file %s for reading.", fn_ref);
        $finish;
    end

    fn_rtl = {TcRtlDir, "/", testname, "_rtl.txt"};
    fp_rtl = $fopen(fn_rtl, "w");
    if (fp_rtl == 0) begin
        $display("[ERROR]  Fail to open file %s for writing.", fn_rtl);
        $finish;
    end

    state_rd = 0;
    while (1) begin
        code = $fgets(str_line, fp_ref);
        if ($feof(fp_ref) || (code == 0))    break;
        str_len = str_line.len();
        if (str_len <= 1)    continue;    // blank line
        str_line = str_line.substr(0, str_len-2);    // drop newline
        if (state_rd == 0) begin
            code = $sscanf(str_line, "%x", d_ref);
            state_rd = 1;
        end
        else if (state_rd == 1) begin
            code = $sscanf(str_line, "%x", x_ref);
            state_rd = 2;
        end
        else if (state_rd == 2) begin
            code = $sscanf(str_line, "%x", y_ref);
            state_rd = 0;
            run_tc;
        end
        else begin
            $display("[ERROR]  Invalid state_rd value %0d.", state_rd);
            $finish;
        end
    end

    $fclose(fp_ref);
    $fclose(fp_rtl);
endtask


// Run simulation
task run_sim;
    parameter StrPass = {
        "                   \n",
        "               #   \n",
        "              #    \n",
        "             #     \n",
        "     #      #      \n",
        "      #    #       \n",
        "       #  #        \n",
        "        ##         \n",
        "                   \n"
    };
    parameter StrFail = {
        "                   \n",
        "    #           #  \n",
        "      #       #    \n",
        "        #   #      \n",
        "          #        \n",
        "        #   #      \n",
        "      #       #    \n",
        "    #           #  \n",
        "                   \n"
    };

    num_test = 0;
    num_fail = 0;

    clr = 1'b0;
    start = 1'b0;
    d = 233'h0;

    #(ClkPeriod*10);
    @(posedge clk);    #Dly;
    clr = 1'b1;
    @(posedge clk);    #Dly;
    clr = 1'b0;

    parse_tc;

    $display("[INFO]  Simulation complete.");
    if (num_fail == 0) begin
        $display("%s", StrPass);
        $display("PASS  (Total %0d)", num_test);
    end
    else begin
        $display("%s", StrFail);
        $display("FAIL  (Total %0d / Fail %0d)", num_test, num_fail);
    end
endtask
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Main process
initial begin
    if ($value$plusargs("TESTNAME=%s", testname)) begin
        $display("[INFO]  Test name \"%s\" is loaded.", testname);
    end
    else begin
        $display("[ERROR]  Test name is not specified. Should use runtime option \"+TESTNAME=testname\"");
        $finish;
    end

    run_sim;

    #(ClkPeriod*100);
    $finish;
end
//------------------------------------------------------------------------------


endmodule
