LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- Control Circuit (FSM)
ENTITY control_circuit IS
	PORT (
		clock, reset : IN STD_LOGIC;
		func : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		done, A_in, G_in, G_out, extern, R0_in, R1_in, R0_out, R1_out, R0_xor, R1_xor, PC_in, PC_out : OUT STD_LOGIC:='0';
		instr_preout, rx_preout, ry_preout : OUT STD_LOGIC_VECTOR(3 downto 0);
		c_state_preout : OUT INTEGER
	);
END;

ARCHITECTURE behavioural OF control_circuit IS
	COMPONENT find_ns IS
		PORT (
			state : IN INTEGER;
			reset: in STD_LOGIC;
			instr : IN std_logic_vector(3 DOWNTO 0);
			ns : OUT INTEGER
		);
	END COMPONENT;

	SIGNAL c_state : INTEGER := 0;
	SIGNAL n_state : INTEGER := 0;
	SIGNAL rx : STD_LOGIC_VECTOR(3 DOWNTO 0);-- := "ZZZZ";
	SIGNAL ry : STD_LOGIC_VECTOR(3 DOWNTO 0);-- := "ZZZZ";

BEGIN
	--instruction <= func(15 DOWNTO 12);
	--rx <= func(11 DOWNTO 8);
	--ry <= func(7 DOWNTO 4);
	
	instance1 : find_ns
	PORT MAP(
		reset => reset,
		state => c_state, 
		instr => func(15 DOWNTO 12), 
		ns => n_state
	); 
	PROCESS (c_state, rx, func)
	BEGIN
		R0_in <= '0';
		CASE c_state IS
			-- IDLE State
			WHEN 0 =>
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
				done <= '1';
				rx <= func(11 DOWNTO 8);
				ry <= func(7 DOWNTO 4);
 
				-- LOAD States
			WHEN 10 => 
				done <= '0';
				IF rx = "0000" THEN
					R0_in <= '1';
					R1_in <= '0';
				ELSE
					R1_in <= '1';
					R0_in <= '0';
				END IF;
				extern <= '1';
			WHEN 11 => 
				done <= '1';
			WHEN 12 =>
				done <= '0';
				R0_in <= '0';
				R1_in <= '0';
			WHEN 13 => 
				extern <= '0';
			WHEN 14 =>
				R0_out <= '0';
				R1_out <= '0';
 
				-- MOV States
			WHEN 20 => 
				done <= '0';
				IF rx = "0000" THEN
					R0_in <= '1';
					R1_out <= '1';
				ELSE
					R1_in <= '1';
					R0_out <= '1';
				END IF;
			WHEN 21 => 
				G_out <= '0';
				extern <= '0';
				R0_in <= '0';
				R1_in <= '0';
				R0_out <= '0';
				R1_out <= '0';
 
				-- ADD States
			WHEN 30 => 
				done <= '0';
				R0_out <= '1';
				A_in <= '1';
			WHEN 31 => 
				R0_out <= '0';
				A_in <= '0';
			WHEN 32 => 
				R1_out <= '1';
				G_in <= '1';
			WHEN 33 => 
				R1_out <= '0';
				G_in <= '0';
			WHEN 34 => 
				A_in <= '0';
				G_in <= '0';
				R1_out <= '0';
				G_out <= '1';
			WHEN 35 =>
				IF rx = "0000" THEN
					R0_in <= '1';
				ELSE
					R1_in <= '1';
				END IF;
			WHEN 36 => 
				G_out <= '0';
				extern <= '0';
				R0_in <= '0';
				R1_in <= '0';
				R0_out <= '0';
				R1_out <= '0';
 
				-- XOR States
			WHEN 40 => 
				done <= '0';
				IF rx = "0001" THEN
					R0_out <= '1';
				ELSE
					R1_out <= '1';
				END IF;
			WHEN 41 => 
				IF rx = "0001" THEN
					R1_xor <= '1';
				ELSE
					R0_xor <= '1';
				END IF;
			WHEN 42 => 
				R0_xor <= '0';
				R1_xor <= '0';
				G_out <= '0';
				extern <= '0';
				R0_in <= '0';
				R1_in <= '0';
				R0_out <= '0';
				R1_out <= '0';
				
			-- Load PC to Rx
			WHEN 50 =>
				done <= '0';
				IF rx = "0000" THEN
					R0_in <= '1';
				ELSIF rx = "0001" THEN
					R1_in <= '1';
				END IF;
				PC_out <= '1';
			WHEN 51 =>
				R0_in <= '0';
				R1_in <= '0';
				PC_out <= '0';
			
			-- Load Rx to PC
			WHEN 60 =>
				done <= '0';
				IF rx = "0000" THEN
					R0_out <= '1';
				ELSIF rx = "0001" THEN
					R1_out <= '1';
				END IF;
				PC_in <= '1';
			WHEN 61 =>
				R0_out <= '0';
				R1_out <= '0';
				PC_in <= '0';
 
			WHEN OTHERS => 
				G_out <= '0';
				extern <= '0';
				R0_in <= '0';
				R1_in <= '0';
				R0_out <= '0';
				R1_out <= '0';
				-- GRAD STUDENT STATES
 
		END CASE;
	END PROCESS;
 
	PROCESS (clock)
		BEGIN
			IF rising_edge(clock) THEN
				c_state <= n_state;
			END IF;
	END PROCESS;
	
	c_state_preout <= c_state;
	rx_preout <= rx;
	ry_preout <= ry;
 
END behavioural;