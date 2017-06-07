LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY find_ns IS
	PORT (
		state   : IN INTEGER;
		reset   : IN STD_LOGIC;
		instr   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		rx, ry  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		ns      : OUT INTEGER
	);
END find_ns;

ARCHITECTURE behavioural OF find_ns IS
BEGIN
	PROCESS (state, instr, reset, rx, ry)
	BEGIN
		IF reset = '1' THEN
			ns <= 255;
			-- LOAD Rx
		ELSIF state = 0 AND instr = "0000" THEN
			ns <= 10;
			-- MOV Ry into Rx
		ELSIF state = 0 AND instr = "0001" THEN
			IF rx = "0000" AND ry = "0001" THEN
				ns <= 20;
			ELSIF rx = "0001" AND ry = "0000" THEN
				ns <= 21;
			ELSE
				ns <= 255;
			END IF;
			-- ADD, store in Rx
		ELSIF state = 0 AND instr = "0010" THEN
			ns <= 30;
			-- XOR, store in Rx
		ELSIF state = 0 AND instr = "0011" THEN
			IF rx = "0000" AND ry = "0001" THEN
				ns <= 40;
			ELSIF rx = "0001" AND ry = "0000" THEN
				ns <= 41;
			ELSE
				ns <= 255;
			END IF;
			-- LDPC, Store PC in Rx
		ELSIF state = 0 AND instr = "0100" THEN
			IF rx = "0000" THEN
				ns <= 50;
			ELSIF rx = "0001" THEN
				ns <= 51;
			ELSE
				ns <= 255;
			END IF;
			-- BRANCH, Load PC from Rx
		ELSIF state = 0 AND instr = "0101" THEN
			IF rx = "0000" THEN
				ns <= 60;
			ELSIF rx = "0001" THEN
				ns <= 61;
			ELSE
				ns <= 255;
			END IF;
			-- Double Ry, store in Rx
		ELSIF state = 0 AND instr = "0110" THEN
			IF rx = "0000" AND ry = "0000" THEN
				ns <= 701;
			ELSIF rx = "0001" AND ry = "0000" THEN
				ns <= 711;
			ELSIF rx = "0000" AND ry = "0001" THEN
				ns <= 721;
			ELSIF rx = "0001" AND ry = "0001" THEN
				ns <= 731;
			ELSE
				ns <= 255;
			END IF;
			-- LOAD
		ELSIF state = 10 THEN
			IF rx = "0000" THEN
				ns <= 11;
			ELSIF rx = "0001" THEN
				ns <= 12;
			ELSE
				ns <= 255;
			END IF;
		ELSIF state = 11 THEN
			ns <= 13;
		ELSIF state = 12 THEN
			ns <= 13;
		ELSIF state = 13 THEN
			ns <= 0;
 
			-- MOV
		ELSIF state = 20 THEN
			ns <= 22;
		ELSIF state = 21 THEN
			ns <= 22;
		ELSIF state = 22 THEN
			ns <= 0;
 
			-- ADD
		ELSIF state = 30 THEN
			ns <= 31;
		ELSIF state = 31 THEN
			IF rx = "0000" AND ry = "0001" THEN
				ns <= 32;
			ELSIF rx = "0001" AND ry = "0000" THEN
				ns <= 33;
			ELSE
				ns <= 255;
			END IF;
		ELSIF state = 32 THEN
			ns <= 34;
		ELSIF state = 32 THEN
			ns <= 34;
		ELSIF state = 34 THEN
			ns <= 0;
 
			-- XOR
		ELSIF state = 40 THEN
			ns <= 42;
		ELSIF state = 41 THEN
			ns <= 42;
		ELSIF state = 42 THEN
			ns <= 0;
 
			-- LDPC
		ELSIF state = 50 THEN
			ns <= 52;
		ELSIF state = 51 THEN
			ns <= 52;
		ELSIF state = 52 THEN
			ns <= 0;
 
			-- BRANCH
		ELSIF state = 60 THEN
			ns <= 62;
		ELSIF state = 61 THEN
			ns <= 62;
		ELSIF state = 62 THEN
			ns <= 0;
 
			-- Double Ry, store in Rx
		ELSIF state = 701 THEN
			ns <= 702;
		ELSIF state = 702 THEN
			ns <= 703;
		ELSIF state = 703 THEN
			ns <= 740;
		ELSIF state = 711 THEN
			ns <= 712;
		ELSIF state = 712 THEN
			ns <= 713;
		ELSIF state = 713 THEN
			ns <= 740;
		ELSIF state = 721 THEN
			ns <= 722;
		ELSIF state = 722 THEN
			ns <= 723;
		ELSIF state = 723 THEN
			ns <= 740;
		ELSIF state = 731 THEN
			ns <= 732;
		ELSIF state = 732 THEN
			ns <= 733;
		ELSIF state = 733 THEN
			ns <= 740;
		ELSIF state = 740 THEN
			ns <= 0;
		ELSIF state = 255 THEN
			ns <= 0;
		ELSE
			ns <= 255;
		END IF;
	END PROCESS;
END behavioural;