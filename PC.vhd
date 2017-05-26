LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY PC IS
	PORT (
			clock, done, reset : in std_logic;
			read_addr: out INTEGER
			);
END PC;

ARCHITECTURE behavioural OF PC IS
SIGNAL addr_temp: INTEGER;
BEGIN
	PROCESS(clock, done)
	begin
		IF reset = '1' then
			read_addr <= 0;
		ELSIF rising_edge(clock) and done = '1' then
			addr_temp <= addr_temp + 1;
		END IF;
	end process;
read_addr <= addr_temp;
end behavioural;
	
	
	