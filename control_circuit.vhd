LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- Control Circuit (FSM)
ENTITY control_circuit IS
	PORT(
		clock: in STD_LOGIC;
		func: in STD_LOGIC_VECTOR (15 downto 0);
		
		R0_in, R1_in, R2_in, R3_in, R4_in: out STD_LOGIC;
		R0_out, R1_out, R2_out, R3_out, R4_out: out STD_LOGIC;
		
		A_in, G_in, G_out, ALU, extern: out STD_LOGIC;
		done: out STD_LOGIC;
	);
END;

ARCHITECTURE behavioural OF control_circuit IS

BEGIN
	-- Define your finite state machine here...
END behavioural;