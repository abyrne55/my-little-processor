LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY PC IS
	PORT (
		input                      : IN std_logic_vector(15 DOWNTO 0);
		en_in, clock, done, reset  : IN std_logic;
		read_addr                  : OUT INTEGER
	);
END PC;

ARCHITECTURE behavioural OF PC IS
	SIGNAL addr_temp : INTEGER := 0;
BEGIN
	PROCESS (clock, done, reset, en_in, input)
	BEGIN
		IF reset = '1' THEN
			addr_temp <= 0;
		ELSIF en_in = '1' THEN
			addr_temp <= to_integer(unsigned(input));
		ELSIF rising_edge(clock) AND done = '1' THEN
			addr_temp <= addr_temp + 1;
		END IF;
	END PROCESS;
	read_addr <= addr_temp;
END behavioural;