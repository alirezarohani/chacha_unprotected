library IEEE;
use IEEE.STD_LOGIC_1164.all;
package my_data_types is            
     type matrix_16 is array (0 to 15) of std_logic_vector (31 downto 0);
	 type matrix_8 is array (0 to 7) of std_logic_vector (31 downto 0);
	 type matrix_4 is array (0 to 3) of std_logic_vector (31 downto 0);
	 type matrix_3 is array (0 to 2) of std_logic_vector (31 downto 0);
end my_data_types;