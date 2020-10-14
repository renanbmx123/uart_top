library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity UART_TOP is
    port (
        -- sinais comuns
        clock_in:         in  std_logic;
        reset_in:         in  std_logic;
        -- Uart RX
        data_p_out:       out std_logic_vector(7 downto 0);
        data_p_en_out:    out std_logic;
        uart_data_rx:     in  std_logic;
        uart_rate_rx_sel: in  std_logic_vector(1 downto 0);
        -- Uart TX
        data_p_in:        in  std_logic_vector(7 downto 0);
        data_p_en_in:     in  std_logic;
        uart_data_tx:     out std_logic;
        uart_rate_tx_sel: in  std_logic_vector(1 downto 0));
  end UART_TOP;

  architecture rtl of UART_TOP is
      
  begin
            
      UART_RX: entity work.UART_TX
      port map
      ( 
      clock_in         => clock_in, 
      reset_in         => reset_in, 
      data_p_in        => data_p_in,
      uart_data_tx     => uart_data_tx,
      data_p_en_in     => data_p_en_in,
      uart_rate_tx_sel => uart_rate_tx_sel
  
      );

      UART_TX: entity work.UART_RX
      port map
      ( 
        clock_in         => clock_in, 
        reset_in         => reset_in, 
        data_p_out       => data_p_out,
        uart_data_rx     => uart_data_rx,
        data_p_en_out    => data_p_en_out,
        uart_rate_rx_sel => uart_rate_rx_sel
      );
    
  end rtl;
  