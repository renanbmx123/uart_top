#!/bin/bash
## Compilar e gerar forma de onda
ghdl -a --std=08 -frelaxed-rules --ieee=synopsys ./Modulos/fifo_async.vhd ./Modulos/uart_baud_clk.vhd ./UART_RX/uart_rx.vhd ./UART_TX/uart_tx.vhd ./UART/uart_top.vhd
ghdl -e --std=08 -frelaxed-rules --ieee=synopsys uart_top
ghdl -r --std=08 -frelaxed-rules --ieee=synopsys uart_rx_tb --wave=./Wave/uart_rx.ghw --stop-time=70ms

