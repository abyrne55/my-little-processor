LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- Control Circuit (FSM)
ENTITY control_circuit IS
	PORT (
		clock, reset                                   : IN STD_LOGIC;
		func                                           : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		done, A_in, G_in, G_out, extern, R0_in, R1_in  : OUT STD_LOGIC := '0';
		R0_out, R1_out, R0_xor, R1_xor, PC_in, PC_out  : OUT STD_LOGIC := '0';
		c_state                                        : OUT INTEGER
	);
END;

ARCHITECTURE behavioural OF control_circuit IS
	COMPONENT find_ns IS
		PORT (
			state   : IN INTEGER;
			reset   : IN STD_LOGIC;
			instr   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			rx, ry  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			ns      : OUT INTEGER
		);
	END COMPONENT;

	SIGNAL c_state_temp : INTEGER := 255;
	SIGNAL n_state : INTEGER := 0;

BEGIN
	instance1 : find_ns
	PORT MAP(
		reset  => reset, 
		state  => c_state_temp, 
		instr  => func(15 DOWNTO 12), 
		rx     => func(11 DOWNTO 8), 
		ry     => func(7 DOWNTO 4), 
		ns     => n_state
	);
	PROCESS (c_state_temp, func)
	BEGIN
		done <= '0';
		R0_in <= '0';
		R0_in <= '0';
		R0_out <= '0';
		R0_xor <= '0';
		R1_in <= '0';
		R1_out <= '0';
		R1_xor <= '0';
		PC_in <= '0';
		PC_out <= '0';
		A_in <= '0';
		G_in <= '0';
		G_out <= '0';
		extern <= '0';
 
		CASE c_state_temp IS
			-- START state
			WHEN 255 => 
				done <= '1';
 
				-- IDLE State
			WHEN 0 => 
				-- Wait for next instruction
 
				-- LOAD States
			WHEN 10 => 
				done <= '1';
			WHEN 11 => 
				--Rx = R0
				extern <= '1';
				R0_in <= '1';
			WHEN 12 => 
				-- Rx = R1
				extern <= '1';
				R1_in <= '1';
			WHEN 13 => 
				extern <= '1';
				done <= '1';
			WHEN 14 => 
				done <= '1';
 
				-- MOV States
			WHEN 20 => 
				-- Rx = R0
				R0_in <= '1';
				R1_out <= '1';
			WHEN 21 => 
				-- Rx = R1
				R1_in <= '1';
				R0_out <= '1';
			WHEN 22 => 
				done <= '1';

				-- ADD States
			WHEN 30 => 
				R0_out <= '1';
				A_in <= '1';
			WHEN 31 => 
				R1_out <= '1';
				G_in <= '1';
			WHEN 32 => 
				-- Rx = R0
				G_out <= '1';
				R0_in <= '1';
			WHEN 33 => 
				-- Rx = R1
				G_out <= '1';
				R1_in <= '1';
			WHEN 34 => 
				done <= '1';

				-- XOR States
			WHEN 40 => 
				--Rx = R0
				R1_out <= '1';
				R0_xor <= '1';
			WHEN 41 => 
				--Rx = R1
				R0_out <= '1';
				R1_xor <= '1';
			WHEN 42 => 
				done <= '1';
 
				-- LDPC, Load PC to Rx
			WHEN 50 => 
				--Rx = R0
				R0_in <= '1';
				PC_out <= '1';
			WHEN 51 => 
				--Rx = R1
				R1_in <= '1';
				PC_out <= '1';
			WHEN 52 => 
				done <= '1';
 
				-- BRANCH, Load Rx to PC
			WHEN 60 => 
				--Rx = R0
				PC_in <= '1';
				R0_out <= '1';
			WHEN 61 => 
				--Rx = R1
				PC_in <= '1';
				R1_out <= '1';
			WHEN 62 => 
				R1_out <= '1';
				done <= '1';
 
				--Double Ry, store in Rx
			WHEN 701 => 
				--Rx = R0, Ry = R0
				R0_out <= '1';
				A_in <= '1';
			WHEN 702 => 
				R0_out <= '1';
				G_in <= '1';
			WHEN 703 => 
				G_out <= '1';
				R0_in <= '1';
			WHEN 711 => 
				--Rx = R1, Ry = R0
				R0_out <= '1';
				A_in <= '1';
				G_in <= '1';
			WHEN 712 => 
				R0_out <= '1';
				G_in <= '1';
			WHEN 713 => 
				G_out <= '1';
				R1_in <= '1';
			WHEN 721 => 
				--Rx = R0, Ry = R1
				R1_out <= '1';
				A_in <= '1';
				G_in <= '1';
			WHEN 722 => 
				R1_out <= '1';
				G_in <= '1';
			WHEN 723 => 
				G_out <= '1';
				R0_in <= '1';
			WHEN 731 => 
				--Rx = R1, Ry = R1
				R1_out <= '1';
				A_in <= '1';
				G_in <= '1';
			WHEN 732 => 
				R1_out <= '1';
				G_in <= '1';
			WHEN 733 => 
				G_out <= '1';
				R1_in <= '1';
			WHEN 740 => 
				done <= '1';

			WHEN OTHERS => 
				-- Return to IDLE

		END CASE;
	END PROCESS;

	PROCESS (clock)
		BEGIN
			IF rising_edge(clock) THEN
				c_state_temp <= n_state;
			END IF;
		END PROCESS;
 
		c_state <= c_state_temp;

END behavioural;