---imports
library ieee;
use ieee.std_logic_1164.all;

package CPU_Package is
	--header functions
	Function add_overflow(a,b: std_logic_vector) return std_logic_vector;
	Function sub_overflow(a,b: std_logic_vector) return std_logic_vector;
	--define constants
	constant address_size			: integer := 4;
	constant data_size 				: integer := 4;
	constant operation_size 		: integer := 4;
	constant instruction_size 		: integer := 10;
	--create datatypes
	subtype data_word is std_logic_vector(data_size-1 downto 0);
	subtype address_bus is std_logic_vector((address_size-1) DOWNTO 0);
	subtype data_bus is std_logic_vector((data_size-1) DOWNTO 0);
	subtype instruction_bus is std_logic_vector((instruction_size-1) DOWNTO 0);
	subtype program_word is std_logic_vector((instruction_size-1) DOWNTO 0);
	subtype command_word is std_logic_vector((operation_size-1) DOWNTO 0);
	
	end;

package body CPU_Package is
	--create functions
	Function add_overflow(a,b: std_logic_vector)
		return std_logic_vector is
		variable result : std_logic_vector(a'length downto 0) ; --result vector is n+1
		--variable carry  : std_logic; --carry to see if the operation created a carry
		variable concat : std_logic_vector(2 downto 0);
		begin
			--set result to 0's
			result := (others => '0');
			--loop through all bits
			for i in 0 to (a'length-1) loop
				--concatenate 
				concat := result(i) & a(i) & b(i);
				--carry  := '0'; --reset carry in every time
				--concat := a(i) & b(i);
				if(concat = "001" or concat = "010" or concat = "100") then
					--if one bit is set result is set
					result(i) := '1';
				elsif(concat = "011" or concat = "110" or concat = "101") then
					--if two bits are set, result is 0 and result+1 is 1 
					result(i) := '0';
					result(i+1) := '1';
				elsif(concat = "000") then
					--if all zeroes result is 0
					result(i) := '0';
				elsif(concat = "111") then
					--if all is 1's, result and result +1 is 1.
					result(i)   := '1';
					result(i+1) := '1';
				else
					result(i)   := 'X';
				end if;
			end loop;
			--check if both a and b is either negative or positive
			--if((a(a'length-1) AND b(b'length-1) ) = result(a'length-1) ) then
				--check if the result has changed sign, this will be an overflow
			--	result(result'length-1) := '1';
			--end if;
			--overflow magic:
			result(result'length-1) := (a(a'length-1) AND b(b'length-1) AND not(result(result'length-2)))
											OR (not(a(a'length-1)) AND not(b(b'length-1)) AND result(result'length-2));
			
			return result;
	end add_overflow;
	Function sub_overflow(a,b: std_logic_vector)
		return std_logic_vector is
		variable b_comp  : std_logic_vector(b'length downto 0) ; --result vector is n
		variable new_b   : std_logic_vector((b'length-1) downto 0) ; --result vector is n-1
		variable add_one : std_logic_vector((b'length-1) downto 0) ; --result vector is n-1
		variable result  : std_logic_vector((b'length) downto 0) ; --result vector is n+2
		begin
			b_comp := (others => '0');
			add_one := (others => '0');
			add_one(0) := '1';
			
			--invert b, 0 -> 1 and 1 -> 0
			--for i in 0 to (b'length-1) loop
			new_b := not(b);
			--end loop;
			--create two bit complement on b
			b_comp := add_overflow(new_b, add_one);
			--add 
			result := add_overflow(a, b_comp((b'length-1) downto 0));

			return result;
	end sub_overflow;
end package body;

