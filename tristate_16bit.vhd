LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- 16-bit Tri-State Buffer
ENTITY tristate_16bit IS
	PORT(
		input: in STD_LOGIC_VECTOR(15 downto 0);
		enable: in STD_LOGIC;
		output: out STD_LOGIC_VECTOR(15 downto 0)
	);
END tristate_16bit;

ARCHITECTURE behavioural OF tristate_16bit IS
BEGIN
	PROCESS(input, enable)
	BEGIN
		IF (enable = '1') THEN
			output <= input;
		ELSE
			output <= "ZZZZZZZZZZZZZZZZ";
		END IF;
	END PROCESS;
END behavioural;