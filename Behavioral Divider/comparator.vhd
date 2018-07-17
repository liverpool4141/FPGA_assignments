



-----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.decoder.all;

--Additional standard or custom libraries go here
entity comparator is
generic(
DATA_WIDTH : natural := 4);

port(
--Inputs
DINL : in std_logic_vector (DATA_WIDTH downto 0);
DINR : in std_logic_vector (DATA_WIDTH - 1 downto 0);
--Outputs
DOUT : out std_logic_vector (DATA_WIDTH - 1 downto 0);
isGreaterEq : out std_logic
 );
end entity comparator;
architecture behavioral of comparator is
--Signals and components go here
	signal a : integer;
	signal b: integer;
	signal result : integer;
	constant c : integer:=0;
begin

	a <=to_integer(signed(DINL));
	b <=to_integer(signed(DINR));

p : process(a,b,result)

	begin
--Behavioral design goes here
	
	
	if (a>=b) then 
	result<=(a-b);
	isGreaterEq<='1';
	DOUT<=std_logic_vector(to_signed(result,DATA_WIDTH));
	else 
	result<=a;
	isGreaterEq<='0';
	end if;
	DOUT<=std_logic_vector(to_signed(result,DATA_WIDTH));
end process p;
end architecture behavioral;
----------------------------------