
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.quantize.all;
use WORK.parameters.all;


package compute is


--constant bits				:integer := 10;
--constant quant_val		:integer	:= to_integer(shift_left(to_unsigned(1,32),bits));

function add_n (
		x_in : int_array; 
		y_in : int_array; 
		n_samples: integer)return int_array;

function sub_n (
		x_in : int_array; 
		y_in : int_array; 
		n_samples: integer)return int_array;

function multiply_n (
		x_in : int_array; 
		y_in : int_array; 
		n_samples: integer)return int_array;

function gain_n(
		x_in : int_array; 
		n_samples: integer;
		gain: integer    )return int_array;

end package;


package body compute is

	function add_n (
			x_in : int_array; 
			y_in : int_array; 
			n_samples: integer) return int_array is
	variable output: int_array (0 to n_samples-1);
	begin
	for n in 0 to n_samples - 1  loop
	output(n) := 0;
	end loop;
	
	for n in 0 to n_samples - 1 loop
	output(n) := x_in(n) + y_in(n);
	end loop;
	return output;
	end;
	

	function sub_n (
			x_in : int_array; 
			y_in : int_array; 
			n_samples: integer) return int_array is
	variable output: int_array (0 to n_samples-1);
	begin
	for n in 0 to n_samples - 1  loop
	output(n) := 0;
	end loop;
	
	for n in 0 to n_samples - 1 loop
	output(n) := x_in(n) - y_in(n);
	end loop;
	return output;
	end;
	
	


	function multiply_n (
			x_in : int_array; 
			y_in : int_array; 
			n_samples: integer) return int_array  is
	variable output: int_array (0 to n_samples-1);
	begin
	for n in 0 to n_samples - 1  loop
	output(n) := 0;
	end loop;
	
	for n in 0 to n_samples - 1 loop
	output(n) := dequantize(x_in(n) * y_in(n)); 
	end loop;
	return output;
	end;
	

	function gain_n(
		x_in : int_array; 
		n_samples: integer;
		gain: integer    )return int_array  is
	variable output: int_array (0 to n_samples-1);
	begin
	for n in 0 to n_samples - 1  loop
	output(n) := 0;
	end loop;
	
	for n in 0 to n_samples - 1 loop
	output(n) := to_integer(shift_left(to_signed(dequantize(x_in(n) * gain),32),4)); 
	end loop;
	return output;
	end;
		





end package body;