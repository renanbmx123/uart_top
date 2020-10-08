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

  architecture rtl of uart_rx is

    ------------------------Sinais da fifo--------------------------------------------------  
    ----------------------------------------------------------------------------------------
      signal wr_clk,
             rd_clk:    std_logic:='0';
      signal rst:       std_logic;
      signal wr_en:     std_logic;
      signal wr_data :  std_logic_vector(7 downto 0):= (others=>'0');
      signal rd_en:     std_logic;
      signal rd_data:   std_logic_vector(7 downto 0):= (others=>'0');
      signal sts_full:  std_logic;
      signal sts_empty: std_logic;
      signal sts_high:  std_logic;
      signal sts_low:   std_logic;
      signal sts_error: std_logic;
      
    ------------------------Sinais da Comuns--------------------------------------------------  
    ------------------------------------------------------------------------------------------
      signal clock_in: std_logic;
      signal reset_in: std_logic;
    ------------------------Sinais do RX------------------------------------------------------  
    ------------------------------------------------------------------------------------------
      --signal uart_rate_rx_sel: std_logic_vector(1 downto 0);  
      --signal data_p_en_out:    std_logic;
      --signal uart_data_rx:     std_logic;
      --signal data_p_out:       std_logic_vector(7 downto 0);
     
      
      
      
    ------------------------Sinais do TX------------------------------------------------------  
    ------------------------------------------------------------------------------------------ 
      --signal uart_rate_tx_sel: std_logic_vector(1 downto 0);
      --signal data_p_en_in:     std_logic;
      --signal uart_data_tx:     std_logic;
      --signal data_p_in:        std_logic_vector(7 downto 0);
      
      
      
       
  begin
      
      FIFO_ASYNC: entity work.FIFO_ASYNC
      port map
      (
          wr_clk    => wr_clk,   rd_clk   => rd_clk,   rst      => rst,      wr_en     => wr_en, 
          rd_en     => rd_en,    rd_data  => rd_data,  sts_full => sts_full, sts_empty => sts_empty, 
          wr_data   => wr_data,  sts_high => sts_high, sts_low  => sts_low,  sts_error => sts_error
      );
      
      UART_BAUD_CLK: entity work.UART_BAUD_CLK
      port map
      (
          baud_clk => baud_clk, reset_in => reset_in,
          clock_in => clock_in, uart_rate_sel => uart_rate_rx_sel     
      );
      
      UART_RX: entity work.UART_TX
      port map
      ( 
      clock_in         => clock_in, 
      reset_in         => reset_in, 
      data_p_in       => data_p_in,
      uart_data_tx     => uart_data_tx,
      data_p_en_in    => data_p_en_in,
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
  