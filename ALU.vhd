LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
library STD;
use STD.textio.all;
USE ieee.numeric_std.ALL; 
-- 16-bit ALU 
ENTITY ALU IS 
	PORT(
		A,B: in STD_LOGIC_VECTOR(15 downto 0);
		opcode: in STD_LOGIC_VECTOR(2 downto 0);
		output: out STD_LOGIC_VECTOR(15 downto 0);
		flag: out STD_LOGIC := '0' 
	);
END ALU;

ARCHITECTURE behavioural OF ALU IS
SIGNAL a_int,b_int : INTEGER := 0;
BEGIN
	a_int <= to_integer(unsigned(A));
	b_int <= to_integer(unsigned(B));
	PROCESS(opcode, A, B, a_int, b_int)
	begin
		flag <= '0';
		CASE opcode IS
			WHEN "000" => -- Idle/Passthrough
				flag <= '0';
				output <= B;

			-- Artimetic Operations (requires bounds check)
			WHEN "001" => -- ADD
				IF (a_int + b_int > 65535) then
					flag <= '1';
					output <= "0000000000000000";
				ELSE
					flag <= '0';
					output <= A + B;
				END IF;
			WHEN "010" => -- SUB
				IF (a_int - b_int < 0) then
					flag <= '1';
					output <= "0000000000000000";
				ELSE
					flag <= '0';
					output <= A - B;
				END IF;
			WHEN "011" => -- MUL
				IF (a_int * b_int > 65535) then
					flag <= '1';
					output <= "0000000000000000";
				ELSE
					flag <= '0';
					output <= std_logic_vector(to_unsigned(A_int*B_int, output'length));
				END IF;
				
			-- Bitwise operations, no bounds check necessary
			WHEN "100" => -- AND
				flag <= '0';
				output <= A and B;
			WHEN "101" => -- OR
				flag <= '0';
				output <= A or B;
			WHEN "110" => -- XOR
				flag <= '0';
				output <= A xor B;
			WHEN "111" => -- XNOR
				flag <= '0';
				output <= A xnor B;
				
			WHEN OTHERS => -- Invalid Operation
				output <= "0000000000000000";
		END CASE;
	END PROCESS;
END behavioural;