library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.quantize.all;
use WORK.parameters.all;

entity fir_cmplx_n is
port(
	I		: in	int_array (0 to samples-1);
	Q		: in	int_array (0 to samples-1);
	num	: in	integer;
	I_fir	: out int_array (0 to samples-1);
	Q_fir	: out int_array (0 to samples-1)
);
end entity fir_cmplx_n;



architecture behavior of fir_cmplx_n is
	signal taps		: integer := channel_coeff_taps;
begin

process(I,Q)
	variable x_real	: int_array (0 to max_taps-1);
	variable x_imag	: int_array (0 to max_taps-1);
	variable y_real	: integer :=0;
	variable y_imag	: integer :=0;
begin
	for n in 0 to samples-1 loop
		I_fir(n)<=0;
		Q_fir(n)<=0;
	end loop;
	
	for n in 0 to max_taps-1 loop
		x_real(n) := 0;
		x_imag(n) := 0;
	end loop;
	
	for n in 0 to num-1 loop
		y_real:=0;
		y_imag:=0;
		
		for j in 1 to taps-1 loop
			x_real(taps-j) := x_real(taps-j-1);
			x_imag(taps-j) := x_imag(taps-j-1);
		end loop;
		
		x_real(0) := I(n);
		x_imag(0) := Q(n);
		
		for k in 0 to taps-1 loop
			y_real := y_real+dequantize((channel_coeffs_real(k)*x_real(k))-(channel_coeffs_imag(k)*x_imag(k)));
			y_imag := y_imag+dequantize((channel_coeffs_real(k)*x_imag(k))-(channel_coeffs_imag(k)*x_real(k)));
		end loop;
		
		I_fir(n) <= y_real;
		Q_fir(n) <= y_imag;
	end loop;
end process;

end architecture behavior;