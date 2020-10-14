library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity uart_top_tb is
end    uart_top_tb;

architecture TB of uart_top_tb is
  signal  clock_in:           std_logic;
  signal  reset_in:           std_logic;
    -- Uart RX
  signal uart_rate_rx_sel:   std_logic_vector(1 downto 0);
  signal data_p_en_out:     std_logic;
  signal uart_data_rx:       std_logic;
  signal data_p_out:        std_logic_vector(7 downto 0);
    -- Uart TX
  signal uart_rate_tx_sel:   std_logic_vector(1 downto 0));
  signal data_p_en_in:       std_logic;
  signal data_p_in:          std_logic_vector(7 downto 0);
  signal uart_data_tx:      std_logic;
  
begin
    uart_top_tb: entity work.uart_top 
    port 
    map(
        
        clock_in         => clock_in,
        reset_in         => reset_in,
        data_p_out       => data_p_out,
        data_p_en_out    => data_p_en_out,
        uart_data_rx     => uart_data_rx,
        uart_rate_rx_sel => uart_rate_rx_sel,
        data_p_in        => data_p_in,
        data_p_en_in     => data_p_en_in,
        uart_data_tx     => uart_data_tx,
        uart_rate_tx_sel => uart_rate_tx_sel);
        process
        begin
          wait for 10 ns;
          clock_in <= not clock_in;
        end process;
      
end TB;
