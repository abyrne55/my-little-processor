LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- Control Circuit (FSM)
ENTITY control_circuit IS
	PORT (
		clock : IN STD_LOGIC;
		func : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
 
		R0_in, R1_in : OUT STD_LOGIC;
		R0_out, R1_out : OUT STD_LOGIC;
		R0_xor, R1_xor : OUT STD_LOGIC;
		
		PC_in: OUT STD_LOGIC;
		PC_out: OUT STD_LOGIC;
 
		A_in, G_in, G_out, extern : OUT STD_LOGIC;
		done : OUT STD_LOGIC
	);
END;

ARCHITECTURE behavioural OF control_circuit IS
	COMPONENT find_ns IS
		PORT (
			state : IN INTEGER;
			instr : IN std_logic_vector(3 DOWNTO 0);
			ns : OUT INTEGER
		);
	END COMPONENT;

	SIGNAL c_state : INTEGER;
	SIGNAL n_state : INTEGER;
	SIGNAL instruction : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL rx : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL ry : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
	instruction <= func(3 DOWNTO 0);
	rx <= func(7 DOWNTO 4);
	ry <= func(11 DOWNTO 8);

	instance1 : find_ns
	PORT MAP(
		state => c_state, 
		instr => func(3 DOWNTO 0), 
		ns => n_state
	); 
	PROCESS (c_state, rx)
	BEGIN
		CASE c_state IS
			-- IDLE State
			WHEN 0 => 
				done <= '1';
 
				-- LOAD States
			WHEN 10 => 
				done <= '0';
				IF rx = "0000" THEN
					r0_in <= '1';
				ELSE
					r1_in <= '1';
				END IF;
				extern <= '1';
			WHEN 11 => 
				done <= '1';
			WHEN 12 => 
				done <= '0';
				G_out <= '0';
				extern <= '0';
				r0_in <= '0';
				r1_in <= '0';
				r0_out <= '0';
				r1_out <= '0';
 
				-- MOV States
			WHEN 20 => 
				done <= '0';
				IF rx = "0000" THEN
					r0_in <= '1';
					r1_out <= '1';
				ELSE
					r1_in <= '1';
					r0_out <= '1';
				END IF;
			WHEN 21 => 
				G_out <= '0';
				extern <= '0';
				r0_in <= '0';
				r1_in <= '0';
				r0_out <= '0';
				r1_out <= '0';
 
				-- ADD States
			WHEN 30 => 
				done <= '0';
				R0_out <= '1';
				A_in <= '1';
			WHEN 31 => 
				R0_out <= '0';
				A_in <= '0';
				R1_out <= '1';
				G_in <= '1';
			WHEN 32 => 
				A_in <= '0';
				G_in <= '0';
				R1_out <= '0';
				G_out <= '1';
				IF rx = "0000" THEN
					R0_in <= '1';
				ELSE
					R1_in <= '1';
				END IF;
			WHEN 33 => 
				G_out <= '0';
				extern <= '0';
				r0_in <= '0';
				r1_in <= '0';
				r0_out <= '0';
				r1_out <= '0';
 
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
				r0_in <= '0';
				r1_in <= '0';
				r0_out <= '0';
				r1_out <= '0';
				
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
				r0_in <= '0';
				r1_in <= '0';
				r0_out <= '0';
				r1_out <= '0';
				-- GRAD STUDENT STATES
 
		END CASE;
	END PROCESS;
 
	PROCESS (clock)
		BEGIN
			IF rising_edge(clock) THEN
				c_state <= n_state;
			END IF;
		END PROCESS;
 
END behavioural;