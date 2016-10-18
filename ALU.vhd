-------------------------------------------------------------------------
-- Projectname : DD_lab2
-- Filename    : KTH_alu.vhd       
-- Title       : entity alu(testbench)
-- Author      : Claes Jennel   
-- Description : Model of ALU(RTL) with 3 errors
-------------------------------------------------------------------------
-- Revisions : 
--   Date     Author      Revision      Comments
--   980510  Claes Jennel      A         Initial Version
--   980911  Claes Jennel      B         Updated Version
--   000828  Claes Jennel      C         Updated Version
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cpu_package.all;

entity ALU is
	port(	
			op : in std_logic_vector (2 downto 0);
			--op : in unsigned (2 downto 0); --vad unsigned????
			a	: in data_word;
			b	: in data_word;
			en	: in std_logic;
 			clk	: in std_logic;
			y	: out data_word;
			n_flag 	: out std_logic;
			z_flag 	: out std_logic;
			o_flag 	: out std_logic);
end entity ALU;

architecture RTL of ALU is
	
	signal y_temp : data_word := "0000";
	signal o_temp : std_logic;
	
	constant y_zero : data_word := (others => '0');
	-- ALU-operationcodes
--	constant add_op : unsigned(2 downto 0) := "000";
--	constant sub_op : unsigned(2 downto 0) := "001";
--	constant and_op : unsigned(2 downto 0) := "010";
--	constant xor_op : unsigned(2 downto 0) := "011";
--	constant  or_op : unsigned(2 downto 0) := "100";
--	constant not_op : unsigned(2 downto 0) := "101";
--	constant mov_op : unsigned(2 downto 0) := "110";
	constant add_op : std_logic_vector(2 downto 0) := "000";
	constant sub_op : std_logic_vector(2 downto 0) := "001";
	constant and_op : std_logic_vector(2 downto 0) := "010";
	constant xor_op : std_logic_vector(2 downto 0) := "011";
	constant  or_op : std_logic_vector(2 downto 0) := "100";
	constant not_op : std_logic_vector(2 downto 0) := "101";
	constant mov_op : std_logic_vector(2 downto 0) := "110";
		
begin
	y_data_o_flag: process(op, a, b ,en)
	
	--variable temp  : signed(data_size downto 0); --vad signed...
	variable temp  : std_logic_vector(data_size downto 0);

	begin
		--y_temp <= (others => '0'); -- default value
		o_temp <= '0'; -- default value
			if (en ='1') then
				case op is
					when add_op =>			
						temp := add_overflow(a,b);
						y_temp <= temp(data_size -1 downto 0);
						--before:
						o_temp <= temp(data_size);
						

					when sub_op =>			
						temp := sub_overflow(a,b);
						--temp := "00000";
						y_temp <= temp(data_size -1 downto 0);
						--o_temp <= temp(data_size-1);
						o_temp <= temp(data_size);

					when and_op =>			
						y_temp <= a and b;

					when or_op =>			
						y_temp <= a or b;
			
					when xor_op =>			
						y_temp <= a xor b;
			
					when not_op =>			
						y_temp <= not a;
						
					when mov_op =>		
						y_temp <= a;

					when others => null;
				end case;
			end if;	
	end process y_data_o_flag;


    outputs: process (clk, y_temp, o_temp)
	begin
		--if(clk='1') then
		if rising_edge(clk) then
				o_flag <= o_temp;		
				y <= y_temp;
    			n_flag <= y_temp(y_temp'left);
    			if (y_temp = y_zero) then
    				z_flag <= '1';
    			else
    				z_flag <= '0';
    			end if;
			end if;
   end process outputs;

end architecture RTL;

	

