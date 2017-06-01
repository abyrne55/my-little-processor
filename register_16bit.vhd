LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- 16-bit Register w/ Async. Reset
ENTITY register_16bit IS
	PORT (
		input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		enable : IN STD_LOGIC;
		reset : IN STD_LOGIC; -- async. reset
		clock : IN STD_LOGIC;
		do_xor : IN STD_LOGIC;
		output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END register_16bit;

ARCHITECTURE behavioural OF register_16bit IS
	SIGNAL temp : std_logic_vector(15 DOWNTO 0);
	SIGNAL outtemp : std_logic_vector(15 DOWNTO 0);
BEGIN
	PROCESS (clock, reset, do_xor)
	BEGIN
		IF (reset = '1') THEN
			outtemp <= "0000000000000000";
		ELSIF rising_edge(clock) THEN
			IF do_xor = '1' THEN
				outtemp <= outtemp XOR input;
			ELSIF enable = '1' THEN
				outtemp <= input;
			END IF;
			output <= outtemp;
		END IF;
	END PROCESS;
END behavioural;