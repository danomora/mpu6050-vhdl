----------------------------------------------------------------------------------
-- Engineer: 	Daniel Moran <dmorang@hotmail.com>
-- Project: 	mpu6050 
-- Description: reading raw values for mpu6050
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_Arith.all;

ENTITY mpu_rg_avalon IS
	PORT(
		clk: in std_logic;
		reset_n : in std_logic;
		address : in std_logic_vector(2 downto 0);
		read : in std_logic;
		write : in std_logic;
		readdata : out std_logic_vector(31 downto 0);
		writedata : in std_logic_vector(31 downto 0);
		sda    : inout std_logic;
		scl    : out std_logic
		);
END mpu_rg_avalon;


ARCHITECTURE sol OF mpu_rg_avalon IS


	COMPONENT mpu_rg is
		PORT(
			CLOCK_50:	IN	STD_LOGIC;
			reset_n:    in std_logic;
			en:         in std_logic;
			I2C_SDAT: INOUT	STD_LOGIC;
			I2C_SCLK: OUT STD_LOGIC;
			gx: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			gy: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			gz: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			ax: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			ay: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			az: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;



	--Address for different registers
	constant REG_INPUT_0_OFST : std_logic_vector(2 downto 0)   := "000"; 
	constant REG_OUTPUT_1_OFST : std_logic_vector(2 downto 0)  := "001";
	constant REG_OUTPUT_2_OFST : std_logic_vector(2 downto 0)  := "010"; 
	constant REG_OUTPUT_3_OFST : std_logic_vector(2 downto 0)  := "011"; 
	constant REG_OUTPUT_4_OFST : std_logic_vector(2 downto 0)  := "100";
	constant REG_OUTPUT_5_OFST : std_logic_vector(2 downto 0)  := "101"; 
	constant REG_OUTPUT_6_OFST : std_logic_vector(2 downto 0)  := "110";



	signal ready: std_logic;
	signal reg_input_0 : std_logic_vector(31 downto 0); --------en
	signal reg_output_1 : std_logic_vector(31 downto 0); -------gx
	signal reg_output_2 : std_logic_vector(31 downto 0);------gy
	signal reg_output_3 : std_logic_vector(31 downto 0);------gz
	signal reg_output_4 : std_logic_vector(31 downto 0);-----ax
	signal reg_output_5 : std_logic_vector(31 downto 0);-----ay
	signal reg_output_6 : std_logic_vector(31 downto 0);-----az

	
	
	BEGIN
	
	-- Avalon-MM slave write
		process(clk, reset_n)
		begin
			if reset_n = '0' then
				reg_input_0 <= (others => '0');
				
				elsif rising_edge(clk) then
					if write = '1' then
						case address is
							-- RESULT register is read-only
							when REG_INPUT_0_OFST => 	reg_input_0 <= std_logic_vector(writedata);
							when REG_OUTPUT_1_OFST => null;
							when REG_OUTPUT_2_OFST => null;
							when REG_OUTPUT_3_OFST => null;
							when REG_OUTPUT_4_OFST => null;
							when REG_OUTPUT_5_OFST => null;
							when REG_OUTPUT_6_OFST => null;

							
							when others => null;
						end case;
					end if;
				end if;
		end process;

	-- Avalon-MM slave read
		process(clk, reset_n)
		begin
			if rising_edge(clk) then
				if read = '1' then
					case address is
							when REG_INPUT_0_OFST =>	   readdata <= std_logic_vector(reg_input_0);
							when REG_OUTPUT_1_OFST =>		readdata <= std_logic_vector(reg_output_1);
							when REG_OUTPUT_2_OFST => 		readdata <= std_logic_vector(reg_output_2);
							when REG_OUTPUT_3_OFST => 		readdata <= std_logic_vector(reg_output_3);
							when REG_OUTPUT_4_OFST => 		readdata <= std_logic_vector(reg_output_4);
							when REG_OUTPUT_5_OFST => 		readdata <= std_logic_vector(reg_output_5);
							when REG_OUTPUT_6_OFST => 		readdata <= std_logic_vector(reg_output_6);
		
					
						-- Remaining addresses in register map are unmapped => return 0.
						when others =>	readdata <= (others => '0');
					end case;
				end if;
			end if;
		end process;
	MPUrg : mpu_rg
				port map( 
							CLOCK_50   =>  clk,
							reset_n    =>  reset_n,  
							en			  =>  reg_input_0(0),
							I2C_SDAT   =>  sda,
							I2C_SCLK   =>  scl,
							gx         => 	reg_output_1(15 downto 0),
							gy         => 	reg_output_2(15 downto 0),
							gz         => 	reg_output_3(15 downto 0),
							ax         => 	reg_output_4(15 downto 0),
							ay         => 	reg_output_5(15 downto 0),
							az         => 	reg_output_6(15 downto 0)
							);
end sol;
