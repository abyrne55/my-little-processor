LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY instantiate IS
	PORT (
		KEY : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		LEDR : OUT STD_LOGIC_VECTOR(17 DOWNTO 0)
	);
END;

ARCHITECTURE behavioural OF instantiate IS
	SIGNAL done : std_logic;
	SIGNAL read_addr : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL func : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL flag : std_logic;
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
			read_addr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
BEGIN
	ram : ram_16bit
	PORT MAP(
		clock => KEY(0), 
		done => done, 
		data => "0000000000000000", 
		write_addr => "0000000000000000", 
		read_addr => read_addr, 
		write_enable => '0', 
		q => func
	);
	processor : my_little_processor
	PORT MAP(
		clock => KEY(0), 
		reset => KEY(1), 
		data_in => func, 
		flag_out => flag, 
		done_out => done, 
		read_addr => read_addr
	);
	PROCESS (flag)
	BEGIN
		IF flag = '1' THEN
			LEDR <= "111111111111111111";
		ELSE
			LEDR <= "000000000000000000";
		END IF;
	END PROCESS;
END behavioural;