
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity UART_BAUD_CLK is
  generic(
    clk: integer := 100000000
  );
  port (
        clock_in:   in  std_logic;
        reset_in: in  std_logic;
        baud_clk: out std_logic;
        uart_rate_sel: in std_logic_vector(1 downto 0)
       );
end UART_BAUD_CLK;


architecture rtl of UART_BAUD_CLK  is

signal baud_clk_sig: std_logic:='0';
begin
  baud_clk <= baud_clk_sig;
  process (reset_in, clock_in)
  variable count: integer:=0;
  variable baud: integer:=0;
  begin
    if (reset_in = '1') then
      baud  := (clk/19200)/2;
      count := 0;
      else if rising_edge(clock_in) then 
      if (uart_rate_sel = "11") then
        baud := (clk/57600)/2;
        else if (uart_rate_sel = "10") then
          baud := (clk/28800)/2;
          else if (uart_rate_sel = "01") then
            baud := (clk/19200)/2;
            else
            baud := (clk/9600)/2;
          end if;
        end if;
      end if;
      count := count + 1;
      if (count >= baud) then
        baud_clk_sig <= not baud_clk_sig; 
        count :=0;
      end if;
    end if;
  end if;
  end process;
end rtl;
