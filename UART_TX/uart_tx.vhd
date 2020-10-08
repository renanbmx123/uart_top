library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity UART_TX is
  port (
  clock_in:         in  std_logic;
  reset_in:         in  std_logic;
  data_p_in:        in  std_logic_vector(7 downto 0);
  data_p_en_in:     in  std_logic;
  uart_data_tx:     out std_logic;
  uart_rate_tx_sel: in  std_logic_vector(1 downto 0)
       );
end UART_TX;

architecture rtl of UART_TX is


  signal baud_clk: std_logic;
  signal data_fifo: std_logic_vector(0 to 7);

  ----------------------------------------------------------------------------------------
  ------------------------Maq Estados escrita---------------------------------------------
  type FSM1 is (idle, reading_data, stop_reading);
  type FSM2 is (idle, reading_fifo, sending_data, stop_send);

  signal state_read  : FSM1:= idle;
  signal state_send  : FSM2:= idle;
 
  ------------------------Sinais da fifo--------------------------------------------------  
  ----------------------------------------------------------------------------------------
    signal wr_clk,rd_clk: std_logic:='0';
    signal rst: std_logic;
    signal wr_en: std_logic:= '0';
    signal wr_data : std_logic_vector(7 downto 0):= (others=>'0');
    signal rd_en: std_logic:= '0';
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
        uart_rate_sel => uart_rate_tx_sel     
    );

  wr_clk <= clock_in;
  rd_clk <= baud_clk;

  send_data:process(reset_in, baud_clk)
  variable bit_count: integer:= 0;
  begin
  if (reset_in = '1') then
    state_send <= idle;
  else if (baud_clk'event and baud_clk = '1') then
    case state_send is
      when idle         =>
        if( sts_empty = '0') then
          rd_en <= '1';
          state_send <= reading_fifo;
        else 
          uart_data_tx <= '1';
        end if;         

      when reading_fifo =>
        data_fifo <= rd_data;
        rd_en <= '0';
        state_send <= sending_data;
      when sending_data =>
        if (bit_count = 0) then
          uart_data_tx <= '0';
          else  if (bit_count = 8) then
            uart_data_tx <= '1';
            state_send <= stop_send;
            else
              uart_data_tx <= data_fifo(bit_count);    
            end if; 
        end if;
        bit_count := bit_count + 1;
      when stop_send    =>
        bit_count:= 0;
        state_send <= idle;
      end case;
    
   
  end if;
  end if;
     
  end process;

  read_data:process(reset_in, clock_in)
  begin
    if (reset_in = '1') then
      state_read <= idle;
      elsif (clock_in'event and clock_in = '1') then
        case state_read is
          when idle =>
          if (data_p_en_in = '1') then
           
            state_read <= reading_data;
          end if;        
          when reading_data =>
            wr_en <= '1';
            wr_data <= data_p_in;
            state_read <= stop_reading;
          when stop_reading =>
            wr_en <= '0';
            state_read <= idle;
          end case;
      end if;
        
  end process;
  
end rtl;
