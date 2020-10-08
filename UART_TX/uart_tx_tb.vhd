library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;


entity UART_TX_TB is
    generic(
		DATA_SIZE : integer := 64
	);
  end  UART_TX_TB;

architecture TB of UART_TX_TB is
signal clock_in:            std_logic:='0';
signal reset_in:            std_logic:='0';
signal data_p_in:           std_logic_vector (7 downto 0):="00000000";
signal data_p_en_in:        std_logic:='0';
signal uart_data_tx:        std_logic:='0';
signal uart_rate_tx_sel:    std_logic_vector(1 downto 0):="11";
signal baud_clk_tb:    std_logic;

signal data_out: std_logic:='1';
-------------------------------------------------------------------
	----------fifo deck-----------------------------------------------
	subtype SER_DATA is std_logic_vector(7 downto 0);
	type DATA_ARRAY_TYPE is array (DATA_SIZE downto 0) of SER_DATA;
	signal DATA_ARRAY : DATA_ARRAY_TYPE;
  signal rd_data    : std_logic_vector(7 downto 0):= x"00";
  signal send_data  : std_logic := '0'; 
begin
  
  DATA_ARRAY(0)  <= x"FF"; DATA_ARRAY(1)  <= x"01"; DATA_ARRAY(2)  <= x"02"; DATA_ARRAY(3)  <= x"03"; DATA_ARRAY(4)  <= x"04"; DATA_ARRAY(5)  <= x"05";
  DATA_ARRAY(6)  <= x"06"; DATA_ARRAY(7)  <= x"07"; DATA_ARRAY(8)  <= x"08"; DATA_ARRAY(9)  <= x"0a"; DATA_ARRAY(10) <= x"0b"; DATA_ARRAY(11) <= x"0c"; 
  DATA_ARRAY(12) <= x"0d"; DATA_ARRAY(13) <= x"0e"; DATA_ARRAY(14) <= x"0f"; DATA_ARRAY(15) <= x"10"; DATA_ARRAY(16) <= x"11"; DATA_ARRAY(17) <= x"12"; 
  DATA_ARRAY(18) <= x"13"; DATA_ARRAY(19) <= x"14"; DATA_ARRAY(20) <= x"15"; DATA_ARRAY(21) <= x"16"; DATA_ARRAY(22) <= x"17"; DATA_ARRAY(23) <= x"18"; 
  DATA_ARRAY(24) <= x"19"; DATA_ARRAY(25) <= x"1a"; DATA_ARRAY(26) <= x"1b"; DATA_ARRAY(27) <= x"1c"; DATA_ARRAY(28) <= x"1d"; DATA_ARRAY(29) <= x"1e"; 
  DATA_ARRAY(30) <= x"1f"; DATA_ARRAY(31) <= x"20"; DATA_ARRAY(32) <= x"21"; DATA_ARRAY(33) <= x"22"; DATA_ARRAY(34) <= x"23"; DATA_ARRAY(35) <= x"24"; 
  DATA_ARRAY(36) <= x"25"; DATA_ARRAY(37) <= x"26"; DATA_ARRAY(38) <= x"27"; DATA_ARRAY(39) <= x"28"; DATA_ARRAY(40) <= x"29"; DATA_ARRAY(41) <= x"30";
  DATA_ARRAY(42) <= x"25"; DATA_ARRAY(43) <= x"26"; DATA_ARRAY(44) <= x"27"; DATA_ARRAY(45) <= x"28"; DATA_ARRAY(46) <= x"29"; DATA_ARRAY(47) <= x"30";
  DATA_ARRAY(48) <= x"25"; DATA_ARRAY(49) <= x"26"; DATA_ARRAY(50) <= x"27"; DATA_ARRAY(51) <= x"28"; DATA_ARRAY(52) <= x"29"; DATA_ARRAY(53) <= x"30";
  DATA_ARRAY(54) <= x"25"; DATA_ARRAY(55) <= x"26"; DATA_ARRAY(56) <= x"27"; DATA_ARRAY(57) <= x"28"; DATA_ARRAY(58) <= x"29"; DATA_ARRAY(59) <= x"30";
  DATA_ARRAY(60) <= x"25"; DATA_ARRAY(61) <= x"26"; DATA_ARRAY(62) <= x"27"; DATA_ARRAY(63) <= x"28";
  
  uart_rx: entity work.uart_tx 
  port 
  map(
       clock_in         => clock_in, 
       reset_in         => reset_in, 
       data_p_in       => data_p_in,
       uart_data_tx     => uart_data_tx,
       data_p_en_in    => data_p_en_in,
       uart_rate_tx_sel => uart_rate_tx_sel);
  UART_BAUD_CLK: entity work.UART_BAUD_CLK

  port map(
        baud_clk => baud_clk_tb,
        reset_in => reset_in,
        clock_in => clock_in,  
        uart_rate_sel => uart_rate_tx_sel     
    );


  process 
  begin
    wait for 10 ns;
    clock_in <= not clock_in;
  end process;

  
  
    reading_data_uart_tx:process(baud_clk_tb, reset_in) 
    begin

    end process;
    
    send_data_uart_tx:process(clock_in, reset_in)
    variable i: integer range 0 to 64;
    begin
      if (reset_in = '1') then
        else 
        if(clock_in'event and clock_in = '1') then
          if (send_data = '1') then
            data_p_en_in <= '1';
            data_p_in <= DATA_ARRAY(i);
            i := i+1;
            else
              data_p_en_in <= '0';
            end if;
          end if;
        end if;
    end process;
    
    uart_rate_tx_sel <= "00", "01" after 295 us, "10" after 400 us, "11" after 500 us;
    reset_in         <= '0', '1' after 600 us, '0' after 600.02 us;
    
    
    send_data <= '0', '1' after 610 us, '0' after 610.02 us, '1' after 630.00 us, '0' after 630.02 us, '1' after 650.00 us, '0' after 650.02 us,
                 '1' after 670.00 us, '0' after 670.02 us, '1' after 690.00 us, '0' after 690.02 us, '1' after 710.00 us, '0' after 710.02 us,        --3
                 '1' after 730.00 us, '0' after 730.02 us, '1' after 750.00 us, '0' after 750.02 us, '1' after 770.00 us, '0' after 770.02 us,        --6
                 '1' after 790.00 us, '0' after 790.02 us, '1' after 810.00 us, '0' after 810.02 us, '1' after 830.00 us, '0' after 830.02 us,        --9
                 '1' after 950.00 us, '0' after 950.02 us, '1' after 970.00 us, '0' after 970.02 us, '1' after 990.00 us, '0' after 990.02 us,        --12
                 
                 '1' after 1010.00 us, '0' after 1010.02 us, '1' after 1030.00 us, '0' after 1030.02 us, '1' after 1050.00 us, '0' after 1050.02 us,  --15
                 '1' after 1070.00 us, '0' after 1070.02 us, '1' after 1090.00 us, '0' after 1090.02 us, '1' after 1110.00 us, '0' after 1110.02 us,  --18
                 '1' after 1130.00 us, '0' after 1130.02 us, '1' after 1150.00 us, '0' after 1150.02 us, '1' after 1170.00 us, '0' after 1170.02 us,  --21
                 '1' after 1190.00 us, '0' after 1190.02 us, '1' after 1210.00 us, '0' after 1210.02 us, '1' after 1230.00 us, '0' after 1230.02 us,  --24
                 '1' after 1250.00 us, '0' after 1250.02 us, '1' after 1270.00 us, '0' after 1270.02 us, '1' after 1290.00 us, '0' after 1290.02 us,  --27
                 '1' after 1310.00 us, '0' after 1310.02 us, '1' after 1330.00 us, '0' after 1330.02 us, '1' after 1350.00 us, '0' after 1350.02 us,  --30
                 '1' after 1370.00 us, '0' after 1370.02 us, '1' after 1390.00 us, '0' after 1390.02 us, '1' after 1410.00 us, '0' after 1410.02 us,  --33
                 '1' after 1430.00 us, '0' after 1430.02 us, '1' after 1450.00 us, '0' after 1450.02 us, '1' after 1470.00 us, '0' after 1470.02 us,  --36
                 '1' after 1490.00 us, '0' after 1490.02 us, '1' after 1510.00 us, '0' after 1510.02 us, '1' after 1530.00 us, '0' after 1530.02 us,  --39
                 '1' after 1550.00 us, '0' after 1550.02 us, '1' after 1570.00 us, '0' after 1570.02 us, '1' after 1590.00 us, '0' after 1590.02 us,  --42
                 '1' after 1610.00 us, '0' after 1610.02 us, '1' after 1630.00 us, '0' after 1630.02 us, '1' after 1650.00 us, '0' after 1650.02 us,  --45
                 '1' after 1670.00 us, '0' after 1670.02 us, '1' after 1690.00 us, '0' after 1690.02 us, '1' after 1710.00 us, '0' after 1710.02 us,  --48
                 '1' after 1730.00 us, '0' after 1730.02 us, '1' after 1750.00 us, '0' after 1750.02 us, '1' after 1770.00 us, '0' after 1770.02 us,  --51
                 '1' after 1790.00 us, '0' after 1790.02 us, '1' after 1810.00 us, '0' after 1810.02 us, '1' after 1830.00 us, '0' after 1830.02 us,  --54
                 '1' after 1850.00 us, '0' after 1850.02 us, '1' after 1870.00 us, '0' after 1870.02 us, '1' after 1890.00 us, '0' after 1890.02 us,  --57
                 '1' after 1910.00 us, '0' after 1910.02 us, '1' after 1930.00 us, '0' after 1930.02 us, '1' after 1950.00 us, '0' after 1950.02 us,  --60
                 '1' after 1970.00 us, '0' after 1970.02 us;  --63
    
    
  

end TB;
