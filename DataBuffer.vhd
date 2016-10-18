library ieee;
use ieee.std_logic_1164.all;

ENTITY DataBuffer IS 
    PORT ( out_en     : IN std_logic; 
           --data_in    : IN data_word; 
			  data_in    : IN std_logic_vector(3 downto 0); 
           --data_out   : OUT data_bus); 
			  data_out   : OUT std_logic_vector(3 downto 0)); 
END ENTITY DataBuffer; 
ARCHITECTURE RTL OF DataBuffer IS 
BEGIN
	--if out_en = 1 then data_in -> data_out
	--else Z -> data_out
	data_out <= data_in when out_en = '1' else (others => 'Z');
END ARCHITECTURE ;