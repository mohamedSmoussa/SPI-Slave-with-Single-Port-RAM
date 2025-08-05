module SPI_Wrapper (MOSI,SS_n,clk,rst_n,MISO); //// top module
input MOSI,SS_n,clk,rst_n;
output MISO;
wire [9:0] rx_data;
wire [7:0] tx_data;
wire tx_valid,rx_valid;
SPI SPI_MS(MOSI,SS_n,clk,rst_n,tx_data,tx_valid,rx_data,rx_valid,MISO);
Single_Port_RAM MEM(rx_data,rx_valid,clk,rst_n,tx_data,tx_valid);

endmodule //SPI_Wrapper