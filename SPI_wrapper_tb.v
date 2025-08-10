//------------------------------------------------------------
// Title       : SPI Wrapper Testbench
// File        : SPI_Wrapper_tb.v
// Author      : Mariam Hassam
// Description : Testbench for SPI_Wrapper module.
//               Simulates multiple transactions including:
//                 1. Write address + Write data
//                 2. Read address + Read data
//               Uses helper tasks for sending bits and bytes.
//
// Created On  : 2/8/2025
//------------------------------------------------------------

module SPI_Wrapper_tb();

    // Testbench signals
    reg MOSI;
    reg SS_n;
    reg clk;
    reg rst_n;
    wire MISO;

    // DUT instantiation
    SPI_Wrapper DUT (
        .MOSI(MOSI),
        .SS_n(SS_n),
        .clk(clk),
        .rst_n(rst_n),
        .MISO(MISO)
    );

    //--------------------------------------------------------
    // Clock generation (10 time unit period)
    //--------------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //--------------------------------------------------------
    // Main test sequence
    //--------------------------------------------------------
    initial begin
        // Initialize and reset
        MOSI = 0;
        SS_n = 1;
        rst_n = 0;
        @(negedge clk);
        rst_n = 1;

        //----------------------------------------------------
        // First Transaction
        //----------------------------------------------------
        // Write address
        @(negedge clk);
        SS_n = 0; MOSI = 0;
        @(negedge clk);
        send_byte(10'h0FF);
        repeat (3) @(negedge clk);
        SS_n = 1;

        // Write data
        @(negedge clk);
        SS_n = 0; MOSI = 0;
        @(negedge clk);
        send_byte(10'h1B1);
        repeat (3) @(negedge clk);
        SS_n = 1;

        // Read address
        repeat (3) @(negedge clk);
        SS_n = 0; MOSI = 1;
        @(negedge clk);
        send_byte(10'h2FF);
        repeat (3) @(negedge clk);
        SS_n = 1;

        // Read data
        @(negedge clk);
        SS_n = 0; MOSI = 1;
        @(negedge clk);
        send_byte(10'h3BC);
        repeat (14) @(negedge clk);
        SS_n = 1;

        //----------------------------------------------------
        // Second Transaction
        //----------------------------------------------------
        repeat (3) @(negedge clk);
        SS_n = 0; MOSI = 0;
        @(negedge clk);
        send_byte(10'h0FE);
        repeat (3) @(negedge clk);
        SS_n = 1;

        // Write data
        @(negedge clk);
        SS_n = 0; MOSI = 0;
        @(negedge clk);
        send_byte(10'h1AA);
        repeat (3) @(negedge clk);
        SS_n = 1;

        // Read address
        @(negedge clk);
        SS_n = 0; MOSI = 1;
        @(negedge clk);
        send_byte(10'h2FE);
        repeat (3) @(negedge clk);
        SS_n = 1;

        // Read data
        repeat (3) @(negedge clk);
        SS_n = 0; MOSI = 1;
        @(negedge clk);
        send_byte(10'h3AE);
        repeat (14) @(negedge clk);
        SS_n = 1;

        //----------------------------------------------------
        // Third Transaction
        //----------------------------------------------------
        repeat (3) @(negedge clk);
        SS_n = 0; MOSI = 0;
        @(negedge clk);
        send_byte(10'h0FD);
        repeat (3) @(negedge clk);
        SS_n = 1;

        // Write data
        @(negedge clk);
        SS_n = 0; MOSI = 0;
        @(negedge clk);
        send_byte(10'h1BB);
        repeat (3) @(negedge clk);
        SS_n = 1;

        // Read address
        @(negedge clk);
        SS_n = 0; MOSI = 1;
        @(negedge clk);
        send_byte(10'h2FD);
        repeat (3) @(negedge clk);
        SS_n = 1;

        // Read data
        repeat (3) @(negedge clk);
        SS_n = 0; MOSI = 1;
        @(negedge clk);
        send_byte(10'h3AE);
        repeat (14) @(negedge clk);
        repeat (3) @(negedge clk);
        SS_n = 1;

        //----------------------------------------------------
        // End simulation
        //----------------------------------------------------
        $stop;
    end

    //--------------------------------------------------------
    // Helper task to send a single bit
    //--------------------------------------------------------
    task send_bit(input reg data);
        begin
            MOSI = data;
            @(negedge clk); 
        end
    endtask

    //--------------------------------------------------------
    // Helper task to send 10-bit data (MSB first)
    //--------------------------------------------------------
    task send_byte(input [9:0] data);
        integer i;
        begin
            for (i = 9; i >= 0; i = i - 1) begin
                send_bit(data[i]);
            end
        end
    endtask

endmodule
