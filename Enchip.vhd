library ieee;
use ieee.std_logic_1164.all;
use work.cpu_package.all;

entity Enchip is 
    port(clk     : in std_logic; 
         reset   : in std_logic;  -- active high 
         stop    : in std_logic;  -- stops statemachine   
         choice  : in std_logic;  -- address(0) or data(1)
         s       : out std_logic_vector (3 DOWNTO 0)); -- output  
end entity Enchip; 
architecture Structure of Enchip is 
component CPU is 
    PORT(  adr        : OUT address_bus; 
           data       : IN instruction_bus; 
           stop       : IN std_logic;       -- stops statemachine 
           RWM_data   : INOUT data_bus; 
           rw_RWM     : OUT std_logic;      -- read on high 
           ROM_en     : OUT std_logic;      -- active low 
           RWM_en     : OUT std_logic;      -- active low 
           clk        : IN std_logic; 
           reset      : IN std_logic);      -- active high 
END component CPU; 
--component RW_MEMORY IS 
----    PORT(  adr        : IN addressbus; 
----           data       : INOUT data_bus; 
--    PORT(  adr        : IN std_logic_vector(3 downto 0); 
--           data       : INOUT std_logic_vector(3 downto 0); 
--           clk        : IN std_logic; 
--           ce         : IN std_logic;             -- active low 
--           rw         : IN std_logic);            -- read on high 
--END component RW_MEMORY;
component RW_MEMORY IS 
--    PORT(  adr        : IN addressbus; 
--           data       : INOUT data_bus; 
    PORT(  adr        : IN std_logic_vector(3 downto 0); 
           data       : INOUT std_logic_vector(3 downto 0); 
           clk        : IN std_logic; 
           ce         : IN std_logic;             -- active low 
           rw         : IN std_logic);            -- read on high 
end component rw_memory;
component ROM IS 
    --PORT ( adr        : IN addressbus; 
    --      data       : OUT instruction_bus; 
    PORT ( adr        : IN std_logic_vector(3 downto 0); 
          data       : OUT std_logic_vector(9 downto 0); 
           ce         : IN std_logic);            -- active low 
END component ROM;
	signal signal_adr : address_bus;
	signal signal_rom_data : instruction_bus;
	signal signal_rwm_data : data_bus;
	signal signal_rom_en : std_logic;
	signal signal_rwm_en : std_logic;
	signal signal_rw_rwm_en : std_logic;
	
begin
--	CPU1: CPU port map ( adr => signal_adr, data => signal_rom_data, stop => stop, clk => clk, reset => reset, rwm_data => signal_rwm_data,
--								rw_rwm => signal_rw_rwm_en, rom_en => signal_rom_en, rwm_en => signal_rwm_en);
	CPU1: CPU port map ( adr => signal_adr, data => signal_rom_data, stop => stop, clk => clk, reset => reset, rwm_data => signal_rwm_data,
								rw_rwm => signal_rw_rwm_en, rom_en => signal_rom_en, rwm_en => signal_rwm_en
								);

	ROM1: ROM port map ( adr => signal_adr, data => signal_rom_data, ce => signal_rom_en);
	--first four bits on databuss is shared with Rom.
	RW1: RW_MEMORY port map (adr => signal_adr, data => signal_rwm_data, clk => clk, ce => signal_rwm_en, rw => signal_rw_rwm_en
									);

	s <= signal_adr when choice = '0' else signal_rom_data(9 downto 6);
end architecture;