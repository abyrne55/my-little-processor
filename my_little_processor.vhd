LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
-- "My Little Processor(TM)"
-- Top Level Entity
ENTITY my_little_processor IS
	PORT (
		clock, reset                   : IN STD_LOGIC;
		data_in                        : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		flag_out                       : OUT STD_LOGIC;
		done_out                       : OUT STD_LOGIC;
		c_state                        : OUT INTEGER;
		read_addr, reg0_out, reg1_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END;

ARCHITECTURE behavioural OF my_little_processor IS
	SIGNAL read_addr_temp, main_bus, R0_output, R1_output, A_output, G_output, Adder_output : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL R0_in, R1_in, R0_out, R1_out, R0_xor, R1_xor, A_in, G_in, G_out, extern, done_temp, PC_in, PC_out : STD_LOGIC;
	SIGNAL read_addr_int : INTEGER;
	COMPONENT register_16bit
		PORT (
			input   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			enable  : IN STD_LOGIC;
			reset   : IN STD_LOGIC;
			clock   : IN STD_LOGIC;
			do_xor  : IN STD_LOGIC;
			output  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT PC
		PORT (
			input                      : IN std_logic_vector(15 DOWNTO 0);
			en_in, clock, done, reset  : IN std_logic;
			read_addr                  : OUT INTEGER
		);
	END COMPONENT;
	COMPONENT control_circuit
		PORT (
			clock, reset               : IN STD_LOGIC;
			func                       : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

			R0_in, R1_in               : OUT STD_LOGIC;
			R0_out, R1_out             : OUT STD_LOGIC;
			R0_xor, R1_xor             : OUT STD_LOGIC;
 
			PC_in                      : OUT STD_LOGIC;
			PC_out                     : OUT STD_LOGIC;
			A_in, G_in, G_out, extern  : OUT STD_LOGIC;
			done                       : OUT STD_LOGIC;
			c_state                    : OUT INTEGER
		);
	END COMPONENT;
	COMPONENT tristate_16bit
		PORT (
			input   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			enable  : IN STD_LOGIC;
			output  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT Adder
		PORT (
			A, B    : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			output  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			flag    : OUT STD_LOGIC
		);
	END COMPONENT;

BEGIN
	PC0 : PC
	PORT MAP(
		input      => main_bus, 
		en_in      => PC_in, 
		clock      => clock, 
		done       => done_temp, 
		reset      => reset, 
		read_addr  => read_addr_int
	);

	control_circuit0 : control_circuit
	PORT MAP(
		reset    => reset, 
		clock    => clock, 
		func     => data_in, 

		R0_in    => R0_in, 
		R1_in    => R1_in, 
		R0_out   => R0_out, 
		R1_out   => R1_out, 
		R0_xor   => R0_xor, 
		R1_xor   => R1_xor, 

		A_in     => A_in, 
		G_in     => G_in, 
		G_out    => G_out, 
		extern   => extern, 
		done     => done_temp, 
		PC_in    => PC_in, 
		PC_out   => PC_out, 
		c_state  => c_state
	);

	register0 : register_16bit
	PORT MAP(
		input   => main_bus, 
		enable  => R0_in, 
		reset   => reset, 
		clock   => clock, 
		do_xor  => R0_xor, 
		output  => R0_output
	);

	register1 : register_16bit
	PORT MAP(
		input   => main_bus, 
		enable  => R1_in, 
		reset   => reset, 
		clock   => clock, 
		do_xor  => R1_xor, 
		output  => R1_output
	);

	registerA : register_16bit
	PORT MAP(
		input   => main_bus, 
		enable  => A_in, 
		reset   => reset, 
		clock   => clock, 
		do_xor  => '0', 
		output  => A_output
	);

	registerG : register_16bit
	PORT MAP(
		input   => Adder_output, 
		enable  => G_in, 
		reset   => reset, 
		clock   => clock, 
		do_xor  => '0', 
		output  => G_output
	);

	tristate_PC : tristate_16bit
	PORT MAP(
		input   => read_addr_temp, 
		enable  => PC_out, 
		output  => main_bus
	);
	tristate0 : tristate_16bit
	PORT MAP(
		input   => R0_output, 
		enable  => R0_out, 
		output  => main_bus
	);

	tristate1 : tristate_16bit
	PORT MAP(
		input   => R1_output, 
		enable  => R1_out, 
		output  => main_bus
	);

	tristateG : tristate_16bit
	PORT MAP(
		input   => G_output, 
		enable  => G_out, 
		output  => main_bus
	);

	tristateX : tristate_16bit
	PORT MAP(-- External Data
		input   => data_in, 
		enable  => extern, 
		output  => main_bus
	);

	Adder0 : Adder
	PORT MAP(
		A       => A_output, 
		B       => main_bus, 
		output  => Adder_output, 
		flag    => flag_out
	);
 
	read_addr_temp <= std_logic_vector(to_unsigned(read_addr_int, read_addr_temp'length));
	read_addr <= read_addr_temp;
	done_out <= done_temp;
	reg0_out <= R0_output;
	reg1_out <= R1_output;
 
END behavioural;