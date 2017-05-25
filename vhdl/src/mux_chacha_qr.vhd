
--======================================================================
-- multiplexer for each element of quarter round
--======================================================================
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.my_data_types.all;

-------------------------------------------------

entity mux_chacha_qr is
port(	
	I0: 	in matrix_4;
	I1: 	in matrix_4;
	sel:	in std_logic;
	z:		out matrix_4);
end mux_chacha_qr;  

-------------------------------------------------

architecture behv1 of mux_chacha_qr is
begin
    process(I0,I1,sel)
    begin
    
        -- use case statement
        case sel is
	    when '0' =>	z <= I0;
	    when '1' =>	z <= I1;
	    when others =>	
			null;
	end case;

    end process;
end behv1;
--------------------------------------------------