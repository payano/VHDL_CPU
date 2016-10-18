library ieee;
use ieee.std_logic_1164.all;

Entity Multiplexer is 
   Port( 
      Sel         : IN std_logic_vector(1 downto 0); 
--      Data_in_2   : IN data_word; 
--      Data_in_1   : IN data_bus; -- Potential type problem... 
--      Data_in_0   : IN data_word; 
--      Data_out    : OUT data_word); 
      Data_in_2   : IN std_logic_vector(3 downto 0);
      Data_in_1   : IN std_logic_vector(3 downto 0);
      Data_in_0   : IN std_logic_vector(3 downto 0);
      Data_out    : OUT std_logic_vector(3 downto 0)); 
End Entity Multiplexer; 
Architecture RTL of Multiplexer is 
BEGIN
	Data_out <= Data_in_0 when Sel = "00" else
					Data_in_1 when Sel = "01" else
					Data_in_2 when Sel = "10" else
					(others=>'Z');
					--else Data_in_3 when Sel = "11";
END Architecture;