vlib work 
vlog single_port_RAM.v SPI_slave.v SPI_wrapper.v SPI_wrapper_tb.v
vsim -voptargs=+acc work.SPI_Wrapper_tb
add wave *
add wave -r /SPI_Wrapper_tb/DUT/SPA_RAM/dout 
add wave -r /SPI_Wrapper_tb/DUT/SPA_RAM/din 
add wave -r /SPI_Wrapper_tb/DUT/SPI_Slave_interface/tx_valid 
add wave -r /SPI_Wrapper_tb/DUT/SPI_Slave_interface/tx_data 
add wave -r /SPI_Wrapper_tb/DUT/SPI_Slave_interface/rx_data 
add wave -r /SPI_Wrapper_tb/DUT/SPI_Slave_interface/rx_valid 
add wave -r /SPI_Wrapper_tb/DUT/SPI_Slave_interface/ns
add wave -r /SPI_Wrapper_tb/DUT/SPI_Slave_interface/cs
add wave -r /SPI_Wrapper_tb/DUT/SPI_Slave_interface/bit_count 
add wave -r /SPI_Wrapper_tb/DUT/SPA_RAM/mem 
run -all
#quit -sim