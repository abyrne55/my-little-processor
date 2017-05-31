LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
USE ieee.numeric_std.ALL; 

-- entity declaration for your testbench.Dont declare any ports here
ENTITY test_bench_2 IS 
END test_bench_2;

ARCHITECTURE behavior OF test_bench_2 IS
	SIGNAL done : std_logic;
	SIGNAL read_addr : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL func : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL flag: std_logic;
	signal cnt: integer:= 0;
	signal clk_in, reset  : STD_LOGIC:= '1';
	SIGNAL LEDR: STD_LOGIC_VECTOR(17 downto 0);
	SIGNAL out1: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL out2: STD_LOGIC_VECTOR(15 DOWNTO 0);
	COMPONENT ram_16bit IS
		PORT (
			clock : IN STD_LOGIC;
			done : IN STD_LOGIC;
			data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			write_addr : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			read_addr : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			write_enable : IN STD_LOGIC;
			q : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT my_little_processor IS
		PORT (
			clock, reset : IN STD_LOGIC;
			data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			flag_out, done_out : OUT STD_LOGIC;
			read_addr, reg1_out, reg2_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
BEGIN
	ram : ram_16bit
	PORT MAP(
		clock => clk_in, 
		done => done, 
		data => "0000000000000000", 
		write_addr => "0000000000000000", 
		read_addr => read_addr, 
		write_enable => '0', 
		q => func
	);
	processor : my_little_processor
	PORT MAP(
		clock => clk_in, 
		reset => reset, 
		data_in => func, 
		flag_out => flag, 
		done_out => done, 
		read_addr => read_addr,
		reg1_out => out1,
		reg2_out => out2
	);
	PROCESS (flag)
	BEGIN
		IF flag = '1' THEN
			LEDR <= "111111111111111111";
		ELSE
			LEDR <= "000000000000000000";
		END IF;
	END PROCESS;
	-- Create a clk
	process (cnt)
	begin  
		case cnt is
			when others	=> 	reset <= '0'; 
		end case;
	end process;
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
END;
