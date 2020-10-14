## DEFINE VARS
set sdc_version 1.5
set_load_unit -picofarads 1

## INPUTS
set_input_transition -min -rise 0.003 [get_ports reset_in]
set_input_transition -max -rise 0.16 [get_ports reset_in]
set_input_transition -min -fall 0.003 [get_ports reset_in]
set_input_transition -max -fall 0.16 [get_ports reset_in]

set_input_transition -min -rise 0.003 [get_ports uart_rate_rx_sel]
set_input_transition -max -rise 0.16 [get_ports uart_rate_rx_sel]
set_input_transition -min -fall 0.003 [get_ports uart_rate_rx_sel]
set_input_transition -max -fall 0.16 [get_ports uart_rate_rx_sel]

set_input_transition -min -rise 0.003 [get_ports uart_rate_tx_sel]
set_input_transition -max -rise 0.16 [get_ports uart_rate_tx_sel]
set_input_transition -min -fall 0.003 [get_ports uart_rate_tx_sel]
set_input_transition -max -fall 0.16 [get_ports uart_rate_tx_sel]

set_input_transition -min -rise 0.003 [get_ports uart_data_rx]
set_input_transition -max -rise 0.16 [get_ports uart_data_rx]
set_input_transition -min -fall 0.003 [get_ports uart_data_rx]
set_input_transition -max -fall 0.16 [get_ports uart_data_rx]

set_input_transition -min -rise 0.003 [get_ports uart_data_tx]
set_input_transition -max -rise 0.16 [get_ports uart_data_tx]
set_input_transition -min -fall 0.003 [get_ports uart_data_tx]
set_input_transition -max -fall 0.16 [get_ports uart_data_tx]

## CLOCK
create_clock -name clk_in -period 20 [get_ports clock_in]


## OUTPUTS
set_load -min 0.0014 [all_outputs]
set_load -max 0.32 [all_outputs]
