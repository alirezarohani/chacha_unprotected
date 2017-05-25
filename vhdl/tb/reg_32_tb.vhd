--======================================================================
-- 32_bit est bench registers
--======================================================================
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------


entity reg_32_TB is			-- entity declaration
end reg_32_TB;

------------------------------------------------------------------

architecture TB of reg_32_TB is

    component reg_32
    port(	I:	in std_logic_vector(31 downto 0);
		clock:	in std_logic;
		load:	in std_logic;
		clear:	in std_logic;
		Q:	out std_logic_vector(31 downto 0)
		);
    end component;

    signal T_I:		std_logic_vector(31 downto 0);
    signal T_clock:	std_logic;
    signal T_load:	std_logic;
    signal T_clear:	std_logic;
    signal T_Q:		std_logic_vector(31 downto 0);
	
begin

    U_reg: reg_32 port map (T_I, T_clock, T_load, T_clear, T_Q);
	
    -- concurrent process to offer the clock signal
    process
    begin
 	T_clock <= '0';
 	wait for 5 ns;
	T_clock <= '1';
	wait for 5 ns;
    end process;
	
    process							
							 
	variable err_cnt: integer :=0;
	
    begin								
	
	T_I <= x"FF43F101";
	T_load <= '0';
	T_clear <= '1';
		
	-- case 1
	wait for 20 ns;
	T_load <= '1';
	wait for 10 ns;
	T_I <= x"F111F1B1";
	
	wait for 20 ns;
	T_load <= '1';
	T_I <= x"FF430001";
	wait for 10 ns;
			
		
		
    end process;

end TB;