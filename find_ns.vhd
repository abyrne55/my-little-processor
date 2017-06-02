LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY find_ns IS
	PORT (
		state : IN INTEGER;
		reset: in STD_LOGIC;
		instr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		rx : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		ns : OUT INTEGER
	);
END find_ns;

ARCHITECTURE behavioural OF find_ns IS
BEGIN
	PROCESS (state, instr, reset, rx)
	BEGIN
		IF reset = '1' THEN
			ns <= 255;
		-- LOAD Rx
		ELSIF state = 0 AND instr = "0000" THEN
			ns <= 10;
		-- MOV Ry into Rx
		ELSIF state = 0 AND instr = "0001" THEN
			ns <= 20;
		-- ADD, store in Rx
		ELSIF state = 0 AND instr = "0010" THEN
			ns <= 30;
		-- XOR, store in Rx
		ELSIF state = 0 AND instr = "0011" THEN
			ns <= 40;
		-- Store PC in Rx
		ELSIF state = 0 AND instr = "0100" THEN
			ns <= 50;
		-- Load PC from Rx
		ELSIF state = 0 AND instr = "0101" THEN
			ns <= 60;

		-- LOAD
		ELSIF state = 10 THEN
			IF rx = "0000" THEN
				ns <= 11;
			ELSE
				ns <= 12;
			END IF;
		ELSIF state = 11 THEN
			ns <= 13;
		ELSIF state = 12 THEN
			ns <= 13;
		ELSIF state = 13 THEN
			ns <= 0;
		
		ELSIF state = 20 THEN
			IF rx = "0000" THEN
				ns <= 21;
			ELSE
				ns <= 22;
			END IF;
		ELSIF state = 21 THEN
			ns <= 23;
		ELSIF state = 22 THEN
			ns <= 23;
		ELSIF state = 23 THEN
			ns <= 0;
		ELSIF state = 30 THEN
			ns <= 31;
		ELSIF state = 31 THEN
			IF rx = "0000" THEN
				ns <= 32;
			ELSE
				ns <= 33;
			END IF;
		ELSIF state = 32 THEN
			ns <= 34;
		ELSIF state = 32 THEN
			ns <= 34;
		ELSIF state = 34 THEN
			ns <= 0;
		ELSIF state = 40 THEN
			IF rx = "0000" THEN
				ns <= 41;
			ELSE
				ns <= 42;
			END IF;
		ELSIF state = 41 THEN
			ns <= 43;
		ELSIF state = 42 THEN
			ns <= 43;
		ELSIF state = 43 THEN
			ns <= 0;
		ELSIF state = 50 THEN
			IF rx = "0000" THEN
				ns <= 51;
			ELSE
				ns <= 52;
			END IF;
		ELSIF state = 51 THEN
			ns <= 53;
		ELSIF state = 52 THEN
			ns <= 53;
		ELSIF state = 53 THEN
			ns <= 0;
		ELSIF state = 60 THEN
			IF rx = "0000" THEN
				ns <= 61;
			ELSE
				ns <= 62;
			END IF;
		ELSIF state = 61 THEN
			ns <= 63;
		ELSIF state = 62 THEN
			ns <= 63;
		ELSIF state = 63 THEN
			ns <= 0;
		ELSE
			ns <= 0;
		END IF;
	END PROCESS;
END behavioural;