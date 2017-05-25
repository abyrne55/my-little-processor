LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- Control Circuit (FSM)
ENTITY control_circuit IS
	PORT(
		clock: in STD_LOGIC;
		func: in STD_LOGIC_VECTOR (15 downto 0);
		
		R0_in, R1_in: out STD_LOGIC;
		R0_out, R1_out: out STD_LOGIC;
		R0_xor, R1_xor: out STD_LOGIC;
		
		A_in, G_in, G_out, extern: out STD_LOGIC;
		done: out STD_LOGIC
	);
END;

ARCHITECTURE behavioural OF control_circuit IS
COMPONENT find_ns IS
			PORT(
					state: in INTEGER;
					ns: out INTEGER
					);
END COMPONENT;

SIGNAL c_state : INTEGER;
SIGNAL n_state : INTEGER;
SIGNAL instruction : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL rx : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL ry : STD_LOGIC_VECTOR(3 downto 0);

BEGIN
	instruction <= func(15 downto 12);
	rx <= func(11 downto 8);
	ry <= func(7 downto 4);

	instance1: find_ns PORT MAP(
		state => c_state,
		ns => n_state
	);
	PROCESS(func)
	BEGIN
		CASE instruction IS
			-- LOAD Rx
			when "0000" => c_state <= 10;
			-- MOV Rx, Ry
			when "0001" => c_state <= 20;
			-- ADD Rx, Ry
			when "0010" => c_state <= 30;
			-- XOR Rx, RY
			when "0011" => c_state <= 40;
			-- RESET
			when "1111" =>
			-- GRAD LEVEL
			--...
		END CASE;
	END PROCESS;
	
	PROCESS (c_state)
	BEGIN
		CASE c_state IS
			-- IDLE State
			when 0 =>
				done <= '1';
		
			-- LOAD States
			when 10 => 
				done <= '0';
				IF rx = "0000" THEN
					r0_in <= '1';
				ELSE 
					r1_in <= '1';
				END IF;
				extern <= '1';
			when 11 =>
				done <= '1';
			when 12 => 
				done <= '0';
				G_out,extern,r0_in,r1_in,r0_out,r1_out <= '0';
			
			-- MOV States
			when 20 =>
				done <= '0';
				IF rx = "0000" THEN
					r0_in <= '1';
					r1_out <= '1';
				ELSE 
					r1_in <= '1';
					r0_out <= '1';
				END IF;
			when 21 =>
				G_out,extern,r0_in,r1_in,r0_out,r1_out <= '0';
			
			-- ADD States
			when 30 =>
				done <= '0';
				R0_out, A_in <= '1';
			when 31 =>
				R0_out, A_in <= '0';
				R1_out, G_in <= '1';
			when 32 =>
				A_out, G_in, R1_out <= '0';
				G_out <= '1';
				IF rx = "0000" THEN
					R0_in <= '1';
				ELSE
					R1_in <= '1';
				END IF;
			when 33 =>
				G_out,extern,r0_in,r1_in,r0_out,r1_out <= '0';
			
			-- XOR States
			when 40 =>
				done <= '0';
				IF ry = "0000" THEN
					R0_out <= '1';
				ELSE
					R1_out <= '1';
				END IF;
			when 41 =>
				IF ry = "0000" THEN
					R1_xor <= '1';
				ELSE
					R0_xor <= '1';
				END IF;
			when 42 =>
				R0_xor, R1_xor <= '0';
				G_out,extern,r0_in,r1_in,r0_out,r1_out <= '0';
				
			when others =>
				G_out,extern,r0_in,r1_in,r0_out,r1_out <= '0';
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
