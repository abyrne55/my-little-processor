LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- "My Little Processor(TM)" 
-- Top Level Entity
ENTITY my_little_processor IS
	PORT (
		clock, reset: in STD_LOGIC;
		data_in: in STD_LOGIC_VECTOR(15 downto 0);
	);
END;

ARCHITECTURE behavioural OF my_little_processor IS

BEGIN
	-- Define your connections betweetn control_circuit, registers, etc. here...
END behavioural;
	