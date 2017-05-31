LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY find_ns IS
	PORT (
		state : IN INTEGER;
		reset: in STD_LOGIC;
		instr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		ns : OUT INTEGER
	);
END find_ns;

ARCHITECTURE behavioural OF find_ns IS
BEGIN
	PROCESS (state, instr, reset)
	BEGIN
		IF reset = '1' THEN
			ns <= 0;
		ELSIF state = 0 AND instr = "0000" THEN
			ns <= 10;
		ELSIF state = 0 AND instr = "0001" THEN
			ns <= 20;
		ELSIF state = 0 AND instr = "0010" THEN
			ns <= 30;
		ELSIF state = 0 AND instr = "0011" THEN
			ns <= 40;
		ELSIF state = 0 AND instr = "0100" THEN
			ns <= 50;
		ELSIF state = 0 AND instr = "0101" THEN
			ns <= 60;
		ELSIF state = 10 THEN
			ns <= 11;
		ELSIF state = 11 THEN
			ns <= 12;
		ELSIF state = 12 THEN
			ns <= 0;
		ELSIF state = 20 THEN
			ns <= 21;
		ELSIF state = 21 THEN
			ns <= 0;
		ELSIF state = 30 THEN
			ns <= 31;
		ELSIF state = 31 THEN
			ns <= 32;
		ELSIF state = 32 THEN
			ns <= 33;
		ELSIF state = 33 THEN
			ns <= 0;
		ELSIF state = 40 THEN
			ns <= 41;
		ELSIF state = 41 THEN
			ns <= 42;
		ELSIF state = 42 THEN
			ns <= 0;
		ELSIF state = 50 THEN
			ns <= 51;
		ELSIF state = 51 THEN
			ns <= 0;
		ELSIF state = 60 THEN
			ns <= 61;
		ELSIF state = 61 THEN
			ns <= 0;
		ELSE
			ns <= 0;
		END IF;
	END PROCESS;
END behavioural;