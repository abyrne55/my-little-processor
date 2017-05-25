LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- 16-bit Adder 
ENTITY ALU IS 
	PORT(
		A,B: in STD_LOGIC_VECTOR(15 downto 0);
		output: out STD_LOGIC_VECTOR(15 downto 0)
		flag: out STD_LOGIC;
	);
END ALU;

ARCHITECTURE behavioural OF ALU IS
BEGIN
	PROCESS(A,B)
		IF unsigned(A+B) > 65535 then
			flag <= '1';
			output <= "0000000000000000";
		ELSE
			flag <= '0';
			output <= A + B;
		END IF;
	END PROCESS;
END behavioural;