--======================================================================
-- chacha conroller
--======================================================================
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.my_data_types.all;

entity chacha_ctrl is 
	port(
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
end entity chacha_ctrl;

architecture fsm of chacha_ctrl is

	type state_type is (initial, load, qr_c, qr_d, semi_final, final, final_real);
	signal next_state, current_state: state_type;
	signal count, next_count: INTEGER RANGE 0 to 20;
	begin	
	
		state_reg: process(clk, reset_n)
		begin	
			if (reset_n = '0') then	
					current_state <= initial;
			elsif (clk'event and clk='1') then
				current_state <= next_state;
			end if;
		end process;
		
		add_count: process(clk, reset_n)
		begin	
			if (reset_n = '0') then	
					count <= 0;
			elsif (clk'event and clk='1') then
				count <= next_count;
			end if;
		end process;

		comb_logic: process(current_state,data_in_valid, count)
		--variable count: INTEGER RANGE 0 to 20 := 0;
		begin
		data_out_valid <= '0';
		s_mux_chacha <= '0';
		s_mux_status <= '0';
		status_reg_load <= "0000000000000000";
		initial_reg_load <= '0';
		s_mux_store <= '0';
		s_mux_final <= '0';
		--next_state <= initial;
		case current_state is
			when initial =>
				next_count <= 0;
				if data_in_valid = '1' then
					next_state <= load;
				else
					next_state <= initial;
				end if;	
			when load =>
				 initial_reg_load <= '1';
				 --data_out_valid <= '0';
				 next_count <= 0 ;
				 next_state <= qr_c;
			when qr_c =>
				if count = 0 then 
					s_mux_status <= '0';
				else
					s_mux_status <= '1';
				end if;	
				status_reg_load <= "1111111111111111";
				--data_out_valid <= '0';
				next_state <= qr_d;
				next_count <= count;
			when qr_d =>
				s_mux_status <= '1';
				s_mux_chacha <= '1';
				s_mux_store <= '1';
				status_reg_load <= "1111111111111111";
				--data_out_valid <= '0';
				next_count <= count + 1;
				if (count+1 < 10 ) then
					next_state <= qr_c;
				elsif (count+1 >= 10) then
					next_state <= semi_final;
				end if;	
			when semi_final =>
				s_mux_final <= '1';
				status_reg_load <= "0000000000010000";
				next_state <= final;
				next_count <= count;
			when final =>
				next_state <= final_real;
				next_count <= count;
			when final_real =>
				data_out_valid <= '1';
				next_state <= initial;
				next_count <= 0;
			when others =>
				next_state <= initial;
				next_count <= 0;
		end case;
	end process;
end architecture fsm;	
				
				
				
				 
				
			
		
		
	