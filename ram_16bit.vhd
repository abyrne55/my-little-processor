LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
USE ieee.numeric_std.ALL; 
-- Synchronous RAM
ENTITY ram_16bit IS
	GENERIC ( S,N : INTEGER := 16);
	PORT(
		clock: in STD_LOGIC;
		done: in STD_LOGIC;
		data: in STD_LOGIC_VECTOR (15 downto 0);
		write_addr: in STD_LOGIC_VECTOR (N-1 downto 0);
		read_addr: in STD_LOGIC_VECTOR (N-1 downto 0);
		write_enable: in STD_LOGIC;
		q: out STD_LOGIC_VECTOR (15 downto 0)
	);
END;

ARCHITECTURE behavioural OF ram_16bit IS
TYPE mem IS ARRAY (15 downto 0) OF STD_LOGIC_VECTOR(15 downto 0);
FUNCTION initialize_ram RETURN mem IS
VARIABLE result : mem;
BEGIN
	-- THIS IS WHERE YOU WRITE THE INSTRUCTIONS --
	result(0) := "0000000000000000"; --LOAD R0
	result(1) := "0000000000100000"; --Data
	result(2) := "0000000100000000"; --LOAD R1
	result(3) := "1001010001100001"; --Data
	result(4) := "0001000000010000"; --MOV R1 to R0
	result(5) := "0000000100000000"; --LOAD R1
	result(6) := "0000000010001000"; --Data
	result(7) := "0010000000010000"; --Add R0 + R1, store in R0
	result(8) := "0010000100000000"; --Add R0 + R1, store in R1
	result(9) := "0011000000010000"; --XOR R0, R1, store in R0
	result(10) := "0011000100000000"; --XOR R0, R1, store in R1
	result(11) := "0000000000000000"; --LOAD R0
	result(12) := "0000000000000000"; --Data
	result(13) := "0000000000000000"; --LOAD R0
	result(14) := "0000000000000000"; --Data
	result(15) := "0001000100000000"; --MOV R0 to R1
END initialize_ram;

SIGNAL raMem : mem := initialize_ram;

BEGIN
	PROCESS (clock)
	BEGIN
		IF (rising_edge(clock) and done='1') THEN
--			IF (write_enable = '1') THEN
--				raMem(to_integer(unsigned(write_addr))) <= data;
--			END IF;
			q <= raMem(to_integer(unsigned(read_addr)));
		END IF;
	END PROCESS;
END behavioural;