---------------------------------------------------------------
-- Test Bench for Multiplexer (ESD figure 2.5)
-- by Weijun Zhang, 04/2001
--
-- four operations are tested in this example.
---------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.my_data_types.all;

entity mux_chacha_qr_tb is			-- empty entity
end mux_chacha_qr_tb;

---------------------------------------------------------------

architecture TB of mux_chacha_qr_tb is

    -- initialize the declared signals  
    signal T_I1: matrix_4:= (x"124532a3", x"12345678", x"01201895", x"42015830");
    signal T_I0: matrix_4:= (x"20365801", x"a1254abc", x"0212150a", x"01aa12ef");
    signal T_O: matrix_4;
    signal T_S: std_logic;
	
    component mux_chacha_qr
    port(	
	I0: 	in matrix_4;
	I1: 	in matrix_4;
	sel:	in std_logic;
	z:		out matrix_4);
    end component;

begin

    U_Mux: mux_chacha_qr port map (T_I0, T_I1, T_S, T_O);
	
    process							
	
    begin								
		
	-- case select eqaul "00"
	wait for 10 ns;	
	T_S <= '0';	
		
	-- case select equal "01"
	wait for 10 ns;
	T_S <= '1';	  
	
	wait for 10 ns;
	T_S <= '0';	
	wait; 
		
end process;

end TB;

----------------------------------------------------------------
