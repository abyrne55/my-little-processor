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
	SIGNAL reg0_out: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL reg1_out: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL main_bus_out, ALU_preout, G_preout, A_preout: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL c_state_preout: INTEGER;
	SIGNAL instr_preout: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7 : STD_LOGIC_VECTOR(6 downto 0);
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
			c_state_preout : OUT INTEGER;
			instr_preout : OUT STD_LOGIC_VECTOR(3 downto 0);
			read_addr, reg0_out, reg1_out,main_bus_out, ALU_preout, G_preout, A_preout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT binaryto4hex IS
		PORT ( 
			binary : IN STD_LOGIC_VECTOR(15 downto 0);
			output0, output1, output2, output3 : OUT STD_LOGIC_VECTOR(6 downto 0)
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
		reg0_out => reg0_out,
		reg1_out => reg1_out,
		main_bus_out => main_bus_out,
		ALU_preout => ALU_preout,
		G_preout => G_preout,
		A_preout => A_preout,
		c_state_preout => c_state_preout,
		instr_preout => instr_preout
	);
		bintohex0 : binaryto4hex
	PORT MAP (
			binary => reg0_out,
			output0 => HEX0,
			output1 => HEX1,
			output2 => HEX2,
			output3 => HEX3
		);
	bintohex1 : binaryto4hex
	PORT MAP (
			binary => reg1_out,
			output0 => HEX4,
			output1 => HEX5,
			output2 => HEX6,
			output3 => HEX7
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
