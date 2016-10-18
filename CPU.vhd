library ieee;
use ieee.std_logic_1164.all;
use work.cpu_package.all;

ENTITY CPU is 
    PORT(  adr        : OUT address_bus; 
           data       : IN instruction_bus; 
           stop       : IN std_logic;       -- stops statemachine 
           RWM_data   : INOUT data_bus; 
           rw_RWM     : OUT std_logic;      -- read on high 
           ROM_en     : OUT std_logic;      -- active low 
           RWM_en     : OUT std_logic;      -- active low 
           clk        : IN std_logic; 
           reset      : IN std_logic);      -- active high 
END ENTITY CPU; 
ARCHITECTURE Structure of CPU is 
component ALU is
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
end component ALU;
component Controller IS
    PORT(  adr        : OUT address_bus;          -- unsigned 
           data       : IN program_word;          -- unsigned    
           rw_RWM     : OUT std_logic;            -- read on high 
           RWM_en     : OUT std_logic;            -- active low 
           ROM_en     : OUT std_logic;            -- active low 
           clk        : IN std_logic; 
           reset      : IN std_logic;             -- active high 
           rw_reg     : OUT std_logic;            -- read on high 
           sel_op_1   : OUT std_logic_vector (1 downto 0); 
           sel_op_0   : OUT std_logic_vector (1 downto 0); 
           sel_in     : OUT std_logic_vector (1 downto 0); 
           sel_mux    : OUT std_logic_vector (1 downto 0); 
           alu_op     : OUT std_logic_vector (2 downto 0); 
--           sel_op_1   : OUT unsigned (1 downto 0); 
--           sel_op_0   : OUT unsigned (1 downto 0); 
--           sel_in     : OUT unsigned (1 downto 0); 
--           sel_mux    : OUT unsigned (1 downto 0); 
--           alu_op     : OUT unsigned (2 downto 0); 
			  --super el fix
           stop		 : IN std_logic;				  -- active high
           alu_en     : OUT std_logic;            -- active high 
           z_flag     : IN std_logic;             -- active high 
           n_flag     : IN std_logic;             -- active high 
           o_flag     : IN std_logic;             -- active high 
           out_en     : OUT std_logic;            -- active high 
           data_imm   : OUT data_word);           -- signed 
END component Controller; 

component Multiplexer is 
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
End component Multiplexer; 

component RegisterFile IS 
PORT(      clk           : IN std_logic; 
           data_in       : IN std_logic_vector(3 downto 0); 
           data_out_1    : OUT std_logic_vector(3 downto 0);
           data_out_0    : OUT std_logic_vector(3 downto 0); 
           --data_in       : IN data_word; 
           --data_out_1    : OUT data_word; 
           --data_out_0    : OUT data_word; 
			  
           sel_in        : IN std_logic_vector (1 downto 0); 
           sel_out_1     : IN std_logic_vector (1 downto 0); 
           sel_out_0     : IN std_logic_vector (1 downto 0);          
           rw_reg        : in std_logic); 
END component RegisterFile; 

component DataBuffer IS 
    PORT ( out_en     : IN std_logic; 
           --data_in    : IN data_word; 
			  data_in    : IN std_logic_vector(3 downto 0); 
           --data_out   : OUT data_bus); 
			  data_out   : OUT std_logic_vector(3 downto 0)); 
END component DataBuffer; 

	--signals:
	--signal signal_adr : address_bus;
	--signal signal_data : std_logic_vector(9 downto 0);
	
	signal alu_op : std_logic_vector (2 downto 0);
	signal alu_a : data_word;
	signal alu_b : data_word;
	signal alu_en : std_logic;
	signal alu_y : data_word;
	signal alu_n_flag : std_logic;
	signal alu_z_flag : std_logic;
	signal alu_o_flag : std_logic;
	
	signal mux_sel : std_logic_vector(1 downto 0); 
	signal mux_data_in_2 : std_logic_vector(3 downto 0);
	--signal mux_data_in_1 : std_logic_vector(3 downto 0); --goes to rwm_data
	--signal mux_data_in_0 : std_logic_vector(3 downto 0); --goes to Alu_y
	signal mux_data_out : std_logic_vector(3 downto 0);
	
	signal databuffer_out_en : std_logic;
	--signal databuffer_data_in : std_logic_vector(3 downto 0); --  equals ALU_a and registerfile_data_out_1
	signal databuffer_data_out : std_logic_vector(3 downto 0);
	
	--signal registerfile_data_in : std_logic_vector(3 downto 0); -- equals mux_data_out
	--signal registerfile_data_out_1 : std_logic_vector(3 downto 0); -- equals ALU_a and buffer_data_in
	--signal registerfile_data_out_0 : std_logic_vector(3 downto 0); -- equals ALU_b
	signal registerfile_sel_in : std_logic_vector (1 downto 0); 
	signal registerfile_sel_out_1 : std_logic_vector (1 downto 0); 
	signal registerfile_sel_out_0 : std_logic_vector (1 downto 0); 
	signal registerfile_rw_reg : std_logic;
	
begin
	Controller1: Controller port map ( adr => adr, data => data, clk => clk, stop => stop,
													rw_reg => registerfile_rw_reg, sel_op_1 => registerfile_sel_out_1, sel_op_0 => registerfile_sel_out_0, sel_in => registerfile_sel_in, 
													alu_op => alu_op, sel_mux => mux_sel, alu_en => alu_en, out_en => databuffer_out_en, reset => reset, z_flag => alu_z_flag,
													n_flag => alu_n_flag, o_flag => alu_o_flag, data_imm => mux_data_in_2, rw_rwm => rw_RWM, rwm_en => RWM_en, rom_en => ROM_en
													);
													
	Alu1: ALU port map ( op => alu_op, a => alu_a, b => alu_b, en => alu_en, clk => clk, y => alu_y, n_flag => alu_n_flag, z_flag => alu_z_flag, o_flag => alu_o_flag);
	Mux1:  Multiplexer port map (sel => mux_sel, data_in_2 => mux_data_in_2, data_in_1 => rwm_data, data_in_0 => alu_y, data_out => mux_data_out);
	Data1: DataBuffer port map (out_en => databuffer_out_en, data_in => alu_a, data_out => rwm_data);
--	Register1: RegisterFile port map (clk => clk, data_in => mux_data_out, data_out_1 => alu_a,
--													data_out_0 => alu_b, sel_in => registerfile_sel_in, sel_out_1 => registerfile_sel_out_1,
--													sel_out_0 => registerfile_sel_out_0, rw_reg => registerfile_rw_reg); 
	Register1: RegisterFile port map (clk => clk, data_in => mux_data_out, data_out_1 => alu_a,
													data_out_0 => alu_b, sel_in => registerfile_sel_in, sel_out_1 => registerfile_sel_out_1,
													sel_out_0 => registerfile_sel_out_0, rw_reg => registerfile_rw_reg
													);

end ARCHITECTURE;