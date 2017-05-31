LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
-- "My Little Processor(TM)"
-- Top Level Entity
ENTITY my_little_processor IS
	PORT (
		clock, reset : IN STD_LOGIC;
		data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		flag_out : OUT STD_LOGIC;
		done_out : OUT STD_LOGIC;
		read_addr, reg1_out, reg2_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END;

ARCHITECTURE behavioural OF my_little_processor IS
	SIGNAL read_addr_temp, main_bus, R0_output, R1_output, A_output, G_output, ALU_output : std_logic_vector(15 DOWNTO 0);
	SIGNAL R0_in, R1_in, R0_out, R1_out, R0_xor, R1_xor, A_in, G_in, G_out, extern, done_temp, PC_in, PC_out : STD_LOGIC;
	SIGNAL read_addr_int : INTEGER;
	COMPONENT register_16bit
		PORT (
			input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			enable : IN STD_LOGIC;
			reset : IN STD_LOGIC; -- async. reset
			clock : IN STD_LOGIC;
			do_xor : IN STD_LOGIC;
			output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT PC
	PORT (
			input: in std_logic_vector(15 downto 0);
			en_in, clock, done, reset : in std_logic;
			read_addr: out INTEGER
			);
	END COMPONENT;
	COMPONENT control_circuit
		PORT (
			clock : IN STD_LOGIC;
			func : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
 
			R0_in, R1_in : OUT STD_LOGIC;
			R0_out, R1_out : OUT STD_LOGIC;
			R0_xor, R1_xor : OUT STD_LOGIC;
 
			A_in, G_in, G_out, extern : OUT STD_LOGIC;
			done : OUT STD_LOGIC
		);
	END COMPONENT;
	COMPONENT tristate_16bit
		PORT (
			input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			enable : IN STD_LOGIC;
			output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT ALU
		PORT (
			A, B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			flag : OUT STD_LOGIC
		);
	END COMPONENT;

BEGIN
	--read_addr_int <= to_integer(unsigned(read_addr_temp));
	PC0 : PC
	PORT MAP(
		input => main_bus,
		en_in => PC_in,
		clock => clock, 
		done => done_temp, 
		reset => reset, 
		read_addr => read_addr_int
	);

	control_circuit0 : control_circuit
	PORT MAP(
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
		done => done_temp
	);

	register0 : register_16bit
	PORT MAP(
		input => main_bus, 
		enable => R0_in, 
		reset => reset, 
		clock => clock, 
		do_xor => R0_xor, 
		output => R0_output
	);

	register1 : register_16bit
	PORT MAP(
		input => main_bus, 
		enable => R1_in, 
		reset => reset, 
		clock => clock, 
		do_xor => R1_xor, 
		output => R1_output
	);

	registerA : register_16bit
	PORT MAP(
		input => main_bus, 
		enable => A_in, 
		reset => reset, 
		clock => clock, 
		do_xor => '0', 
		output => A_output
	);

	registerG : register_16bit
	PORT MAP(
		input => ALU_output, 
		enable => G_in, 
		reset => reset, 
		clock => clock, 
		do_xor => '0', 
		output => G_output
	);

	tristate_PC : tristate_16bit
	PORT MAP(
		input => read_addr_temp, 
		enable => PC_out, 
		output => main_bus
	);
	tristate0 : tristate_16bit
	PORT MAP(
		input => R0_output, 
		enable => R0_out, 
		output => main_bus
	);

	tristate1 : tristate_16bit
	PORT MAP(
		input => R1_output, 
		enable => R1_out, 
		output => main_bus
	);

	tristateG : tristate_16bit
	PORT MAP(
		input => G_output, 
		enable => G_out, 
		output => main_bus
	);

	tristateX : tristate_16bit
	PORT MAP(-- External Data
		input => data_in, 
		enable => extern, 
		output => main_bus
	);

	ALU0 : ALU
	PORT MAP(
		A => A_output, 
		B => main_bus, 
		output => ALU_output, 
		flag => flag_out
	);
	
	read_addr_temp <= std_logic_vector(to_unsigned(read_addr_int, read_addr_temp'length));
	read_addr <= read_addr_temp;
	done_out <= done_temp;
	reg1_out <= R0_output;
	reg2_out <= R1_output;

END behavioural;