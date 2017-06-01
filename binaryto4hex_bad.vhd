LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

ENTITY binaryto4hex IS
PORT ( 
			binary : IN STD_LOGIC_VECTOR(15 downto 0);
			output0, output1, output2, output3 : OUT STD_LOGIC_VECTOR(6 downto 0)
		);
		
END binaryto4hex;

ARCHITECTURE Behavioural OF binaryto4hex IS
COMPONENT binary_to_sevenSeg
	PORT (
		binary_value : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		sevenSeg : OUT STD_LOGIC_VECTOR(6 downto 0)
		);
END COMPONENT;

SIGNAL H0, H1, H2, H3 : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL num : INTEGER;

BEGIN
num <= to_integer(unsigned(binary));
PROCESS (num)
begin
	IF num < 10 THEN
		H3 <= "0000";
		H2 <= "0000";
		H1 <= "0000";
		H0 <= std_logic_vector(to_unsigned(num, 4));
	ELSIF num < 100 THEN
		H3 <= "0000";
		H2 <= "0000";
		H1 <= std_logic_vector(to_unsigned(num/10, 4));
		H0 <= std_logic_vector(to_unsigned(num rem 10, 4));
	ELSIF num < 1000 THEN
		H3 <= "0000";
		H2 <= std_logic_vector(to_unsigned(num/100, 4));
		H1 <= std_logic_vector(to_unsigned((num rem 100)/10, 4));
		H0 <= std_logic_vector(to_unsigned(num rem 10, 4));
	ELSE
		H3 <= std_logic_vector(to_unsigned(num/1000, 4));
		H2 <= std_logic_vector(to_unsigned((num rem 1000)/100, 4));
		H1 <= std_logic_vector(to_unsigned((num rem 100)/10, 4));
		H0 <= std_logic_vector(to_unsigned(num rem 10, 4));
	END IF;
END PROCESS;
		
	
		
bintoseg1: binary_to_sevenSeg PORT MAP (
			binary_value => H0,
			sevenSeg => output0
			);
bintoseg2: binary_to_sevenSeg PORT MAP (
			binary_value => H1,
			sevenSeg => output1
			);
bintoseg3: binary_to_sevenSeg PORT MAP (
			binary_value => H2,
			sevenSeg => output2
			);
bintoseg4: binary_to_sevenSeg PORT MAP (
			binary_value => H3,
			sevenSeg => output3
			);


  
END Behavioural;