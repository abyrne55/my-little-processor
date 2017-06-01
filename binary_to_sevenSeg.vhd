LIBRARY ieee; 
USE ieee.std_logic_1164.all;

ENTITY binary_to_sevenSeg IS
		PORT ( 	
					binary_value 	: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
					sevenSeg 		: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
				);
END;

ARCHITECTURE behavioural of binary_to_sevenSeg is 
	
begin 

	process(binary_value ) 
	begin 
		case binary_value is 
			when "0000"    =>  sevenSeg <= "1000000";
			when "0001"    =>  sevenSeg <= "1001111";
			when "0010"    =>  sevenSeg <= "0100100";
			when "0011"    =>  sevenSeg <= "0110000";
			when "0100"    =>  sevenSeg <= "0011001";
			when "0101"    =>  sevenSeg <= "0010010";
			when "0110"    =>  sevenSeg <= "0000010";
			when "0111"    =>  sevenSeg <= "1111000";
			when "1000"    =>  sevenSeg <= "0000000";
			when "1001"    =>  sevenSeg <= "0010000";
			when "1010"    =>  sevenSeg <= "0001000";
			when "1011"    =>  sevenSeg <= "0000000";
			when "1100"    =>  sevenSeg <= "1000110";
			when "1101"    =>  sevenSeg <= "1000000";
			when "1110"    =>  sevenSeg <= "0000110";
			when "1111"    =>  sevenSeg <= "0001110";
			when others 	=>  sevenSeg <= "1111111";
		end case;
	end process;		  
		  
END behavioural;
