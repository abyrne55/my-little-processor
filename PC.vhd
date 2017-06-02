LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

ENTITY PC IS
	PORT (
			input: in std_logic_vector(15 downto 0);
			en_in, clock, done, reset : in std_logic;
			read_addr: out INTEGER
			);
END PC;

ARCHITECTURE behavioural OF PC IS
SIGNAL addr_temp: INTEGER:=0;
BEGIN
	PROCESS(clock, done, reset, en_in, input)
	begin
		IF reset = '1' then
			addr_temp <= 0;
		ELSIF en_in = '1' then
			addr_temp <= to_integer(unsigned(input));
		ELSIF rising_edge(clock) and done = '1' then
			addr_temp <= addr_temp + 1;
		END IF;
	end process;
read_addr <= addr_temp;
end behavioural;
	
	
	