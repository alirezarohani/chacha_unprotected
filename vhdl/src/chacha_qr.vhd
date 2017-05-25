--======================================================================
-- chacha_qr.vhd
--======================================================================
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity chacha_qr is 
	port(
		a: in std_logic_vector(31 downto 0);
		b: in std_logic_vector(31 downto 0);
		c: in std_logic_vector(31 downto 0);
		d: in std_logic_vector(31 downto 0);
		a_prim: out std_logic_vector(31 downto 0);
		b_prim: out std_logic_vector(31 downto 0);
		c_prim: out std_logic_vector(31 downto 0);
		d_prim: out std_logic_vector(31 downto 0));
end entity chacha_qr;

architecture behavioral of chacha_qr is 

begin
	
	
	
	
	chacha_qr_process: process(a,b,c,d) is	
		variable a0, a1: unsigned(31 downto 0);
		variable b0, b1, b2, b3: unsigned(31 downto 0);
		variable c0, c1: unsigned(31 downto 0);
		variable d0, d1, d2, d3: unsigned(31 downto 0);
	begin
	
		a0 := unsigned(a) + unsigned(b);
		d0 := unsigned(d xor std_logic_vector(a0));
		d1 := d0(15 downto 0) & d0(31 downto 16);
		c0 := unsigned(c) + d1;
		b0 := unsigned(b xor std_logic_vector(c0));
		b1 := b0(19 downto 0) & b0(31 downto 20);
		a1 := a0 + b1;
		d2 := d1 xor a1;
		d3 := d2(23 downto 0) & d2(31 downto 24);
		c1 := c0 + d3;
		b2 := unsigned(std_logic_vector(b1) xor std_logic_vector(c1));
		b3 := b2(24 downto 0) & b2(31 downto 25);
		
		a_prim <= std_logic_vector(a1);
		b_prim <= std_logic_vector(b3);
		c_prim <= std_logic_vector(c1);
		d_prim <= std_logic_vector(d3);

		
	end process chacha_qr_process;
	
	
end architecture behavioral;		
		
		

		