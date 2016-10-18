library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY ROM IS 
    --PORT ( adr        : IN addressbus; 
    --      data       : OUT instruction_bus; 
    PORT ( adr        : IN std_logic_vector(3 downto 0); 
          data       : OUT std_logic_vector(9 downto 0); 
           ce         : IN std_logic);            -- active low 
END ENTITY ROM; 
ARCHITECTURE RTL OF ROM IS 
	--MAKING NEW SHIT
	constant ADD_OP  : std_logic_vector(3 downto 0) := "0000";
	constant SUB_OP  : std_logic_vector(3 downto 0) := "0001";
	constant AND_OP  : std_logic_vector(3 downto 0) := "0010";
	constant OR_OP   : std_logic_vector(3 downto 0) := "0011";
	constant XOR_OP  : std_logic_vector(3 downto 0) := "0100";
	constant NOT_OP  : std_logic_vector(3 downto 0) := "0101";
	constant MOV_OP  : std_logic_vector(3 downto 0) := "0110";
	constant LDR_OP  : std_logic_vector(3 downto 0) := "1000";
	constant STR_OP  : std_logic_vector(3 downto 0) := "1001";
	constant LDI_OP  : std_logic_vector(3 downto 0) := "1010";
	constant NOP_OP  : std_logic_vector(9 downto 0) := "1011000000";
	constant BRZ_OP  : std_logic_vector(5 downto 0) := "110000";
	constant BRN_OP  : std_logic_vector(5 downto 0) := "110100";
	constant BRO_OP  : std_logic_vector(5 downto 0) := "111000";
	constant BRA_OP  : std_logic_vector(5 downto 0) := "111100";
	
	constant R0_address : std_logic_vector(1 downto 0) := "00";
	constant R1_address : std_logic_vector(1 downto 0) := "01";
	constant R2_address : std_logic_vector(1 downto 0) := "10";
	constant R3_address : std_logic_vector(1 downto 0) := "11";
	
	constant no0  : std_logic_vector(3 downto 0) := "0000";
	constant no1  : std_logic_vector(3 downto 0) := "0001";
	constant no2  : std_logic_vector(3 downto 0) := "0010";
	constant no3  : std_logic_vector(3 downto 0) := "0011";
	constant no4  : std_logic_vector(3 downto 0) := "0100";
	constant no5  : std_logic_vector(3 downto 0) := "0101";
	constant no6  : std_logic_vector(3 downto 0) := "0110";
	constant no7  : std_logic_vector(3 downto 0) := "0111";
	constant no8  : std_logic_vector(3 downto 0) := "1000";
	constant no9  : std_logic_vector(3 downto 0) := "1001";
	constant no10 : std_logic_vector(3 downto 0) := "1010";
	constant no11 : std_logic_vector(3 downto 0) := "1011";
	constant no12 : std_logic_vector(3 downto 0) := "1100";
	constant no13 : std_logic_vector(3 downto 0) := "1101";
	constant no14 : std_logic_vector(3 downto 0) := "1110";
	constant no15 : std_logic_vector(3 downto 0) := "1111";
	
	subtype rom_word is std_logic_vector(9 downto 0);
	type rom_table is array(0 to 15) of rom_word;
	
	constant rom: rom_table := rom_table'(
											LDI_OP & R3_ADDRESS & no3,
											STR_OP & R3_ADDRESS & no14,
											LDI_OP & R1_ADDRESS & no1,
											LDR_OP & R0_ADDRESS & no14,
											MOV_OP & R0_ADDRESS & "00" & R2_ADDRESS,
											ADD_OP & R2_ADDRESS & R1_ADDRESS & R2_ADDRESS,
											SUB_OP & R0_ADDRESS & R1_ADDRESS & R0_ADDRESS,
											BRZ_OP & no12,
											NOP_OP,
											BRA_OP & no5,	
											NOP_OP,
											NOP_OP,
											STR_OP & R2_ADDRESS & no15,
											BRA_OP & no13,
											NOP_OP,
											NOP_OP
										);
	
	
	
	--type ROM_array is array (9 downto 0) of std_logic_vector(15 downto 0);
	--VARIABLE ROM : ROM_array;
	BEGIN
--	data <=  LDI_OP & R3_ADDRESS & "0011"							when adr = "0000" and ce = '0' else --address 0
--				--TEST
--				LDI_OP & R2_ADDRESS & "0111"							when adr = "0001" and ce = '0' else --address 0 TEST!!
--				LDI_OP & R1_ADDRESS & "1111"							when adr = "0010" and ce = '0' else --address 0 TEST!!
--				--STR_OP & R3_ADDRESS & "1110"							when adr = "0001" and ce = '0'  else --address 1
--				--LDI_OP & R1_ADDRESS & "0001"							when adr = "0010" and ce = '0'  else --address 2
--				LDR_OP & R0_ADDRESS & "1110"							when adr = "0011" and ce = '0'  else --address 3
--				MOV_OP & R0_ADDRESS & "00" & R2_ADDRESS			when adr = "0100" and ce = '0'  else --address 4
--				ADD_OP & R2_ADDRESS & R1_ADDRESS & R2_ADDRESS	when adr = "0101" and ce = '0'  else --address 5
--				SUB_OP & R0_ADDRESS & R1_ADDRESS & R0_ADDRESS	when adr = "0110" and ce = '0'  else --address 6
--				BRZ_OP & "1100"											when adr = "0111" and ce = '0'  else --address 7
--				NOP_OP														when adr = "1000" and ce = '0'  else --address 8
--				BRA_OP & "0101"											when adr = "1001" and ce = '0'  else --address 9
--				STR_OP & R2_ADDRESS & "1111"							when adr = "1100" and ce = '0'  else --address 12
--				BRA_OP & "1101"											when adr = "1101" and ce = '0'  else --address 13
--				NOP_OP														when ce = '0' else
--				(others => 'Z');
				data <= rom(conv_integer(adr));
END ARCHITECTURE;