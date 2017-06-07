LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;
USE ieee.numeric_std.ALL;

-- entity declaration for your testbench.Dont declare any ports here
ENTITY test_bench_2 IS
END test_bench_2;

ARCHITECTURE behavior OF test_bench_2 IS
	SIGNAL done : std_logic;
	SIGNAL read_addr : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL func : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL flag : std_logic;
	SIGNAL cnt : INTEGER := 0;
	SIGNAL clk_in, reset : STD_LOGIC := '1';
	SIGNAL LEDR : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL reg0_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL reg1_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL c_state : INTEGER;
	COMPONENT ram_16bit IS
		PORT (
			clock         : IN STD_LOGIC;
			done          : IN STD_LOGIC;
			data          : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			write_addr    : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			read_addr     : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			write_enable  : IN STD_LOGIC;
			q             : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT my_little_processor IS
		PORT (
			clock, reset                   : IN STD_LOGIC;
			data_in                        : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			flag_out, done_out             : OUT STD_LOGIC;
			c_state                        : OUT INTEGER;
			read_addr, reg0_out, reg1_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;

BEGIN
	ram : ram_16bit
	PORT MAP(
		clock         => clk_in, 
		done          => done, 
		data          => "0000000000000000", 
		write_addr    => "0000000000000000", 
		read_addr     => read_addr, 
		write_enable  => '0', 
		q             => func
	);
	processor : my_little_processor
	PORT MAP(
		clock      => clk_in, 
		reset      => reset, 
		data_in    => func, 
		flag_out   => flag, 
		done_out   => done, 
		read_addr  => read_addr, 
		reg0_out   => reg0_out, 
		reg1_out   => reg1_out, 
		c_state    => c_state
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
	PROCESS (cnt)
		BEGIN
			CASE cnt IS
				WHEN OTHERS => reset <= '0';
			END CASE;
		END PROCESS;
		stim_proc : PROCESS
		BEGIN
			WAIT FOR 50 ns;
			clk_in <= NOT(clk_in);
		END PROCESS;
 
		-- cnt is for the testbench only, use to set test values for every clock cycle
		stim_proc2 : PROCESS (clk_in)
		BEGIN
			IF rising_edge(clk_in) THEN
				cnt <= cnt + 1;
			END IF;
		END PROCESS;
END;