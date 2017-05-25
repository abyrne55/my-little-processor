LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- "My Little Processor(TM)" 
-- Top Level Entity
ENTITY my_little_processor IS
	PORT (
		clock, reset: in STD_LOGIC;
		data_in: in STD_LOGIC_VECTOR(15 downto 0)
	);
END;

ARCHITECTURE behavioural OF my_little_processor IS
SIGNAL MainBus: std_logic_vector(15 downto 0);
COMPONENT register_16bit PORT(
		input: in STD_LOGIC_VECTOR(16 downto 0);
		enable: in STD_LOGIC;
		reset: in STD_LOGIC; -- async. reset
		clock: in STD_LOGIC;
		do_xor: in STD_LOGIC;
		output: out STD_LOGIC_VECTOR(16 downto 0)
	);
END COMPONENT;
COMPONENT control_circuit PORT(
		clock: in STD_LOGIC;
		func: in STD_LOGIC_VECTOR (15 downto 0);
		
		R0_in, R1_in: out STD_LOGIC;
		R0_out, R1_out: out STD_LOGIC;
		R0_xor, R1_xor: out STD_LOGIC;
		
		A_in, G_in, G_out, ALU, extern: out STD_LOGIC;
		done: out STD_LOGIC
	);
END COMPONENT;
COMPONENT tristate_16bit PORT(
		input: in STD_LOGIC_VECTOR(15 downto 0);
		enable: in STD_LOGIC;
		output: out STD_LOGIC_VECTOR(15 downto 0)
	);
END COMPONENT;
COMPONENT ALU PORT(
		A,B: in STD_LOGIC_VECTOR(15 downto 0);
		output: out STD_LOGIC_VECTOR(15 downto 0)
		flag: out STD_LOGIC;
	);
END COMPONENT;

BEGIN

	
	-- Define your connections betweetn control_circuit, registers, etc. here...
END behavioural;
	