

library IEEE;
use IEEE.std_logic_1164.all;
use WORK.divider_const.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.decoder.all;

--Additional standard or custom libraries go here
entity divider is
port(
--Inputs
-- clk : in std_logic;
--COMMENT OUT clk signal for Part A.
start : in std_logic;
dividend : in std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
divisor : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
--Outputs
quotient : out std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
remainder : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
overflow : out std_logic
 );
end entity divider;
architecture structural_combinational of divider is
--Signals and components go here
	signal a : integer;
	signal b: integer;
	signal e : integer;
	signal f: integer;
	signal result : integer;
	signal result_final: std_logic_vector(DIVIDEND_WIDTH -1 downto 0);
	signal sumvector: std_logic;
	signal temsum: integer;
	signal sum: integer;
	signal tem1: std_logic_vector(DATA_WIDTH -1 downto 0);
	signal tem0: std_logic_vector(DATA_WIDTH -1 downto 0);
	constant c : integer:=0;
	type tem_arrayint is array (0 to 54) of std_logic_vector(DATA_WIDTH downto 0);
	signal temin : tem_arrayint;
	type tem_arrayout is array (0 to 54) of std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal temout : tem_arrayout;
	signal recaltem : std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal starttest: std_logic;
-------------------comparator--------------------------

component comparator is
generic(
	DATA_WIDTH : natural := 8);

port(
--Inputs
DINL : in std_logic_vector (DATA_WIDTH downto 0);
DINR : in std_logic_vector (DATA_WIDTH - 1 downto 0);
--Outputs
DOUT : out std_logic_vector (DATA_WIDTH - 1 downto 0);
isGreaterEq : out std_logic
 );
--end entity comparator;
end component;
-----------------------signal---------------------------------
	
--------------------------------------------------------------------


begin

	temout(DIVIDEND_WIDTH - 1)<= "00000000";

comp:	for i in DIVIDEND_WIDTH -1 downto 1 GENERATE
------------------i = 15 -------

	temin(i) <= temout(i)&dividend(i);


	divisioncal: comparator port map( DINL=>temin(i), 
			     DINR=>divisor,
			     DOUT=>temout(i-1),
			     isGreaterEq=>result_final(i)
			    );
	
end generate comp;


	temin(0) <= temout(0)&dividend(0);

	divisioncal: comparator port map( DINL=>temin(0), 
			     DINR=>divisor,
			     DOUT=>temout(54),
			     isGreaterEq=>result_final(0));
	--starttest<=start;

process(start,result_final,temout,divisor)
begin
	if start = '1' then
		if to_integer(unsigned(divisor)) = 0 then
       		overflow <= '1';
		else
		overflow <= '0';
    		end if;
	quotient<=result_final;
	remainder<=temout(54);
	
	else 
		if to_integer(unsigned(divisor)) = 0 then
       		overflow <= '1';
		else
		overflow <= '0';
    		end if;
	quotient<=(others=>'0');
	remainder<=(others=>'0');
	end if;
	
end process;

end architecture structural_combinational;
-----------------------------