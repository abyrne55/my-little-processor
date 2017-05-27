LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
USE ieee.numeric_std.ALL; 

-- entity declaration for your testbench.Dont declare any ports here
ENTITY project_testbench IS 
END project_testbench;

ARCHITECTURE behavior OF project_testbench IS

	-- ------------------ Add Componenets ------------------
	-- Add your components here
	COMPONENT my_little_processor PORT (
		clock, reset : IN STD_LOGIC;
		data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		flag_out : OUT STD_LOGIC;
		done_out : OUT STD_LOGIC;
		read_addr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
	END COMPONENT;
	-- ------------------ Add Componenets ------------------
	
	-- cnt is for the testbench only, use to set test values for every clock cycle
	signal cnt: integer:= 0;
	
	-- Internal Signals
	-- Your circuit will need clk and reset signals.
	signal clk_in, reset_in  : STD_LOGIC;
	
	-- For the initial part, it will also need an assembly code input
	signal code 				: std_logic_vector(22 downto 0);
	
	-- For the testbench, the assembly code is 23 bits of the following form
	-- Load: 3 bit operation code (000), 4-bit destination register  (note x"" 
	-- means hex, so for example, x"A" would mean register 10), then 16-bit data 
	-- value (note once again this is defined using hex. e.g x"12AB" would equal
	-- "0001 0010 1010 1011")
	-- mov: 3 bit operation code (001), 4-bit destination register, 4-bit input register, 12 unused bits
	-- add: 3 bit operation code (010), 4-bit input and destination register, 4-bit input register, 12 unused bits
	-- add: 3 bit operation code (011), 4-bit input and destination register, 4-bit input register, 12 unused bits
	-- ldpc: 3 bit operation code (100), 4-bit destination register, 16 unused bits
	-- branch: 3 bit operation code (101), 4-bit destination register, 16 unused bits
	-- Feel free to create your own assembly code
	
	-- ------------------ Add Your Internal Signals (if needed) ------------------
	-- You may not need anything, you can design your processor to only
	-- use clk_in, reset_in and (assembly) code signals.
	-- If you instatiate multiple modules, you may need them
	SIGNAL flag,done : STD_LOGIC;
	SIGNAL read_addr : STD_LOGIC_VECTOR(15 downto 0);
	
	-- ------------------ Add Your Internal Signals (if needed) ------------------
	
BEGIN
	instance0: my_little_processor PORT MAP(
		clock => clk_in,
		reset => reset_in,
		flag_out => flag,
		done_out => done,
		read_addr => read_addr,
		data_in => code(15 downto 0)
		);
	-- ------------------ Instantiate modules ------------------
	-- Instantiate your processor here
	-- ------------------ Instantiate modules ------------------
	
	
	-- Create a clk
	stim_proc: process 
	begin         
		wait for 50 ns;
		clk_in <= not(clk_in);
	end process;
	
	-- cnt is for the testbench only, use to set test values for every clock cycle
	stim_proc2: process(clk_in) 
	begin
		if rising_edge(clk_in) then
			cnt <= cnt+1;
		end if;
	end process;

	
	-- This is the 'program'. It loads 4 values into r0 to r3. 
	-- It then stores the current address location in r4
	-- It then branches to the 'sum' procedure, located at 50 in memory
	-- To do this, the value 50 is loaded into r5, then you branch to r5.
	-- After returning from branch, store the value in r6
	
	-- (IMPORTANT: you can use this testbench irrespective of the branching, 
	-- just do nothing for these commands)
	
	-- It then loads another 4 values into r0 to r3
	-- Performs the sum of these values and returns
	-- Finally it computes the xor of the two sums
	process (cnt)
	begin  
		case cnt is 
			-- Reset
			when 0 to 4		=> 	reset_in <= '1'; code <= ("000" & x"0" & x"0000");
			
			-- load 		r0 x"0001"
			when 5 to 9		=> 	reset_in <= '0'; code <= ("000" & x"0" & x"0001");
			--	load 		r1 x"0001"
			when 10 to 14	=> 	reset_in <= '0'; code <= ("000" & x"1" & x"0001");
			-- load 		r2 x"0020"
			when 15 to 19	=> 	reset_in <= '0'; code <= ("000" & x"2" & x"0020");
			--	load 		r3 x"0020"
			when 20 to 24	=> 	reset_in <= '0'; code <= ("000" & x"3" & x"0020");
			--	load 		r5 x"0050"
			when 25 to 29	=> 	reset_in <= '0'; code <= ("000" & x"5" & x"0050");
			--	ldpc 		r4 
			when 30 to 34	=> 	reset_in <= '0'; code <= ("100" & x"4" & x"0000");
			--	branch	r5
			when 35 to 39	=> 	reset_in <= '0'; code <= ("101" & x"5" & x"0000");
			
			-- add		r0	r1
			when 40 to 44	=> 	reset_in <= '0'; code <= ("010" & x"0" & x"1" & x"000");
			--	add		r0	r2
			when 45 to 49	=> 	reset_in <= '0'; code <= ("010" & x"0" & x"2" & x"000");
			-- add		r0	r3
			when 50 to 54	=> 	reset_in <= '0'; code <= ("010" & x"0" & x"3" & x"000");
			--	branch 	r4
			when 55 to 59	=> 	reset_in <= '0'; code <= ("101" & x"4" & x"0000");
			
			--	mov 		r6 r0
			when 60 to 64	=> 	reset_in <= '0'; code <= ("001" & x"6" & x"0" & x"000");
			
			-- load 		r0 x"0003"
			when 65 to 69	=> reset_in <= '0'; code <= ("000" & x"0" & x"0003");
			--	load 		r1 x"0004"
			when 70 to 74	=> 	reset_in <= '0'; code <= ("000" & x"1" & x"0004");
			-- load 		r2 x"001B"
			when 75 to 79	=> 	reset_in <= '0'; code <= ("000" & x"2" & x"001B");
			--	load 		r3 x"0034"
			when 80 to 84	=> 	reset_in <= '0'; code <= ("000" & x"3" & x"0050");
			--	ldpc 		r4 
			when 85 to 89	=> 	reset_in <= '0'; code <= ("100" & x"4" & x"0000");
			--	branch	r5
			when 90 to 94	=> 	reset_in <= '0'; code <= ("101" & x"5" & x"0000");			
			
			
			-- add		r0	r1
			when 95 to 99	=> 	reset_in <= '0'; code <= ("010" & x"0" & x"1" & x"000");
			--	add		r0	r2
			when 100 to 104	=> 	reset_in <= '0'; code <= ("010" & x"0" & x"2" & x"000");
			-- add		r0	r3
			when 105 to 109	=> 	reset_in <= '0'; code <= ("010" & x"0" & x"3" & x"000");
			--	branch 	r4
			when 110 to 114	=> 	reset_in <= '0'; code <= ("101" & x"4" & x"0000");
			
			--	xor 		r0 r6
			when 115 to 120	=> 	reset_in <= '0'; code <= ("001" & x"6" & x"0" & x"000");
			
			
			when others		=> 	reset_in <= '0'; code <= ("001" & x"6" & x"0" & x"000");
		end case;
	end process;	

  
END;
