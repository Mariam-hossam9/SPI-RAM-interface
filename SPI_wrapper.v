module SPI_Wrapper( MOSI, SS_n, clk, rst_n, MISO);

    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE =8;

    input MOSI,SS_n,clk,rst_n;
    output MISO ;

    wire [9:0] rx_data;
    wire rx_valid;
    wire [7:0] tx_data;
    wire tx_valid;

    // Instantiate the SPI slave interface
    SPI_SLAVE SPI_Slave_interface(
        .MOSI(MOSI),
        .SS_n(SS_n),
        .tx_valid(tx_valid),
        .tx_data(tx_data),
        .clk(clk),
        .rst_n(rst_n),
        .rx_data(rx_data),
        .rx_valid(rx_valid),
        .MISO(MISO)
        );

    // Instantiate the RAM module
    Single_port_Async_RAM #(MEM_DEPTH,ADDR_SIZE) SPA_RAM(
        .din(rx_data),
        .clk(clk),
        .rst_n(rst_n),
        .rx_valid(rx_valid),
        .dout(tx_data),
        .tx_valid(tx_valid)
        );

endmodule
