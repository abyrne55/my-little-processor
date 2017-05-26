LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY find_ns IS
	PORT (
			state : in INTEGER;
			instr : IN STD_LOGIC_VECTOR(3 downto 0);
			ns : out INTEGER
			);
END find_ns;

ARCHITECTURE behavioural OF find_ns IS
BEGIN
	PROCESS(state, instr)
	begin
		IF state = 0 and instr = "0000" then
			ns <= 10;
		ELSIF state = 0 and instr = "0001" then
			ns <= 20;
		ELSIF state = 0 and instr = "0010" then
			ns <= 30;
		ELSIF state = 0 and instr = "0011" then
			ns <= 40;
		ELSIF state = 10 then
			ns <= 11;
		ELSIF state = 11 then
			ns <= 12;
		ELSIF state = 12 then
			ns <= 0;
		ELSIF state = 20 then
			ns <= 21;
		ELSIF state = 21 then
			ns <= 0;
		ELSIF state = 30 then
			ns <= 31;
		ELSIF state = 31 then
			ns <= 32;
		ELSIF state = 32 then
			ns <= 33;
		ELSIF state = 33 then
			ns <= 0;
		ELSIF state = 40 then
			ns <= 41;
		ELSIF state = 41 then
			ns <= 42;
		ELSIF state = 42 then
			ns <= 0;
		ELSE
			ns <= 0;
		END IF;
	end process;
end behavioural;
	
	
	