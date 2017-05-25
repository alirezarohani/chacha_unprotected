--======================================================================
-- chacha block
--======================================================================
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.my_data_types.all;

entity chacha_block is 
	port(
		clk : in std_logic;
		reset_n : in std_logic;
		
		data_in_valid: std_logic;
		
		cons: in std_logic_vector(127 downto 0);
		key : in std_logic_vector(255 downto 0);
		ctr : in std_logic_vector(31 downto 0);
		nonce : in std_logic_vector(95 downto 0);
		
		data_out: out std_logic_vector(511 downto 0);
		data_out_valid: out std_logic);
		
end entity chacha_block;

--datapath
architecture rtl of chacha_block is
 
			component chacha_dp port(
				clk : in std_logic;
				reset_n : in std_logic;
		
				cons : in matrix_4;
				key : in matrix_8;
				ctr : in std_logic_vector(31 downto 0);
				nonce : in matrix_3;
		
				s_mux_status: in std_logic;
				s_mux_chacha: in std_logic;
				s_mux_store: in std_logic;
				s_mux_final: in std_logic;
		
				initial_reg_load: in std_logic;
				status_reg_load: in std_logic_vector(0 to 15);

				data_out: out matrix_16);
		
end component chacha_dp;

--controller
			component chacha_ctrl port(
					clk: in std_logic;
					reset_n : in std_logic;
					
					data_in_valid: std_logic;
					
					s_mux_status: out std_logic;
					s_mux_chacha: out std_logic;
					s_mux_store: out std_logic;
					s_mux_final: out std_logic;
					
					initial_reg_load: out std_logic;
					status_reg_load: out std_logic_vector(0 to 15);
									
					data_out_valid: out std_logic);
			end component chacha_ctrl;
			
	signal s_mux_status_c, s_mux_chacha_c, s_mux_store_c, initial_reg_load_c, s_mux_final_c : std_logic;  
	signal status_reg_load_c: std_logic_vector(0 to 15);
	signal key_m: matrix_8;
	signal nonce_m:matrix_3;
	signal cons_m:matrix_4;
	signal data_out_matrix:matrix_16;
	begin
	--cnos
	cons_matrix: for i in 3 downto 0 generate
		cons_m(i) <= cons((32*(i+1))-1 downto 32*i);
	end generate;
	
	
--key	
	key_matrix: for i in 7 downto 0 generate
		key_m(i) <= key((32*(i+1))-1 downto 32*i);
	end generate;
	
--nonce	
	nonce_matrix: for i in 2 downto 0 generate
		nonce_m(i) <= nonce((32*(i+1))-1 downto 32*i);
	end generate;
	
--data_out:
data_out_signal: for i in 15 downto 0 generate
		data_out((32*(i+1))-1 downto 32*i) <= data_out_matrix(15-i) ;
	end generate;	
	
	
		chacha_datapath: chacha_dp port map(clk, reset_n, cons_m, key_m, ctr, nonce_m, s_mux_status_c, s_mux_chacha_c, s_mux_store_c, s_mux_final_c, initial_reg_load_c,  status_reg_load_c, data_out_matrix);
		chacha_controller: chacha_ctrl port map(clk, reset_n, data_in_valid, s_mux_status_c, s_mux_chacha_c, s_mux_store_c, s_mux_final_c, initial_reg_load_c, status_reg_load_c, data_out_valid);
	end architecture rtl;
	