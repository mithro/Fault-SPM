/*
    Automatically generated by Fault
    Do not modify.
    Generated on: 2021-01-29 09:41:01
*/

/* Need to export PDK_ROOT */
`include "libs.ref/sky130_fd_sc_hd/verilog/primitives.v"
`include "libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v"

`ifdef GL
    `include "gl/user_proj_top.v"
`else
    `include "dft/2-user_proj_top.tap.v"
`endif

module testbench;
    reg[0:0] \tms ;
    reg[0:0] \tdi ;
    reg[0:0] \prod_sel ;
    reg[31:0] \mc ;
    reg[31:0] \mp ;
    wire[0:0] \tdo ;
    wire[0:0] \tdo_paden_o ;
    wire[0:0] \done ;
    reg[0:0] \tck ;
    reg[0:0] \clk ;
    reg[0:0] \trst ;
    wire[31:0] \prod ;
    reg[0:0] \start ;
    reg[0:0] \rst ;
    wire[169:0] \tie ;


    always #2 clk = ~clk;
    always #10 tck = ~tck;

    user_proj_top uut(
    `ifdef USE_POWER_PINS
        .VPWR(1'b1),
        .VGND(1'b0),
    `endif
        .\tms ( \tms ) , .\tdi ( \tdi ) , .\prod_sel ( \prod_sel ) , .\mc ( \mc ) , .\mp ( \mp ) , .\tdo ( \tdo ) , .\tdo_paden_o ( \tdo_paden_o ) , .\done ( \done ) , .\tck ( \tck ) , .\clk ( \clk ) , .\trst ( \trst ) , .\prod ( \prod ) , .\start ( \start ) , .\rst ( \rst ) , .\tie ( \tie ) 
    );    

    integer i;

    wire[470:0] serializable =
        471'b000000010101111101000011111101110100110110111111101111010100010101010011010101110111000110011110110100001110100011001110001010000001110110111011000101110101101001101111000110110000110011011010000100010000011000011111111000000100011000110111001001010100101001110000110111001000000010111100011100101100000111100100011100001001101000011010000000001011011001010101011011010011010100110111111011001010101000110011111011110011000111110111000110011001001001010010100101101000001;
    reg[470:0] serial;

    wire[7:0] tmsPattern = 8'b 01100110;
    wire[3:0] preload_chain = 4'b0011;

    initial begin
        $dumpfile("dut.vcd");
        $dumpvars(0, testbench);
        \mc = 0 ;
        \mp = 0 ;
        \clk = 0 ;
        \rst = 1 ;
        \start = 0 ;
        \prod_sel = 0 ;
        \tms = 0 ;
        \tck = 0 ;
        \tdi = 0 ;
        \trst = 0 ;

        tms = 1;
        #20;
        rst = ~rst;
        trst = 1;        
        #20;

        /*
            Test PreloadChain Instruction
        */
        shiftIR(preload_chain);
        enterShiftDR();

        for (i = 0; i < 471; i = i + 1) begin
            tdi = serializable[i];
            #20;
        end
        for(i = 0; i< 471; i = i + 1) begin
            serial[i] = tdo;
            #20;
        end 

        if(serial !== serializable) begin
            $error("EXECUTING_PRELOAD_CHAIN_INST_FAILED");
            $finish;
        end
        exitDR();

        $display("SUCCESS_STRING");
        $finish;
    end

    task shiftIR;
        input[3:0] instruction;
        integer i;
        begin
            for (i = 0; i< 5; i = i + 1) begin
                tms = tmsPattern[i];
                #20;
            end

            // At shift-IR: shift new instruction on tdi line
            for (i = 0; i < 4; i = i + 1) begin
                tdi = instruction[i];
                if(i == 3) begin
                    tms = tmsPattern[5];     // exit-ir
                end
                #20;
            end

            tms = tmsPattern[6];     // update-ir 
            #20;
            tms = tmsPattern[7];     // run test-idle
            #60;
        end
    endtask

    task enterShiftDR;
        begin
            tms = 1;     // select DR
            #20;
            tms = 0;     // capture DR -- shift DR
            #40;
        end
    endtask

    task exitDR;
        begin
            tms = 1;     // Exit DR -- update DR
            #40;
            tms = 0;     // Run test-idle
            #20;
        end
    endtask
endmodule
