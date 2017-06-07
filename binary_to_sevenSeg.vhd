LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY binary_to_sevenSeg IS
	PORT (
		binary_value  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		sevenSeg      : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END;

ARCHITECTURE behavioural OF binary_to_sevenSeg IS
 
BEGIN
	PROCESS (binary_value)
	BEGIN
		CASE binary_value IS
			WHEN "0000" => sevenSeg <= "1000000";
			WHEN "0001" => sevenSeg <= "1001111";
			WHEN "0010" => sevenSeg <= "0100100";
			WHEN "0011" => sevenSeg <= "0110000";
			WHEN "0100" => sevenSeg <= "0011001";
			WHEN "0101" => sevenSeg <= "0010010";
			WHEN "0110" => sevenSeg <= "0000010";
			WHEN "0111" => sevenSeg <= "1111000";
			WHEN "1000" => sevenSeg <= "0000000";
			WHEN "1001" => sevenSeg <= "0010000";
			WHEN "1010" => sevenSeg <= "0001000";
			WHEN "1011" => sevenSeg <= "0000000";
			WHEN "1100" => sevenSeg <= "1000110";
			WHEN "1101" => sevenSeg <= "1000000";
			WHEN "1110" => sevenSeg <= "0000110";
			WHEN "1111" => sevenSeg <= "0001110";
			WHEN OTHERS => sevenSeg <= "1111111";
		END CASE;
	END PROCESS; 
 
END behavioural;