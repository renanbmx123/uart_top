
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity UART_RX is
  port (
  clock_in:         in  std_logic;
  reset_in:         in  std_logic;
  data_p_out:       out std_logic_vector(7 downto 0);
  data_p_en_out:    out std_logic;
  uart_data_rx:     in  std_logic;
  uart_rate_rx_sel: in  std_logic_vector(1 downto 0)
       );
end UART_RX;

architecture rtl of uart_rx is

  signal baud_clk: std_logic;
  signal data: std_logic_vector(7 downto 0):= "00000000";
  signal data_en_out: std_logic:='0';
  --signal start_bit: std_logic;

  ----------------------------------------------------------------------------------------
  ------------------------Maq Estados escrita---------------------------------------------
  type FSM is (idle, recv_data, stop_bit);
  signal state  : FSM:= idle;
 
  ------------------------Sinais da fifo--------------------------------------------------  
  ----------------------------------------------------------------------------------------
    signal wr_clk,rd_clk: std_logic:='0';
    signal rst: std_logic;
    signal wr_en: std_logic;
    signal wr_data : std_logic_vector(7 downto 0):= (others=>'0');
    signal rd_en: std_logic;
    signal rd_data: std_logic_vector(7 downto 0):= (others=>'0');

    signal sts_full: std_logic;
    signal sts_empty: std_logic;
    signal sts_high: std_logic;
    signal sts_low: std_logic;
    signal sts_error: std_logic;
    
    
begin
    
    FIFO_ASYNC: entity work.FIFO_ASYNC
    port map
    (
        wr_clk    => wr_clk,
        rd_clk    => rd_clk,
        rst       => rst,
        wr_en     => wr_en,
        wr_data   => wr_data,
        rd_en     => rd_en,
        rd_data   => rd_data,
        sts_full  => sts_full,
        sts_empty => sts_empty,
        sts_high  => sts_high,
        sts_low   => sts_low,
        sts_error => sts_error
    );
    
    UART_BAUD_CLK: entity work.UART_BAUD_CLK
    port map
    (
        baud_clk => baud_clk,
        reset_in => reset_in,
        clock_in => clock_in,  
        uart_rate_sel => uart_rate_rx_sel     
    );


  data_p_en_out <= data_en_out;
  wr_clk <= baud_clk;
  rd_clk <= clock_in;

  rd_uart:process(clock_in)
  variable read: integer:= 1; 
  begin
    if (clock_in'event and clock_in = '1') then
      if( sts_empty = '0') then
        rd_en <= '1';
        data_en_out <='1';
        data_p_out <= rd_data;
      else 
        rd_en <= '0';
        data_p_out <= x"00";
        data_en_out <='0';
      end if;         
    end if;
  end process;

  wr_uart:process(reset_in, baud_clk)
  variable bit_count: integer :=0;
  begin
    
    if (reset_in = '1' ) then

       --uart_data_rx <= '0';
    else if (baud_clk'event and baud_clk = '1') then
        case state is
        when idle =>
            wr_en <= '0';
            wr_data <= x"00";
            -- Inicio do recebimento do dado.
            -- mudar stado. 
            if (uart_data_rx = '0') then
		state <= recv_data ;
            end if;
            
        when recv_data =>
            data <= data(data'high -1 downto data'low) & uart_data_rx;            
            
            bit_count := bit_count + 1;
            if (bit_count = 8) then
                bit_count :=0;
                state <= stop_bit;
            end if;
        when stop_bit =>
            wr_en <= '1' when sts_full = '0';
            wr_data <= data ;
            state <= idle;
        end case;
       
      end if;
    end if;
    
  end process;
  
end rtl;
