LIBRARY ieee; 
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY instantiate IS
		PORT ( 
					KEY	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
					LEDR : OUT STD_LOGIC_VECTOR(17 DOWNTO 0)
				);
END;

ARCHITECTURE behavioural of instantiate is 
SIGNAL done: std_logic;
SIGNAL read_addr_int: INTEGER;
SIGNAL read_addr: STD_LOGIC_VECTOR(15 downto 0);
SIGNAL func: STD_LOGIC_VECTOR(15 downto 0);
SIGNAL flag: std_logic;
COMPONENT ram_16bit IS
		PORT(
		clock: in STD_LOGIC;
		done: in STD_LOGIC;
		data: in STD_LOGIC_VECTOR (15 downto 0);
		write_addr: in STD_LOGIC_VECTOR (15 downto 0);
		read_addr: in STD_LOGIC_VECTOR (15 downto 0);
		write_enable: in STD_LOGIC;
		q: out STD_LOGIC_VECTOR (15 downto 0)
	);
END COMPONENT;
COMPONENT my_little_processor IS
	PORT (
		clock, reset: in STD_LOGIC;
		data_in: in STD_LOGIC_VECTOR(15 downto 0);
		flag_out, done_out: out STD_LOGIC
	);
END COMPONENT;
COMPONENT PC is
	PORT (
			clock, done, reset : in std_logic;
			read_addr: out INTEGER
			);
END COMPONENT;
begin 
read_addr <= std_logic_vector(to_unsigned(read_addr_int, read_addr'length));
   ram: ram_16bit PORT MAP (
		clock => KEY(0),
		done => done,
--		data => ,
--		write_addr => ,
		read_addr => read_addr,
--		write_enable => ,
		q => func
	);
	processor: my_little_processor PORT MAP(
		clock => KEY(0),
		reset => KEY(1),
		data_in => func,
		flag_out => flag,
		done_out => done
	);
	ProgCount: PC PORT MAP(
			clock => KEY(0),
			done => done,
			reset => KEY(1),
			read_addr => read_addr_int
	);
PROCESS(flag)
BEGIN
	IF flag='1' THEN
		LEDR <= "111111111111111111";
	ELSE
		LEDR <= "000000000000000000";
	END IF;
END PROCESS;
END behavioural;