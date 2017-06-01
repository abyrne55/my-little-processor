LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- 16-bit Tri-State Buffer
ENTITY tristate_16bit IS
	PORT (
		input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		enable : IN STD_LOGIC;
		output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END tristate_16bit;

ARCHITECTURE behavioural OF tristate_16bit IS
BEGIN
	PROCESS (input, enable)
	BEGIN
		IF (enable = '1') THEN
			output <= input;
		ELSE
			output <= "ZZZZZZZZZZZZZZZZ";
		END IF;
	END PROCESS;
END behavioural;