LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- "My Little Processor(TM)" 
-- Top Level Entity
ENTITY my_little_processor IS
	PORT (
		clock, reset: in STD_LOGIC;
		data_in: in STD_LOGIC_VECTOR(15 downto 0);
		flag_out, done_out: out STD_LOGIC
	);
END;

ARCHITECTURE behavioural OF my_little_processor IS
SIGNAL main_bus, R0_output, R1_output, A_output, G_output, ALU_output: std_logic_vector(15 downto 0);
SIGNAL R0_in,R1_in,R0_out,R1_out,R0_xor,R1_xor,A_in,G_in,G_out,extern,done: STD_LOGIC;
COMPONENT register_16bit PORT(
		input: in STD_LOGIC_VECTOR(15 downto 0);
		enable: in STD_LOGIC;
		reset: in STD_LOGIC; -- async. reset
		clock: in STD_LOGIC;
		do_xor: in STD_LOGIC;
		output: out STD_LOGIC_VECTOR(15 downto 0)
	);
END COMPONENT;
COMPONENT control_circuit PORT(
		clock: in STD_LOGIC;
		func: in STD_LOGIC_VECTOR (15 downto 0);
		
		R0_in, R1_in: out STD_LOGIC;
		R0_out, R1_out: out STD_LOGIC;
		R0_xor, R1_xor: out STD_LOGIC;
		
		A_in, G_in, G_out, extern: out STD_LOGIC;
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
		output: out STD_LOGIC_VECTOR(15 downto 0);
		flag: out STD_LOGIC
	);
END COMPONENT;

BEGIN

control_circuit0: control_circuit PORT MAP (
	clock => clock,
	func => data_in,
	
	R0_in => R0_in,
	R1_in => R1_in,
	R0_out => R0_out,
	R1_out => R1_out,
	R0_xor => R0_xor,
	R1_xor => R1_xor,
	
	A_in => A_in,
	G_in => G_in,
	G_out => G_out,
	extern => extern,
	done => done_out
);

register0: register_16bit PORT MAP (
	input => main_bus,
	enable => R0_in,
	reset => reset,
	clock => clock,
	do_xor => R0_xor,
	output => R0_output
);

register1: register_16bit PORT MAP (
	input => main_bus,
	enable => R1_in,
	reset => reset,
	clock => clock,
	do_xor => R1_xor,
	output => R1_output
);

registerA: register_16bit PORT MAP (
	input => main_bus,
	enable => A_in,
	reset => reset,
	clock => clock,
	do_xor => '0',
	output => A_output
);

registerG: register_16bit PORT MAP (
	input => ALU_output,
	enable => G_in,
	reset => reset,
	clock => clock,
	do_xor => '0',
	output => G_output
);

tristate0: tristate_16bit PORT MAP (
	input => R0_output,
	enable => R0_out,
	output => main_bus
);

tristate1: tristate_16bit PORT MAP (
	input => R1_output,
	enable => R1_out,
	output => main_bus
);

tristateG: tristate_16bit PORT MAP (
	input => ALU_output,
	enable => G_out,
	output => main_bus
);

tristateX: tristate_16bit PORT MAP ( -- External Data
	input => data_in,
	enable => extern,
	output => main_bus
);

ALU0: ALU PORT MAP (
	A => A_output,
	B => main_bus,
	output => ALU_output,
	flag => flag_out
);

END behavioural;
	