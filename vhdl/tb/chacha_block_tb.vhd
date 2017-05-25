--======================================================================
-- chacha_block_TB
--======================================================================
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_data_types.all;
--
entity chacha_block_TB is
end entity;

architecture tb of chacha_block_TB is

component chacha_block port(
		clk : in std_logic;
		reset_n : in std_logic;
		
		data_in_valid: std_logic;
		
		cons: in std_logic_vector(127 downto 0);
		key : in std_logic_vector(255 downto 0);
		ctr : in std_logic_vector(31 downto 0);
		nonce : in std_logic_vector(95 downto 0);

		data_out: out std_logic_vector(511 downto 0);
		data_out_valid: out std_logic);
end component chacha_block;

signal clk_T, reset_n_T, data_out_valid_T, data_in_valid_T: std_logic;
signal cons_t: std_logic_vector(127 downto 0);
signal key_T : std_logic_vector(255 downto 0);
signal ctr_T : std_logic_vector(31 downto 0);
signal nonce_T: std_logic_vector(95 downto 0);

Signal data_out_T: std_logic_vector(511 downto 0);

begin
	block1: chacha_block port map(clk_T, reset_n_T, data_in_valid_T, cons_t, key_T, ctr_T, nonce_T, data_out_T, data_out_valid_T);
	process
    begin
 	clk_T <= '0';
 	wait for 5 ns;
	clk_T <= '1';
	wait for 5 ns;
    end process;
	
	process	
	
	begin
        reset_n_T <='0';
        wait for 10 ns;
        reset_n_T <='1';
		wait for 10 ns;
		data_in_valid_T <= '1';
		cons_t <= x"617078653320646e79622d326b206574";
		key_T <= x"03020100070605040b0a09080f0e0d0c13121110171615141b1a19181f1e1d1c";
		ctr_T <= x"00000001";
		nonce_T<= x"090000004a00000000000000" ; 
		--key_T <= (others => '0');
		--ctr_T <= (others => '0');
		--nonce_T<= (others => '0'); 
		wait for 10 ns;
		data_in_valid_T <= '0';
		wait;	
    end process;
	
end architecture;
