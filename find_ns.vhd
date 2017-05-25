LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY find_ns IS
	PORT (
			state : in INTEGER;
			ns : out INTEGER
			);
END find_ns;

ARCHITECTURE behavioural OF find_ns IS
BEGIN
	PROCESS(state)
	begin
		case state is
			when 10 => ns <= 11;
			when 11 => ns <= 12;
			when 12 => ns <= 0;
			when 20 => ns <= 21;
			when 21 => ns <= 0;
			when 30 => ns <= 31;
			when 31 => ns <= 32;
			when 32 => ns <= 33;
			when 33 => ns <= 0;
			when 40 => ns <=41;
			when 41 => ns <= 42;
			when 42 => ns <= 0;
		end case;
	end process;
end behavioural;
	
	
	