LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY instantiate IS
	PORT (
		SW : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
		KEY : IN STD_LOGIC_VECTOR(3 downto 0);
		LEDR : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
		LEDG : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7 : OUT STD_LOGIC_VECTOR(6 downto 0)
	);
END;

ARCHITECTURE behavioural OF instantiate IS
	SIGNAL done : std_logic;
	SIGNAL not_key : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL read_addr : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL func : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL flag : std_logic;
	SIGNAL reg0_out: std_logic_vector(15 downto 0);
	SIGNAL reg1_out: std_logic_vector(15 downto 0);
	SIGNAL c_state_preout: INTEGER;
	COMPONENT binaryto4hex IS
		PORT ( 
			binary : IN STD_LOGIC_VECTOR(15 downto 0);
			output0, output1, output2, output3 : OUT STD_LOGIC_VECTOR(6 downto 0)
		);
	END COMPONENT;
	COMPONENT ram_16bit IS
		PORT (
			clock : IN STD_LOGIC;
			done : IN STD_LOGIC;
			data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			write_addr : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			read_addr : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			write_enable : IN STD_LOGIC;
			q : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT my_little_processor IS
		PORT (
			clock, reset : IN STD_LOGIC;
			data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			flag_out, done_out : OUT STD_LOGIC;
			read_addr, reg0_out, reg1_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			c_state_preout : OUT INTEGER
		);
	END COMPONENT;
BEGIN
	ram : ram_16bit
	PORT MAP(
		clock => not_key(2),
		done => done,
		data => "0000000000000000", 
		write_addr => "0000000000000000", 
		read_addr => read_addr, 
		write_enable => '0', 
		q => func
	);
	processor : my_little_processor
	PORT MAP(
		clock => not_key(2), 
		reset => not_key(1), 
		data_in => func, 
		flag_out => flag, 
		done_out => done, 
		read_addr => read_addr,
		reg0_out => reg0_out,
		reg1_out => reg1_out,
		c_state_preout => c_state_preout
	);
	bintohex0 : binaryto4hex
	PORT MAP (
			binary => reg1_out,
			output0 => HEX0,
			output1 => HEX1,
			output2 => HEX2,
			output3 => HEX3
		);
	bintohex1 : binaryto4hex
	PORT MAP (
			binary => reg0_out,
			output0 => HEX4,
			output1 => HEX5,
			output2 => HEX6,
			output3 => HEX7
		);
--	PROCESS (flag)
--	BEGIN
--		IF flag = '1' THEN
--			LEDR <= "111111111111111111";
--		ELSE
--			LEDR <= "000000000000000000";
--		END IF;
--	END PROCESS;

-- Negate key state (not_key[0] = 1 when KEY0 is pressed)
not_key <= not KEY;

-- Assign LEDG's above KEYs to current state
LEDG(7 downto 0) <=  std_logic_vector(to_unsigned(c_state_preout, 8));
LEDG(8) <= not_key(2);

--Assign a register to 16 LEDs
LEDR(15 downto 0) <= func;

--Assign the 8 LSBs of each register values to 16 LEDS
--LEDR(7 downto 0) <= reg1_out(15 downto 8);
--LEDR(15 downto 8) <= reg0_out(15 downto 8);

-- LEDR Test Pattern
--LEDR <= "010101010101010101";

END behavioural;