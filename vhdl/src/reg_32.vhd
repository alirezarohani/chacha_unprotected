--======================================================================
-- 32_bit registers
--======================================================================
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------
entity reg_32 is

port(	I:	in std_logic_vector(31 downto 0);
		clock:	in std_logic;
		load:	in std_logic;
		clear:	in std_logic;
		Q:	out std_logic_vector(31 downto 0)
);
end reg_32;

----------------------------------------------------

architecture behv of reg_32 is

    signal Q_tmp: std_logic_vector(31 downto 0);

begin

    process(I, clock, load, clear)
    begin

	if clear = '0' then
            -- use 'range in signal assigment 
            Q_tmp <= (Q_tmp'range => '0');
	elsif (clock='1' and clock'event) then
	    if load = '1' then
		Q_tmp <= I;
	    end if;
	end if;

    end process;

    -- concurrent statement
    Q <= Q_tmp;

end behv;