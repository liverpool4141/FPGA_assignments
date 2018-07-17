library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.quantize.all;
use WORK.parameters.all;

entity read_IQ is
port(
	IQ		: in	char_array (0 to samples*4-1);
	num	: in	integer;
	I		: out	int_array (0 to samples-1);
	Q		: out	int_array (0 to samples-1)
);
end entity read_IQ;


architecture behavior of read_IQ is
begin

process (IQ)
begin
	for n in 0 to samples-1 loop
		I(n)<=0;
		Q(n)<=0;
	end loop;
	
	for n in 0 to num-1 loop
		I(n) <= QUANTIZE_I(to_integer(signed(std_logic_vector(shift_left(resize(unsigned(IQ(n*4+1)),16),8)) or std_logic_vector(resize(unsigned(IQ(n*4)),16)))));
		Q(n) <= QUANTIZE_I(to_integer(signed(std_logic_vector(shift_left(resize(unsigned(IQ(n*4+3)),16),8)) or std_logic_vector(resize(unsigned(IQ(n*4+2)),16)))));
	end loop;
end process;

end architecture behavior;