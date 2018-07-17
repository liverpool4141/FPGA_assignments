library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package quantize is

--quantization
constant bits				:integer := 10;
constant quant_val		:integer	:= to_integer(shift_left(to_unsigned(1,32),bits));

function quantize_f (f: real)		return integer;
function quantize_i (i: integer)	return integer;
function dequantize (i: integer)	return integer;

end package;


package body quantize is

	function quantize_f (f: real) return integer is
		variable temp: real;
	begin
		temp:=f*real(quant_val);
		if (temp>0.0) then
			return integer (f*real(quant_val)-0.5);
		elsif (temp=0.0) then
			return 0;
		else
			return integer (f*real(quant_val)+0.5);
		end if;
	end;
	
	
	function quantize_i (i: integer) return integer is
	begin
		return i*quant_val;
	end;
	
	
	function dequantize (i:integer) return integer is
	begin
		return i/quant_val;
	end;
	
end package body;