LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
library STD;
use STD.textio.all;
USE ieee.numeric_std.ALL; 
-- 16-bit Adder 
ENTITY Adder IS 
	PORT(
		A,B: in STD_LOGIC_VECTOR(15 downto 0);
		output: out STD_LOGIC_VECTOR(15 downto 0);
		flag: out STD_LOGIC
	);
END Adder;

ARCHITECTURE behavioural OF Adder IS
SIGNAL out_temp: INTEGER;
BEGIN
out_temp <= to_integer(unsigned(A)) + to_integer(unsigned(B));
	PROCESS(out_temp)
	begin
		IF out_temp <= 65535 THEN
			flag <= '0';
			output <= std_logic_vector(to_unsigned(out_temp, 16));
		ELSE
			flag <= '1';
			output <= "0000000000000000";
		END IF;
	END PROCESS;
END behavioural;