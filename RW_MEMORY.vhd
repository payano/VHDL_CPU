library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL; --for conv_integer


ENTITY RW_MEMORY IS 
--    PORT(  adr        : IN addressbus; 
--           data       : INOUT data_bus; 
    PORT(  adr        : IN std_logic_vector(3 downto 0); 
           data       : INOUT std_logic_vector(3 downto 0); 
           clk        : IN std_logic; 
           ce         : IN std_logic;             -- active low 
           rw         : IN std_logic);            -- read on high 
END ENTITY RW_MEMORY; 
ARCHITECTURE Behaviour OF RW_MEMORY IS 
	type memory is array (0 to 15) of std_logic_vector(3 downto 0);
	signal tmpMem : memory;
	signal q_int : std_logic_vector(3 downto 0);
	--variable q_int : std_logic_vector(3 downto 0);
	
	BEGIN

	PROCESS(clk,data)
	BEGIN
	if(rising_edge(clk)) then

			if(ce = '0') then
			--if ce is 0, it means that memory is enabled.
				if(rw = '0') then
					--write mode
					tmpMem(conv_integer(adr)) <= data;
				else
					--read mode
					--q_int <= "0000";
					--data <= "0101";
					q_int <= tmpMem(conv_integer(adr));
				end if;
			--else
				--if ce is 1, it means that memory is disabled, output Z.
				--data <= (others => 'Z');
			end if;
		end if;
	END PROCESS;
	data <= q_int when (ce='0') and rw = '1' else (others=>'Z');
END ARCHITECTURE ;
