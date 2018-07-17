library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.quantize.all;
use WORK.parameters.all;

entity deemphasis_n is
port(
	x_in	: in	int_array (0 to audio_samples-1);
	y_out	: out	int_array (0 to audio_samples-1)
);
end entity deemphasis_n;



architecture behavior of deemphasis_n is
begin

process(x_in)
	variable j	: integer;
	variable y1	: integer;
	variable y2	: integer;
	variable x	: int_array(0 to max_taps-1);
	variable y	: int_array(0 to max_taps-1);
begin
	j:=0;
	for n in 0 to max_taps-1 loop
		x(n):=0;
		y(n):=0;
	end loop;
	
	for i in 0 to audio_samples-1 loop
		y1:=0;
		y2:=0;
		
		x(1):=x(0);
		y(1):=y(0);
		
		x(0):=x_in(j);
		
		y1:=y1+dequantize(iir_x_coeffs(0)*x(0));
		y2:=y2+dequantize(iir_y_coeffs(0)*y(0));
		y1:=y1+dequantize(iir_x_coeffs(1)*x(1));
		y2:=y2+dequantize(iir_y_coeffs(1)*y(1));
		
		y(0):=y1+y2;
		
		y_out(i)<=y(1);
		j:=j+1;
	end loop;

end process;
end architecture behavior;
		
		
		
		
		
		
		