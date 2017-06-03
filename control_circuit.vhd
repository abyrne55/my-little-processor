LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- Control Circuit (FSM)
ENTITY control_circuit IS
	PORT (
		clock, reset : IN STD_LOGIC;
		func : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		done, A_in, G_in, G_out, extern, R0_in, R1_in, R0_out, R1_out, R0_xor, R1_xor, PC_in, PC_out : OUT STD_LOGIC:='0';
		instr_preout: OUT STD_LOGIC_VECTOR(3 downto 0);
		c_state_preout : OUT INTEGER
	);
END;

ARCHITECTURE behavioural OF control_circuit IS
	COMPONENT find_ns IS
		PORT (
			state : IN INTEGER;
			reset: in STD_LOGIC;
			instr : IN std_logic_vector(3 DOWNTO 0);
			rx : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			ns : OUT INTEGER
		);
	END COMPONENT;

	SIGNAL c_state : INTEGER := 255;
	SIGNAL n_state : INTEGER := 0;
	--SIGNAL rx : STD_LOGIC_VECTOR(3 DOWNTO 0):= "ZZZZ";
	--SIGNAL ry : STD_LOGIC_VECTOR(3 DOWNTO 0):= "ZZZZ";

BEGIN

	instance1 : find_ns
	PORT MAP(
		reset => reset,
		state => c_state, 
		instr => func(15 DOWNTO 12),
		rx => func(11 DOWNTO 8),
		ns => n_state
	); 
	PROCESS (c_state, func)
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
		
		CASE c_state IS
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
	
			-- MOV States
			WHEN 20 =>
				--Decision State
			WHEN 21 =>
			-- Rx = R0
				R0_in <= '1';
				R1_out <= '1';
			WHEN 22 =>
			-- Rx = R1
				R1_in <= '1';
				R0_out <= '1';
			WHEN 23 => 
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
				--Decision State
			WHEN 41 =>
			--Rx = R0
					R1_out <= '1';
					R0_xor <= '1';
			WHEN 42 =>
			--Rx = R1
					R0_out <= '1';
					R1_xor <= '1';
			WHEN 43 => 
				done <= '1';
				
			-- LDPC, Load PC to Rx
			WHEN 50 =>
				--Decision State
			WHEN 51 =>
			--Rx = R0
				R0_in <= '1';
				PC_out <= '1';
			WHEN 52 =>
			--Rx = R1
				R1_in <= '1';
				PC_out <= '1';
			WHEN 53 =>
				done <= '1';
			
			-- BRANCH, Load Rx to PC
			WHEN 60 =>
				--Decision State
			WHEN 61 =>
			--Rx = R0
				PC_in <= '1';
				R0_out <= '1';
			WHEN 62 =>
			--Rx = R1
				PC_in <= '1';
				R1_out <= '1';
			WHEN 63 =>
				R1_out <= '1';
				done <= '1';
 
			WHEN OTHERS => 
				-- Return to IDLE
 
		END CASE;
	END PROCESS;
 
	PROCESS (clock)
		BEGIN
			IF rising_edge(clock) THEN
				c_state <= n_state;
			END IF;
	END PROCESS;
	
	c_state_preout <= c_state;
 
END behavioural;