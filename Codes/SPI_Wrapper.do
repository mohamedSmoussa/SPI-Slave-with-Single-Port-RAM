vlib work
vlog SPI_Wrapper.v SPI_Wrapper_Tb.v
vsim -voptargs=+acc work.SPI_Wrapper_Tb
add wave -color white -height 27 sim:/SPI_Wrapper_Tb/MISO
add wave -color cyan -height 27 sim:/SPI_Wrapper_Tb/TEST/tx_valid
add wave -radix binary -color orange -height 27 sim:/SPI_Wrapper_Tb/TEST/tx_data
add wave -radix binary -color orange -height 27 sim:/SPI_Wrapper_Tb/data
add wave -color cyan -height 27 sim:/SPI_Wrapper_Tb/TEST/rx_valid
add wave -height 27 sim:/SPI_Wrapper_Tb/TEST/rx_data
add wave -height 27 sim:/SPI_Wrapper_Tb/TEST/SPI_MS/clk_count
add wave -height 27 sim:/SPI_Wrapper_Tb/MOSI
add wave -height 27 sim:/SPI_Wrapper_Tb/SS_n
add wave -height 27 sim:/SPI_Wrapper_Tb/clk
add wave -height 27 sim:/SPI_Wrapper_Tb/rst_n
add wave -color yellow -height 27 sim:/SPI_Wrapper_Tb/TEST/SPI_MS/cs
add wave -color yellow -height 27 sim:/SPI_Wrapper_Tb/TEST/SPI_MS/ns
add wave -color violetred -height 27 sim:/SPI_Wrapper_Tb/addr
add wave -color violetred -height 27 sim:/SPI_Wrapper_Tb/TEST/MEM/wr_Addr
add wave -color violetred -height 27 sim:/SPI_Wrapper_Tb/TEST/MEM/rd_Addr
add wave -height 27 sim:/SPI_Wrapper_Tb/TEST/MEM/mem
run -all