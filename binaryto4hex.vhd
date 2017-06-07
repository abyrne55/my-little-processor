LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY binaryto4hex IS
	PORT (
		binary                              : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		output0, output1, output2, output3  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
 
END binaryto4hex;

ARCHITECTURE Behavioural OF binaryto4hex IS
	COMPONENT binary_to_sevenSeg
		PORT (
			binary_value  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			sevenSeg      : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;
BEGIN
	bintoseg1 : binary_to_sevenSeg
	PORT MAP(
		binary_value  => binary(15 DOWNTO 12), 
		sevenSeg      => output3
	);
	bintoseg2 : binary_to_sevenSeg
	PORT MAP(
		binary_value  => binary(11 DOWNTO 8), 
		sevenSeg      => output2
	);
	bintoseg3 : binary_to_sevenSeg
	PORT MAP(
		binary_value  => binary(7 DOWNTO 4), 
		sevenSeg      => output1
	);
	bintoseg4 : binary_to_sevenSeg
	PORT MAP(
		binary_value  => binary(3 DOWNTO 0), 
		sevenSeg      => output0
	);
 
END Behavioural;