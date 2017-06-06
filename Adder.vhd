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
BEGIN
	PROCESS(A,B)
	begin
		IF to_integer(unsigned(A+B)) > 65535 then
			flag <= '1';
			output <= "0000000000000000";
		ELSE
			flag <= '0';
			output <= A + B;
		END IF;
	END PROCESS;
END behavioural;