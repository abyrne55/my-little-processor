LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ram_16bit IS
	GENERIC ( S,N : INTEGER := 16);
	PORT(
		clock: in STD_LOGIC;
		data: in STD_LOGIC_VECTOR (15 downto 0);
		write_addr: in STD_LOGIC_VECTOR (N-1 downto 0);
		read_addr: in STD_LOGIC_VECTOR (N-1 downto 0);
		write_enable: in STD_LOGIC;
		q: out STD_LOGIC_VECTOR (15 downto 0)
	);
END;

ARCHITECTURE behavioural OF ram_16bit IS
TYPE mem IS ARRAY (S-1 downto 0) OF STD_LOGIC_VECTOR(15 downto 0);
FUNCTION initialize_ram RETURN mem IS
VARIABLE result : mem;
BEGIN
	-- THIS IS WHERE YOU WRITE THE INSTRUCTIONS --
	result(0) := "000000000000000"; --LOAD R0
	result(1) := "000000000010000"; --Data
	-- and repeat...
END intitialize_ram;

SIGNAL raMem : mem := initialize_ram;

BEGIN
	PROCESS (clock)
	BEGIN
		IF (rising_edge(clock)) THEN
			IF (write_enable = '1') THEN
				raMem(to_integer(unsigned(write_addr))) <= data;
			END IF;
			q <= raMem(to_integer(unsigned(read_addr)));
		END IF;
	END PROCESS;
END behavioural;