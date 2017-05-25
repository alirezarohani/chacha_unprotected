--======================================================================
-- chacha datapath
--======================================================================
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.my_data_types.all;

entity chacha_dp is 
	port(
		clk : in std_logic;
		reset_n : in std_logic;
		
		cons: in matrix_4;
		key : in matrix_8;
		ctr : in std_logic_vector(31 downto 0);
		nonce : in matrix_3;
		
		s_mux_status: in std_logic;
		s_mux_chacha: in std_logic;
		s_mux_store: in std_logic;
		s_mux_final:in std_logic;
		
		initial_reg_load: in std_logic;
		status_reg_load: in std_logic_vector(0 to 15);
	
		data_out: out matrix_16);
		
end entity chacha_dp;

architecture rtl of chacha_dp is

	--chacha quarterround
	component chacha_qr
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
	
	--multiplexers_to_select_qr
	component mux_chacha_qr 
		port(	
			I0: 	in matrix_4;
			I1: 	in matrix_4;
			sel:	in std_logic;
			z:		out matrix_4);
		end component mux_chacha_qr; 
		
	--multiplexers_to_select_from_status
	component mux_chacha_status 	
		port (	I0 : in matrix_16;
				I1 : in matrix_16;
				sel : in std_logic;
				z : out matrix_16);
		end component mux_chacha_status; 
		
	-- 32_bit registers
	component reg_32 
		port(	
			I:	in std_logic_vector(31 downto 0);
			clock:	in std_logic;
			load:	in std_logic;
			clear:	in std_logic;
			Q:	out std_logic_vector(31 downto 0));
	end component reg_32;
	
	--all intermediate signals
	signal initial_reg_in: matrix_16;
	signal initial_reg_out: matrix_16;
	
	signal status_reg_in: matrix_16;
	signal status_reg_out: matrix_16;
	
	
	signal output_mux_status: matrix_16;
	
	
	-- intermediate signals between mux and chachaqr
	signal tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8: matrix_4;
	signal mux_0_chacha_out, mux_1_chacha_out, mux_2_chacha_out, mux_3_chacha_out: matrix_4;
	
	--inputs to store mux
	signal tmp9, tmp10, t12, data_out_1 : matrix_16;
	
	--inputs to store registers
	signal output_mux_status_store : matrix_16;
	
	signal  QR_0_out, QR_1_out, QR_2_out, QR_3_out: matrix_4;   
	
	--constant cons1: std_logic_vector(31 downto 0) := x"61707865";
	--constant cons2: std_logic_vector(31 downto 0) := x"3320646e";
	--constant cons3: std_logic_vector(31 downto 0) := x"79622d32";
	--constant cons4: std_logic_vector(31 downto 0) := x"6b206574";
	
	begin	
	
	-- registers to hold initial and temporal status
	INIT_REG: for index_reg1 in 0 to 15 generate
			initial_reg: reg_32 port map (initial_reg_in(index_reg1), clk, initial_reg_load, reset_n, initial_reg_out(index_reg1));
	end generate INIT_REG;
	
	STATUS_REG: for index_reg2 in 0 to 15 generate
			status_reg: reg_32 port map (status_reg_in(index_reg2), clk, status_reg_load(index_reg2), reset_n, status_reg_out(index_reg2));
	end generate STATUS_REG;
	
		
	-- mux to select from initial or temporal status 
	MUX_STATUS: mux_chacha_status port map(initial_reg_out, status_reg_out, s_mux_status, output_mux_status);
	
	
	
	-- mux to select from different columns
	tmp1 <= (output_mux_status(0) , output_mux_status(4) , output_mux_status(8) , output_mux_status(12));
	tmp2 <= (output_mux_status(1) , output_mux_status(5) , output_mux_status(9) , output_mux_status(13));
	tmp3 <= (output_mux_status(2) , output_mux_status(6) , output_mux_status(10) , output_mux_status(14));
	tmp4 <= (output_mux_status(3) , output_mux_status(7) , output_mux_status(11) , output_mux_status(15));
	
	tmp5 <= (output_mux_status(0) , output_mux_status(5) , output_mux_status(10) , output_mux_status(15));
	tmp6 <= (output_mux_status(1) , output_mux_status(6) , output_mux_status(11) , output_mux_status(12));
	tmp7 <= (output_mux_status(2) , output_mux_status(7) , output_mux_status(8) , output_mux_status(13));
	tmp8 <= (output_mux_status(3) , output_mux_status(4) , output_mux_status(9) , output_mux_status(14));
	
	-----------------------------------
	
	-- these muxs select between different columns
	MUX_0: mux_chacha_qr port map(tmp1, tmp5, s_mux_chacha, mux_0_chacha_out);
	MUX_1: mux_chacha_qr port map(tmp2, tmp6, s_mux_chacha, mux_1_chacha_out);
	MUX_2: mux_chacha_qr port map(tmp3, tmp7, s_mux_chacha, mux_2_chacha_out);
	MUX_3: mux_chacha_qr port map(tmp4, tmp8, s_mux_chacha, mux_3_chacha_out);
	
	------
	
	QR0: chacha_qr port map(mux_0_chacha_out(0), mux_0_chacha_out(1), mux_0_chacha_out(2), mux_0_chacha_out(3), QR_0_out(0), QR_0_out(1), QR_0_out(2), QR_0_out(3));
	QR1: chacha_qr port map(mux_1_chacha_out(0), mux_1_chacha_out(1), mux_1_chacha_out(2), mux_1_chacha_out(3), QR_1_out(0), QR_1_out(1), QR_1_out(2), QR_1_out(3));
	QR2: chacha_qr port map(mux_2_chacha_out(0), mux_2_chacha_out(1), mux_2_chacha_out(2), mux_2_chacha_out(3), QR_2_out(0), QR_2_out(1), QR_2_out(2), QR_2_out(3));
	QR3: chacha_qr port map(mux_3_chacha_out(0), mux_3_chacha_out(1), mux_3_chacha_out(2), mux_3_chacha_out(3), QR_3_out(0), QR_3_out(1), QR_3_out(2), QR_3_out(3));
	
	------
	
	--Mux to load the quarterround data
	tmp9 <= (QR_0_out(0), QR_1_out(0) ,  QR_2_out(0) ,  QR_3_out(0) , QR_0_out(1) ,  QR_1_out(1) , QR_2_out(1) , QR_3_out(1) , QR_0_out(2) , QR_1_out(2) , QR_2_out(2) , QR_3_out(2) , QR_0_out(3) ,  QR_1_out(3) , QR_2_out(3) , QR_3_out(3)) ;
	tmp10 <= (QR_0_out(0) , QR_1_out(0) ,  QR_2_out(0) ,  QR_3_out(0) , QR_3_out(1) ,  QR_0_out(1) ,  QR_1_out(1) ,  QR_2_out(1) , QR_2_out(2) ,  QR_3_out(2) ,  QR_0_out(2) , QR_1_out(2) , QR_1_out(3) ,  QR_2_out(3) , QR_3_out(3) , QR_0_out(3)) ;

		
	MUX_STATUS_store: mux_chacha_status port map(tmp9, tmp10, s_mux_store, output_mux_status_store);
	
	-- mux to select between adder results or intermediate
	MUX_FINAL: mux_chacha_status port map(output_mux_status_store,data_out_1,s_mux_final,t12);
	
	--lame but works!
	status_reg_in(0) <= t12(0);
	status_reg_in(1) <= t12(1);
	status_reg_in(2) <= t12(2);
	status_reg_in(3) <= t12(3);
	status_reg_in(4) <= t12(4);
	status_reg_in(5) <= t12(5);
	status_reg_in(6) <= t12(6);
	status_reg_in(7) <= t12(7);
	status_reg_in(8) <= t12(8);
	status_reg_in(9) <= t12(9);
	status_reg_in(10) <= t12(10);
	status_reg_in(11) <= t12(11);
	status_reg_in(12) <= t12(12);
	status_reg_in(13) <= t12(13);
	status_reg_in(14) <= t12(14);
	status_reg_in(15) <= t12(15);
	
	
	--- connecting inputs to input registers 
	
	initial_reg_in(0) <= cons(3);
	initial_reg_in(1) <= cons(2);
	initial_reg_in(2) <= cons(1);
	initial_reg_in(3) <= cons(0);
	initial_reg_in(4) <= key(7);
	initial_reg_in(5) <= key(6);
	initial_reg_in(6) <= key(5);
	initial_reg_in(7) <= key(4);
	initial_reg_in(8) <= key(3);
	initial_reg_in(9) <= key(2);
	initial_reg_in(10) <= key(1);
	initial_reg_in(11) <= key(0);
	initial_reg_in(12) <= ctr;
	initial_reg_in(13) <= nonce(2);
	initial_reg_in(14) <= nonce(1);
	initial_reg_in(15) <= nonce(0);
	
	
	data_out_1(0) <= std_logic_vector(unsigned(status_reg_out(0)));-- + unsigned(initial_reg_out(0)));
	data_out_1(1) <= std_logic_vector(unsigned(status_reg_out(1)));-- + unsigned(initial_reg_out(1)));
	data_out_1(2) <= std_logic_vector(unsigned(status_reg_out(2)));-- + unsigned(initial_reg_out(2)));
	data_out_1(3) <= std_logic_vector(unsigned(status_reg_out(3)));-- + unsigned(initial_reg_out(3)));
	data_out_1(4) <= std_logic_vector(unsigned(status_reg_out(4)));-- + unsigned(initial_reg_out(4)));
	data_out_1(5) <= std_logic_vector(unsigned(status_reg_out(5)));-- + unsigned(initial_reg_out(5)));
	data_out_1(6) <= std_logic_vector(unsigned(status_reg_out(6)));-- + unsigned(initial_reg_out(6)));
	data_out_1(7) <= std_logic_vector(unsigned(status_reg_out(7)));-- + unsigned(initial_reg_out(7)));
	data_out_1(8) <= std_logic_vector(unsigned(status_reg_out(8)));-- + unsigned(initial_reg_out(8)));
	data_out_1(9) <= std_logic_vector(unsigned(status_reg_out(9)));-- + unsigned(initial_reg_out(9)));
	data_out_1(10) <= std_logic_vector(unsigned(status_reg_out(10)));-- + unsigned(initial_reg_out(10)));
	data_out_1(11) <= std_logic_vector(unsigned(status_reg_out(11)) + unsigned(initial_reg_out(11)));
	data_out_1(12) <= std_logic_vector(unsigned(status_reg_out(12)));-- + unsigned(initial_reg_out(12)));
	data_out_1(13) <= std_logic_vector(unsigned(status_reg_out(13)));-- + unsigned(initial_reg_out(13)));
	data_out_1(14) <= std_logic_vector(unsigned(status_reg_out(14)));-- + unsigned(initial_reg_out(14)));
	data_out_1(15) <= std_logic_vector(unsigned(status_reg_out(15)));-- + unsigned(initial_reg_out(15)));
	
	data_out(0) <= status_reg_out(0);
	data_out(1) <= status_reg_out(1);
	data_out(2) <= status_reg_out(2);
	data_out(3) <= status_reg_out(3);
	data_out(4) <= status_reg_out(4);
	data_out(5) <= status_reg_out(5);
	data_out(6) <= status_reg_out(6);
	data_out(7) <= status_reg_out(7);
	data_out(8) <= status_reg_out(8);
	data_out(9) <= status_reg_out(9);
	data_out(10) <= status_reg_out(10);
	data_out(11) <= status_reg_out(11);
	data_out(12) <= status_reg_out(12);
	data_out(13) <= status_reg_out(13);
	data_out(14) <= status_reg_out(14);
	data_out(15) <= status_reg_out(15);
	
end architecture rtl;

	
		

	
		

	
		
		
		