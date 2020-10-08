library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity FIFO_ASYNC is port(
 wr_clk,rd_clk: in std_logic:='0';
 rst: in std_logic:='0';
-- Write port
 wr_en: in std_logic:='0';
 wr_data :in std_logic_vector(7 downto 0):= (others=>'0');
 -- Read port
 rd_en: in std_logic:='0';
 rd_data: out std_logic_vector(7 downto 0):= (others=>'0');


 sts_full: out std_logic:='0';
 sts_empty: out std_logic:='0';
 sts_high: out std_logic:='0';
 sts_low:out std_logic:='0';
sts_error:out std_logic:='0'
);
end FIFO_ASYNC;

architecture FIFO_ASYNC of FIFO_ASYNC  is
type fila is array (0 to 63) of std_logic_vector(7 downto 0);
signal fifo : fila;
signal head, tail: integer range 0 to 64:=0;
signal cont: integer range 0 to 63 :=0;
shared variable flag: std_logic:='0';
signal total,com,ter: integer range 0 to 64 :=0;
begin   
sts_empty <= '1' when total = 0 else '0';
sts_full <='1'  when total >= 63 and wr_en ='0' else '0' ;
sts_high <= '1' when total >= 60 else '0';			
sts_low <= '1'  when total <=4 else '0';
sts_error <='1' when com=ter and rst='0' and flag ='1' else '0' when rst='1';

total <= 0 when head=tail else tail-head when head<tail  else (64-head)+tail;
com<=head;
ter<=tail;	 


	wr: process(wr_clk,rst)
	begin        
		if rst = '1' then 
			tail<=0;
			flag:='0';
			for cont  in 0 to 63 loop
				fifo(cont)<=(others=>'0');
			end loop;
		else
			if wr_clk'event and wr_clk='1' then 
				if wr_en = '1' then
					fifo(tail)<= wr_data;
					tail<=tail+1;
					flag:='1';
				end if; 
			end if;
            end if;
			
  	end process wr;
	

	rd: process(rd_clk,rst)
	begin        
		if rst = '1' then 
			head<=0;
		else
			if rd_clk'event and rd_clk='1' then 
				if rd_en = '1' then
					rd_data<=fifo(head);
					head<=head+1;
				end if;
			end if;
			if head = 63 then 
				head<=0;
			end if;
		end if;
	
  	end process rd;

 
end FIFO_ASYNC;
