library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.decoder.all;
use WORK.calc_const.all;
--Additional standard or custom libraries go here

entity calculator is
port(
--Inputs
DIN1 : in std_logic_vector (DIN1_WIDTH - 1 downto 0);
DIN2 : in std_logic_vector (DIN2_WIDTH - 1 downto 0);
operation : in std_logic_vector (OP_WIDTH - 1 downto 0);
--Outputs
DOUT : out std_logic_vector (DOUT_WIDTH - 1 downto 0);
sign : out std_logic
);
end entity calculator;
architecture behavioral of calculator is

	SIGNAL a: INTEGER;
	SIGNAL b: INTEGER;
	SIGNAL result: INTEGER;
	CONSTANT c: INTEGER :=0;
begin
	
	a<=to_integer(signed(DIN1));
	b<=to_integer(signed(DIN2));
	calc : PROCESS(a,b,result,operation)
	begin
		if operation = "00" then
			result <= (a+b);
		elsif operation= "01" then 
			result <= (a-b);
		elsif operation= "10" then
			result <= (a*b);
		else
			result <= c;
		end if;
                end PROCESS calc;

                check_sign : Process (result)
                begin
		if result >= c then
			sign <='0';
                        DOUT <= std_logic_vector(to_signed(result, DOUT_WIDTH));
                        
		else
			sign <= '1';
			DOUT <= std_logic_vector(to_signed(abs(result), DOUT_WIDTH));
                END if;
	        END Process check_sign;
			   
end architecture behavioral;