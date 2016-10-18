library ieee;
use ieee.std_logic_1164.all;

ENTITY RegisterFile IS 
PORT(      clk           : IN std_logic; 
           data_in       : IN std_logic_vector(3 downto 0); 
           data_out_1    : OUT std_logic_vector(3 downto 0);
           data_out_0    : OUT std_logic_vector(3 downto 0); 
           sel_in        : IN std_logic_vector (1 downto 0); 
           sel_out_1     : IN std_logic_vector (1 downto 0); 
           sel_out_0     : IN std_logic_vector (1 downto 0);          
           rw_reg        : in std_logic); 
END ENTITY RegisterFile; 
ARCHITECTURE RTL OF RegisterFile IS 
BEGIN
	process(clk)
	variable R0 : std_logic_vector(3 downto 0) := "0000";--ska vara dataword...
	variable R1 : std_logic_vector(3 downto 0) := "0000";--ska vara dataword...
	variable R2 : std_logic_vector(3 downto 0) := "0000";--ska vara dataword...
	variable R3 : std_logic_vector(3 downto 0) := "0000";--ska vara dataword...
	variable bogus : std_logic;
	begin
		if(rising_edge(clk)) then
			if(rw_reg = '0') then
			--write mode
			--the DATA_IN -> what ever SEL_IN has chosen.
				case sel_in is
					when "00" => R0 := data_in;
					when "01" => R1 := data_in;
					when "10" => R2 := data_in;
					when "11" => R3 := data_in;
					when others => bogus := 'Z' ;
					
				end case;
			else
			--read mode
			--can read two registers
			--SEL_OUT_0 -> DATA_OUT_0
			--SEL_OUT_1 -> DATA_OUT_1
				case sel_out_0 is
					when "00" => data_out_0 <= R0;
					when "01" => data_out_0 <= R1;
					when "10" => data_out_0 <= R2;
					when "11" => data_out_0 <= R3;
					when others => data_out_0 <= (others=>'Z');
			end case;
				case sel_out_1 is
					when "00" => data_out_1 <= R0;
					when "01" => data_out_1 <= R1;
					when "10" => data_out_1 <= R2;
					when "11" => data_out_1 <= R3;
					when others => data_out_1 <= (others=>'Z');
				end case;
			end if;
		end if;
	end process;

END ARCHITECTURE ;