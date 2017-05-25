LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- 16-bit Program Counter 
ENTITY program_counter IS 
	PORT(
		done_in: in STD_LOGIC;
		read_address: out STD_LOGIC_VECTOR(15 downto 0);
		reset: in STD_LOGIC; -- async. reset
	);
END register_16bit;

ARCHITECTURE behavioural OF register_16bit IS
SIGNAL count: UNSIGNED(15 downto 0);
BEGIN
	PROCESS(done_in, reset)
	BEGIN
		IF (reset = '1') THEN
			count <= 0;
		ELSIF rising_edge(done_in) THEN
			count <= count + 1;
		END IF;
	END PROCESS;
	
-- Convert count to logic vector and output
read_address <= std_logic_vector(count);
END behavioural;