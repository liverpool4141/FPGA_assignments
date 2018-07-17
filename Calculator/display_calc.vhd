library IEEE;
use IEEE.std_logic_1164.all;
use WORK.decoder.all;
use WORK.calc_const.all;



--Additional standard or custom libraries go here
entity display_calc is
port(
--You will replace these with your actual inputs and outputs

-------input---------------------
DIN1 : in std_logic_vector (DIN1_WIDTH - 1 downto 0);
DIN2 : in std_logic_vector (DIN2_WIDTH - 1 downto 0);
operation : in std_logic_vector (OP_WIDTH - 1 downto 0);

-------output--------------------
output_final   : out std_logic_vector(DOUT_WIDTH/4*7-1 downto 0);
sign_final : out std_logic
);
end entity display_calc;
architecture structural of display_calc is

component leddcd is
port(
			 data_in : in std_logic_vector(3 downto 0);
			 segments_out : out std_logic_vector(6 downto 0)
			);
end component leddcd;

component calculator is 
port(
--Inputs
DIN1 : in std_logic_vector (DIN1_WIDTH - 1 downto 0);
DIN2 : in std_logic_vector (DIN2_WIDTH - 1 downto 0);
operation : in std_logic_vector (OP_WIDTH - 1 downto 0);
--Outputs
DOUT : out std_logic_vector (DOUT_WIDTH - 1 downto 0);
sign : out std_logic
);
end component calculator;

SIGnAL calc_output : std_logic_vector (DOUT_WIDTH - 1 downto 0);
SIGNAL sign1 :  std_logic;
--Signals and components go here
begin
calc : calculator port map (DIN1, DIN2, operation, calc_output, sign1);

sign_final <= NOT(sign1);

p2: FOR i in 0 to (DOUT_WIDTH/4-1) generate
final_display : leddcd port map (calc_output(4*i+3 downto i*4), output_final(7*i+6 downto i*7 ));
end generate;
--Structural design goes here
end architecture structural;