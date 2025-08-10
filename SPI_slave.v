//============================================================
// SPI_SLAVE
// Simple SPI slave module with basic command handling
//============================================================
module SPI_SLAVE (
    input  wire       MOSI,        // Master Out, Slave In
    input  wire       SS_n,        // Slave Select (active low)
    input  wire       tx_valid,    // TX data valid flag
    input  wire       clk,         // System clock
    input  wire       rst_n,       // Active-low reset
    input  wire [7:0] tx_data,     // Data to send to master
    output reg  [9:0] rx_data,     // Received data (10 bits)
    output reg        rx_valid,    // Received data valid flag
    output reg        MISO         // Master In, Slave Out
);

    //--------------------------------------------------------
    // FSM State Encoding
    //--------------------------------------------------------
    localparam IDLE       = 3'b000;
    localparam CHK_CMD    = 3'b001;
    localparam WRITE      = 3'b010;
    localparam READ_ADDR  = 3'b011;
    localparam READ_DATA  = 3'b100;

    //--------------------------------------------------------
    // Internal Registers
    //--------------------------------------------------------
    reg [2:0] cs, ns;              // Current and Next State
    reg       rd_addr_data;        // Read address/data select
    reg [3:0] bit_count;           // Bit counter for shifting
    reg [9:0] rx_shift_reg;        // Shift register for incoming bits
    reg       send_data;           // Data send flag

    //--------------------------------------------------------
    // State Register
    //--------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cs <= IDLE;
        else
            cs <= ns;
    end

    //--------------------------------------------------------
    // Next-State Logic
    //--------------------------------------------------------
    always @(*) begin
        ns = cs;
        case (cs)
            IDLE:
                ns = (!SS_n) ? CHK_CMD : IDLE;

            CHK_CMD:
                ns = (SS_n) ? IDLE :
                     (bit_count == 9) ?
                        (!rx_shift_reg[9] ? WRITE :
                        (!rd_addr_data ? READ_ADDR : READ_DATA))
                     : CHK_CMD;

            WRITE:
                ns = (SS_n) ? IDLE : WRITE;

            READ_ADDR:
                ns = (SS_n) ? IDLE : READ_ADDR;

            READ_DATA:
                ns = (SS_n) ? IDLE : READ_DATA;
        endcase
    end

    //--------------------------------------------------------
    // Data Handling Logic
    //--------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_count     <= 0;
            rx_shift_reg  <= 0;
            rd_addr_data  <= 0;
            rx_valid      <= 0;
            MISO          <= 0;
            send_data     <= 0;
        end else begin
            // Default value
            rx_valid <= 0;

            case (cs)
                //------------------------------------------------
                IDLE: begin
                    bit_count <= 0;
                    MISO      <= 0;
                    rx_valid  <= 0;
                end

                //------------------------------------------------
                CHK_CMD: begin
                    if (bit_count < 9) begin
                        // Shift in incoming MOSI bit
                        rx_shift_reg <= {rx_shift_reg[8:0], MOSI};
                        bit_count    <= bit_count + 1;
                    end
                    else if (bit_count == 9) begin
                        // Final bit capture
                        rx_data      <= {rx_shift_reg[8:0], MOSI};
                        rx_valid     <= 1;
                        rd_addr_data <= rx_shift_reg[8];

                        // Prepare if TX data is already valid
                        if (tx_valid)
                            bit_count <= 9;
                    end
                end

                //------------------------------------------------
                WRITE: begin
                    rx_valid  <= 1;
                    bit_count <= 0;
                end

                //------------------------------------------------
                READ_ADDR: begin
                    rx_valid  <= 1;
                    bit_count <= 0;
                end

                //------------------------------------------------
                READ_DATA: begin
                    if (bit_count == 9) begin
                        // Wait one cycle for data to load
                        bit_count <= bit_count - 1;
                    end
                    else if (bit_count > 0) begin
                        // Shift out TX data bit-by-bit
                        MISO          <= tx_data[bit_count - 1];
                        rx_shift_reg  <= {rx_shift_reg[8:0], MOSI};
                        bit_count     <= bit_count - 1;
                    end
                    else begin
                        // Transfer complete
                        rx_data      <= rx_shift_reg;
                        rx_valid     <= 1;
                        rd_addr_data <= 0;
                        send_data    <= 0;
                        MISO         <= 0;
                    end
                end
            endcase

            //------------------------------------------------
            // Reset counters when SS_n is high
            //------------------------------------------------
            if (SS_n) begin
                bit_count <= 0;
                send_data <= 0;
            end
        end
    end

endmodule
