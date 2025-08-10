module Single_port_Async_RAM (
    input  [9:0] din,       // 10-bit input: [9:8]=command, [7:0]=data or address
    input        clk,       // Clock
    input        rst_n,     // Active-low reset
    input        rx_valid,  // Input valid signal
    output reg [7:0] dout,  // Output data from memory
    output reg   tx_valid   // Output valid signal
);

    // Parameters
    parameter MEM_DEPTH = 256;   // Memory depth
    parameter ADDR_SIZE = 8;     // Address size

    // Internal memory
    reg [7:0] mem [MEM_DEPTH-1:0];         // 256 x 8-bit single-port memory
    reg [ADDR_SIZE-1:0] write_addr_hold;   // Holds write address
    reg [ADDR_SIZE-1:0] read_addr_hold;    // Holds read address

    // Sequential logic for memory operations
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Reset registers
            dout            <= 0;
            tx_valid        <= 0;
            write_addr_hold <= 0;
            read_addr_hold  <= 0;
        end 
        else begin
            tx_valid <= 0; // Default: no output unless read command occurs
            
            if (rx_valid) begin
                case (din[9:8]) 
                    2'b00: write_addr_hold <= din[7:0];           // Store write address
                    2'b01: mem[write_addr_hold] <= din[7:0];      // Write data
                    2'b10: read_addr_hold <= din[7:0];            // Store read address
                    2'b11: begin
                        dout     <= mem[read_addr_hold];          // Read data
                        tx_valid <= 1;                            // Valid output
                    end
                endcase
            end
        end
    end

endmodule
