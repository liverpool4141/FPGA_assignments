library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.quantize.all;
use WORK.parameters.all;



entity demodulate_n is

port
(
	I_fir	: in	int_array (0 to samples-1);
	Q_fir	: in	int_array (0 to samples-1);
	num	: in	integer;
	demod	: out int_array (0 to samples-1)
);
end entity demodulate_n;


architecture behavior of demodulate_n is 

function qarctan( y : integer; x : integer)	return integer is
	variable abs_y : integer;	
	variable angle : integer;
	variable r     : integer;
	constant quad_1 : integer := quantize_f(pi / 4.0 );
	constant quad_3 : integer := quantize_f(3.0*pi/4.0 );
begin
	abs_y := abs(y)+1;
	if ( x >= 0) then
		r     := quantize_i(x - abs_y)/(x + abs_y);
		angle := quad_1 - dequantize(quad_1*r);
	else
		r     := quantize_i(x + abs_y)/(abs_y - x);
		angle := quad_3 - dequantize(quad_1*r);
	end if;
	if ( y < 0) then
		return 0 - angle;
	else
		return angle;
	end if;
end qarctan;


begin

process(I_fir,Q_fir)
	variable r	: integer;
	variable i	: integer;
	variable demod_real: integer:=0;
	variable demod_imag: integer:=0;
begin
	for n in 0 to samples-1 loop
		demod(n)<=0;
	end loop;
	
	for n in 0 to num-1 loop
		r:=dequantize(I_fir(n)*demod_real)-dequantize(0-Q_fir(n)*demod_imag);
		i:=dequantize(Q_fir(n)*demod_real)+dequantize(0-I_fir(n)*demod_imag);
		
		demod(n) <= dequantize(fm_demod_gain*qarctan(i,r));
		
		demod_real := I_fir(n);
		demod_imag := Q_fir(n);
	end loop;
	
end process;
end architecture behavior;


	




