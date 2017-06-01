LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY binaryto4hex IS
PORT ( 
			binary : IN STD_LOGIC_VECTOR(15 downto 0);
			output0, output1, output2, output3 : OUT STD_LOGIC_VECTOR(6 downto 0)
		);
		
END binaryto4hex;

ARCHITECTURE Structural OF binaryto4hex IS
COMPONENT binary_to_sevenSeg
	PORT (
		binary_value : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		sevenSeg : OUT STD_LOGIC_VECTOR(6 downto 0)
		);
END COMPONENT;

BEGIN

bintoseg1: binary_to_sevenSeg PORT MAP (
			binary_value => binary(3 downto 0),
			sevenSeg => output0
			);
bintoseg2: binary_to_sevenSeg PORT MAP (
			binary_value => binary(7 downto 4),
			sevenSeg => output1
			);
bintoseg3: binary_to_sevenSeg PORT MAP (
			binary_value => binary(11 downto 8),
			sevenSeg => output2
			);
bintoseg4: binary_to_sevenSeg PORT MAP (
			binary_value => binary(15 downto 12),
			sevenSeg => output3
			);


  
END Structural;