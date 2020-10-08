library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;


entity UART_RX_TB is
    generic(
		DATA_SIZE : integer := 70
	);
  end  UART_RX_TB;

architecture TB of UART_RX_TB is
signal clock_in:         std_logic:='0';
signal reset_in:         std_logic:='0';
signal data_p_out:       std_logic_vector (7 downto 0):="00000000";
signal uart_data_rx:     std_logic:='1';
signal uart_rate_rx_sel: std_logic_vector(1 downto 0):="00";
signal baud_clk_tb:      std_logic:='0';
signal data_p_en_out:    std_logic;

signal data: std_logic_vector (9 downto 0):="0000000000";
signal sending_data: std_logic;   
signal data_out: std_logic:='1';
-------------------------------------------------------------------
	----------fifo deck-----------------------------------------------
	subtype SER_DATA is std_logic_vector(9 downto 0);
	type DATA_ARRAY_TYPE is array (DATA_SIZE downto 0) of SER_DATA;
	signal DATA_ARRAY : DATA_ARRAY_TYPE;
    signal rd_data: std_logic_vector(7 downto 0):= x"00";

begin

   DATA_ARRAY(0)  <= "0000000010"; DATA_ARRAY(16)  <= "0000011000"; DATA_ARRAY(32) <= "0000000010"; DATA_ARRAY(48) <= "0111111110";       
   DATA_ARRAY(1)  <= "0000000010"; DATA_ARRAY(17)  <= "0000011010"; DATA_ARRAY(33) <= "0000000100"; DATA_ARRAY(49) <= "0111111100";        
   DATA_ARRAY(2)  <= "0100000100"; DATA_ARRAY(18)  <= "0000011100"; DATA_ARRAY(34) <= "0000001000"; DATA_ARRAY(50) <= "0111111010";
   DATA_ARRAY(3)  <= "0001111100"; DATA_ARRAY(19)  <= "0000011110"; DATA_ARRAY(35) <= "0000010000"; DATA_ARRAY(51) <= "0111111000";
   DATA_ARRAY(4)  <= "0111111110"; DATA_ARRAY(20)  <= "0101010100"; DATA_ARRAY(36) <= "0000100010"; DATA_ARRAY(52) <= "0111110110";
   DATA_ARRAY(5)  <= "0000000010"; DATA_ARRAY(21)  <= "0101110110"; DATA_ARRAY(37) <= "0001000010"; DATA_ARRAY(53) <= "0111110010";
   DATA_ARRAY(6)  <= "0000000100"; DATA_ARRAY(22)  <= "0110011000"; DATA_ARRAY(38) <= "0010000010"; DATA_ARRAY(54) <= "0111110000";
   DATA_ARRAY(7)  <= "0000000110"; DATA_ARRAY(23)  <= "0110111010"; DATA_ARRAY(39) <= "0100000000"; DATA_ARRAY(55) <= "0111101110";
   DATA_ARRAY(8)  <= "0000001000"; DATA_ARRAY(24)  <= "0111011100"; DATA_ARRAY(40) <= "0010000010"; DATA_ARRAY(56) <= "0111101100";
   DATA_ARRAY(9)  <= "0000001010"; DATA_ARRAY(25)  <= "0111111110"; DATA_ARRAY(41) <= "0001000000"; DATA_ARRAY(57) <= "0111101010";
   DATA_ARRAY(10) <= "0000001100"; DATA_ARRAY(26)  <= "0010101010"; DATA_ARRAY(42) <= "0000100000"; DATA_ARRAY(58) <= "0111101000";         
   DATA_ARRAY(11) <= "0000001110"; DATA_ARRAY(27)  <= "0101010100"; DATA_ARRAY(43) <= "0000010000"; DATA_ARRAY(59) <= "0111100110";
   DATA_ARRAY(12) <= "0000010000"; DATA_ARRAY(28)  <= "0000111110"; DATA_ARRAY(44) <= "0000001000"; DATA_ARRAY(60) <= "0111100100";
   DATA_ARRAY(13) <= "0000010010"; DATA_ARRAY(29)  <= "0111100010"; DATA_ARRAY(45) <= "0000000100"; DATA_ARRAY(61) <= "0111100010";
   DATA_ARRAY(14) <= "0000010100"; DATA_ARRAY(30)  <= "0101010110"; DATA_ARRAY(46) <= "0000000010"; DATA_ARRAY(62) <= "0111100000";
   DATA_ARRAY(15) <= "0000010110"; DATA_ARRAY(31)  <= "0000111010"; DATA_ARRAY(47) <= "0000000110"; DATA_ARRAY(63) <= "0111111110";
    
  DATA_ARRAY(64) <= "0111111110";  DATA_ARRAY(65) <= "0111111110"; DATA_ARRAY(66) <= "0111111110";  DATA_ARRAY(67) <= "0111111110";
   
  uart_rx: entity work.uart_rx 
  port 
  map(
       clock_in         => clock_in, 
       reset_in         => reset_in, 
       data_p_out       => data_p_out,
       uart_data_rx     => uart_data_rx,
       data_p_en_out    => data_p_en_out,
       uart_rate_rx_sel => uart_rate_rx_sel);
  UART_BAUD_CLK: entity work.UART_BAUD_CLK
  port map(
        baud_clk => baud_clk_tb,
        reset_in => reset_in,
        clock_in => clock_in,  
        uart_rate_sel => uart_rate_rx_sel     
    );

  process
  begin
    wait for 10 ns;
    clock_in <= not clock_in;
  end process;

  
  
  send_data:process(baud_clk_tb, reset_in)
        variable i: integer:=0;
        variable counter: integer:=0;
 
    begin
        if (reset_in = '1') then
        i := 0;
        else if (baud_clk_tb'event and baud_clk_tb ='1') then
            data <= DATA_ARRAY(i);
            if( sending_data = '1') then
                data_out <=  data(counter);
                counter := counter + 1;
                if (counter >=10) then
                  i := i+1;
                  counter := 0;
                end if;

            end if;
        end if;
        end if;        
    end process;
    
    read_data:process(clock_in, reset_in)
        
    begin
      if (reset_in = '1') then
      
      else if (clock_in'event and clock_in = '1') then
        if (data_p_en_out = '1') then
            rd_data <= data_p_out;
        end if;
      end if;
      end if;
    end process;
    reset_in <= '1', '0' after 100 ns;
    uart_data_rx <= data_out;
    sending_data <= '0', '1' after 0.96 ms;
end TB;
