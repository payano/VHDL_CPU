library ieee;
use ieee.std_logic_1164.all;
use work.cpu_package.all;
--use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL; --for conv_integer

ENTITY Controller IS
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
           stop		 : IN std_logic;				  -- active high
           alu_en     : OUT std_logic;            -- active high 
           z_flag     : IN std_logic;             -- active high 
           n_flag     : IN std_logic;             -- active high 
           o_flag     : IN std_logic;             -- active high 
           out_en     : OUT std_logic;            -- active high 
			  --super el fix

           data_imm   : OUT data_word);           -- signed 

END ENTITY Controller; 


architecture RTL of controller is
	type my_states is (S0,S1,S2,S3,S4,S5,S6,S7);
	signal current_state,next_state : my_states := s0;

begin
	process(clk,reset)
	variable pc : std_logic_vector(3 downto 0);
	variable instr : std_logic_vector(9 downto 0);
	begin
		--change between states:
		--if (stop = '0') then
			if(reset = '1') then
				next_state <= S0;
			elsif(rising_edge(clk)) then
				case next_state is
					when s0 =>
						pc := (others => '0');
						next_state <= s1;
					when s1 =>
						adr <= pc;
						if(stop = '0') then
							next_state <= s2;
						else
							pc := "1111";
							next_state <= s1;
						end if;
						RWM_en <= '1'; --disable ram
						rom_en <= '0'; --enable rom
						rw_reg <= '1'; --register read mode
						alu_en <= '0'; --disable ALU
						out_en <= '0'; --disable buffer
						rw_RWM <= '1'; --RAM read mode
						
					when s2 =>
						instr := data;
						sel_op_1 <= instr(5 downto 4);
						sel_op_0 <= instr(3 downto 2);
						next_state <= s3;
					when s3 =>
						if(instr(9) = '0') then
							--ALU
							alu_op <= instr(8 downto 6); --alu bits
							alu_en <= '1'; --active high
							pc := (pc + 1);
							--fixa mux ocksa
							sel_mux <= "00"; --select ALU on mux
							next_state <= s4;
						else
							case instr(8 downto 6) is
								when "000" =>
									--LDR
									RWM_en <= '0'; --enable ram
									rom_en <= '1'; --disable rom
									sel_mux <= "01"; --select RAM on mux
									adr <= instr(3 downto 0);
									pc := (pc + 1);
									next_state <= s5;
								when "001" =>
									--STR
									RWM_en <= '0'; --enable ram
									rom_en <= '1'; --disable rom
									out_en <= '1'; --enable buffer
									pc := (pc + 1);
									next_state <= s6;
								when "010" =>
									--LDI
									sel_mux <= "10";
									data_imm <= instr(3 downto 0);
									pc := (pc + 1);
									next_state <= s7;
								when "011" =>
									--NOP
									pc := (pc + 1);
									next_state <= s1;
								when "100" =>
									--BRZ
									if(z_flag = '1') then
										pc := instr(3 downto 0);
									else
										pc := (pc + 1);
									end if;
									next_state <= s1;
								when "101" =>
									--BRN
									if(n_flag = '1') then
										pc := instr(3 downto 0);
									else
										pc := (pc + 1);
									end if;
									next_state <= s1;
								when "110" =>
									--BRO
									if(o_flag = '1') then
										pc := instr(3 downto 0);
									else
										pc := (pc + 1);
									end if;
									next_state <= s1;
								when "111" =>
									--BRA
									pc := instr(3 downto 0);
									next_state <= s1;
								when others =>
							end case;
						end if;
					when s4 =>
					--ALU
						sel_in <= instr(1 downto 0);
						rw_reg <= '0'; --register write mode
						next_state <= s1;
					when s5 =>
					--LOAD REGISTER
						sel_in <= instr(5 downto 4);
						rw_reg <= '0'; --register write mode
						next_state <= s1;
					when s6 =>
					--STORE REGISTER
						rw_RWM <= '0'; --RAM write mode
						adr <= instr(3 downto 0);
						next_state <= s1;
					when s7 =>
					--LOAD IMMEDIATE
						sel_in <= instr(5 downto 4);
						rw_reg <= '0'; --register write mode
						next_state <= s1;
				end case;	
			end if;
		--end if;
	end process;
end architecture;	