LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- 16-bit Register w/ Async. Reset 
ENTITY register_16bit IS 
	PORT(
		input: in STD_LOGIC_VECTOR(15 downto 0);
		enable: in STD_LOGIC;
		reset: in STD_LOGIC; -- async. reset
		clock: in STD_LOGIC;
		do_xor: in STD_LOGIC;
		output: out STD_LOGIC_VECTOR(15 downto 0)
	);
END register_16bit;

ARCHITECTURE behavioural OF register_16bit IS
SIGNAL temp: std_logic_vector(15 downto 0);
SIGNAL outtemp: std_logic_vector(15 downto 0);
BEGIN
	PROCESS(clock, reset, do_xor)
	BEGIN
		IF (reset = '1') THEN
			output <= "0000000000000000";
		ELSIF rising_edge(clock) THEN
			IF do_xor='1' then
				outtemp <= outtemp XOR input;
			ELSIF enable = '1' THEN
				outtemp <= input;
			END IF;
			output <= outtemp;
		END IF;
	END PROCESS;
END behavioural;