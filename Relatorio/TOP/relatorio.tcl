set_db library /soft64/design-kits/stm/65nm-cmos065_536/CORE65GPSVT_5.1/libs/CORE65GPSVT_nom_1.00V_25C.lib

read_hdl -vhdl ./fifo_async.vhd 
read_hdl -vhdl ./uart_baud_clk.vhd 
read_hdl -vhdl ./uart_top.vhd 

elaborate UART_TOP

read_sdc ./constraints.sdc

synthesize -to_generic -eff high
synthesize -to_mapped -eff high