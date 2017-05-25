LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- 16-bit Register w/ Async. Reset 
ENTITY register_16bit IS 
	PORT(
		input: in STD_LOGIC_VECTOR(16 DOWNTO 0);
		enable: in STD_LOGIC;
		reset: in STD_LOGIC; -- async. reset
		clock: in STD_LOGIC;
		output: out STD_LOGIC_VECTOR(16 DOWNTO 0)
	);
END register_16bit;

ARCHITECTURE behavioural OF register_16bit IS
BEGIN
    PROCESS(clock, reset)
    BEGIN
        IF (reset = '1') THEN
            output <= x"00000000";
        ELSIF rising_edge(clock) THEN
            IF enable = '1' THEN
                output <= input;
            END IF;
        END IF;
    END PROCESS;
END behavioural;