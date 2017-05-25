--======================================================================
-- chacha_qr.v
--======================================================================
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity chacha_qr_tb is 
end chacha_qr_tb;

architecture tb of chacha_qr_tb is

component chacha_qr is 
	port(
		a: in std_logic_vector(31 downto 0);
		b: in std_logic_vector(31 downto 0);
		c: in std_logic_vector(31 downto 0);
		d: in std_logic_vector(31 downto 0);
		a_prim: out std_logic_vector(31 downto 0);
		b_prim: out std_logic_vector(31 downto 0);
		c_prim: out std_logic_vector(31 downto 0);
		d_prim: out std_logic_vector(31 downto 0));
end component chacha_qr;

signal a_input, b_input, c_input, d_input : std_logic_vector(31 downto 0);
signal a_prim_output, b_prim_output, c_prim_output, d_prim_output: std_logic_vector(31 downto 0);
begin
	CUT: chacha_qr port map(a_input, b_input, c_input, d_input, a_prim_output, b_prim_output, c_prim_output, d_prim_output);
	
	process	
		variable err_cnt: integer := 0;
		
	begin
		--test case 1
		a_input <= 	x"11111111";
		b_input <= 	x"01020304";
		c_input <= 	x"9b8d6f43";
		d_input <= 	x"01234567";
		wait for 10 ns;
		if (a_prim_output = x"ea2a92f4") and (b_prim_output = x"cb1cf8ce") and (c_prim_output = x"4581472e") and (d_prim_output = x"5881c4bb") then
			err_cnt := 0;
		else	
			err_cnt := 1;
		end if;

		if (err_cnt=0) then
			assert false report "Testbench completed successfully!" severity note;
		else
			assert true report "oops!" severity note;
		end if;	
		wait;
		
	end process;
end tb;
	
				
			
		

