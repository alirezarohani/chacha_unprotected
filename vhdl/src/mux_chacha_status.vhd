--======================================================================
-- multiplexer for each element of quarter round
--======================================================================
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.my_data_types.all;

-------------------------------------------------
entity mux_chacha_status is 
	port (	I0 : in matrix_16;
			I1 : in matrix_16;
			sel : in std_logic;
			z	: out matrix_16);
end mux_chacha_status;  

-------------------------------------------------

architecture behv1 of mux_chacha_status is
begin

    process(I0, I1, sel)
    begin
    
        -- use case statement
        case sel is
	    when '0' =>		
			z <= I0;
	    when '1' =>	
			z <= I1;
	    when others =>	
			null;
		
	end case;

    end process;
end behv1;
--------------------------------------------------