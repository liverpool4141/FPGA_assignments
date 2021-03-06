library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;
use IEEE.std_logic_arith.all;
use WORK.quantize.all;
use WORK.parameters.all;
use WORK.compute.all;

entity fm_radio_tb is
generic
(
	constant mem_in_name	: string (9 downto 1) := "small.dat";
	constant clock_period	: time := 10 ns
);
end entity fm_radio_tb;



architecture behavior of fm_radio_tb is

	-- clock, reset signals
	signal clock		: std_logic := '1';
	signal reset		: std_logic := '0';
	signal hold_clock 	: std_logic := '0';
	
	--memory signals
	
	signal in_rd_en		: std_logic :='0';
	signal in_wr_en		: std_logic :='0';
	signal in_din		: std_logic_vector (7 downto 0):="00000000";
	signal in_full		: std_logic;
	signal in_empty		: std_logic;
	signal out_rd_en	: std_logic :='0';
	signal out_wr_en	: std_logic :='0';
	signal left_dout	: std_logic_vector (31 downto 0);
	signal left_full	: std_logic;
	signal left_empty	: std_logic;
	signal right_dout	: std_logic_vector (31 downto 0);
	signal right_full	: std_logic;
	signal right_empty	: std_logic;
	signal in_read_done	: std_logic :='0';
	signal out_read_done	: std_logic :='0';
	signal write_done	: std_logic :='0';
	
	signal errors		: integer := 0;

	component fm_radio_top is
	port
	(
		clock		: in std_logic;
		reset		: in std_logic;
		in_rd_en	: in std_logic :='0';
		in_wr_en	: in std_logic :='0';
		in_din		: in std_logic_vector (7 downto 0);
		in_full		: out std_logic;
		in_empty	: out std_logic;
		out_rd_en	: in std_logic :='0';
		out_wr_en	: in std_logic :='0';
		left_dout	: inout std_logic_vector (31 downto 0);
		left_full	: out std_logic;
		left_empty	: out std_logic;
		right_dout	: inout std_logic_vector (31 downto 0);
		right_full	: out std_logic;
		right_empty	: out std_logic;
		in_read_done	: in std_logic;
		out_read_done	: in std_logic
	);
	end component fm_radio_top;
	
begin

clock_process : 
process
begin
	clock <= '1';
	wait for (CLOCK_PERIOD / 2);
	clock <= '0';
	wait for (CLOCK_PERIOD / 2);
	if ( hold_clock = '1' ) then
		wait;
	end if;
end process clock_process;


reset_process : 
process
begin
	reset <= '0';
	wait until (clock = '0');
	wait until (clock = '1');
	reset <= '1';
	wait until (clock = '0');
	wait until (clock = '1');
	reset <= '0';
	wait;
end process reset_process;


fm_radio_top_inst:
component fm_radio_top
port map
(
	clock=>clock,
	reset=>reset,
	in_rd_en=>in_rd_en,
	in_wr_en=>in_wr_en,
	in_din=>in_din,
	in_full=>in_full,
	in_empty=>in_empty,
	out_rd_en=>out_rd_en,
	out_wr_en=>out_wr_en,
	left_dout=>left_dout,
	left_full=>left_full,
	left_empty=>left_empty,
	right_dout=>right_dout,
	right_full=>right_full,
	right_empty=>right_empty,
	in_read_done=>in_read_done,
	out_read_done=>out_read_done
);


input_file_to_input_fifo_process : 
process 
	type raw_file is file of character;
	file mem_in_file : raw_file open read_mode is mem_in_name;
	variable char : character;
	variable i : integer:=0;
	variable IQ_temp	: char_array(0 to samples*4-1):=(others=> (others=>'0'));
begin
	wait until (reset = '1');
	wait until (reset = '0');
	in_wr_en <='1';
	while ( not ENDFILE(mem_in_file) ) loop			
		wait until (clock = '1');
		read( mem_in_file, char );
		in_din <= conv_std_logic_vector(character'pos(char),8);
		wait until (clock = '0');
	end loop;
	--IQ<=IQ_temp;
	wait until (clock='0');
	wait for 100 ns;
	in_wr_en<='0';
	file_close( mem_in_file );
	in_read_done <= '1';
	wait;
end process input_file_to_input_fifo_process;


input_fifo_to_signal_time_process:
process
begin
	wait until (reset = '1');
	wait until (reset = '0');
	wait for 100 ns;
	in_rd_en<='1';
	wait until (clock='0');
	while ( in_read_done = '0') loop
		wait until (clock='1');
		wait until (clock='0');
	end loop;
	in_rd_en<='0';
end process input_fifo_to_signal_time_process;


result_to_output_fifo_time_process:
process
begin
	wait until (reset = '1');
	wait until (reset = '0');
	wait for 150 ns;
	wait for 327680 ns;
	while (in_read_done='0') loop
		wait for 10158080 ns;
		out_wr_en<='1';
		for i in 0 to audio_samples-1 loop
			wait until (clock='1');
			wait until (clock='0');
		end loop;
		out_wr_en<='0';
	end loop;
	wait until (clock='0');
	wait for 100 ns;
	out_read_done <= '1';
	wait;
end process result_to_output_fifo_time_process;


output_fifo_to_output_file_process : 
process 
	file left_file	: text;
	file right_file	:text;
	variable left_line	: line;
	variable right_line	: line;
	variable left_num, right_num	: integer;
	variable l_dig1, l_dig2, l_dig3, l_dig4, l_dig5, l_dig6, l_dig7, l_dig8		: integer;
	variable r_dig1, r_dig2, r_dig3, r_dig4, r_dig5, r_dig6, r_dig7, r_dig8		: integer;
	variable l_char1, l_char2, l_char3, l_char4, l_char5, l_char6, l_char7, l_char8	: character;
	variable r_char1, r_char2, r_char3, r_char4, r_char5, r_char6, r_char7, r_char8	: character;
begin
	wait until (reset = '1');
	wait until (reset = '0');
	wait for 250 ns;
	wait until (clock='0');
	file_open (left_file, "left_audio.txt", write_mode);
	file_open (right_file, "right_audio.txt",write_mode);
	wait for 327680 ns;
	while ( out_read_done='0') loop
		wait for 10158080 ns;
		out_rd_en<='1';
		wait until (clock='1');--
		wait until (clock='0');--
		for i in 0 to audio_samples-1 loop
			wait until (clock='1');

			l_dig8 := to_integer(ieee.numeric_std.unsigned(left_dout(31 downto 28)));
			l_dig7 := to_integer(ieee.numeric_std.unsigned(left_dout(27 downto 24)));
			l_dig6 := to_integer(ieee.numeric_std.unsigned(left_dout(23 downto 20)));
			l_dig5 := to_integer(ieee.numeric_std.unsigned(left_dout(19 downto 16)));
			l_dig4 := to_integer(ieee.numeric_std.unsigned(left_dout(15 downto 12)));
			l_dig3 := to_integer(ieee.numeric_std.unsigned(left_dout(11 downto 8)));
			l_dig2 := to_integer(ieee.numeric_std.unsigned(left_dout(7 downto 4)));
			l_dig1 := to_integer(ieee.numeric_std.unsigned(left_dout(3 downto 0)));
			if (l_dig1 < 10) then
				l_char1 := character'val(l_dig1+48);
			else
				l_char1 := character'val(l_dig1+55);
			end if;
			if (l_dig2 < 10) then
				l_char2 := character'val(l_dig2+48);
			else
				l_char2 := character'val(l_dig2+55);
			end if;
			if (l_dig3 < 10) then
				l_char3 := character'val(l_dig3+48);
			else
				l_char3 := character'val(l_dig3+55);
			end if;
			if (l_dig4 < 10) then
				l_char4 := character'val(l_dig4+48);
			else
				l_char4 := character'val(l_dig4+55);
			end if;
			if (l_dig5 < 10) then
				l_char5 := character'val(l_dig5+48);
			else
				l_char5 := character'val(l_dig5+55);
			end if;
			if (l_dig6 < 10) then
				l_char6 := character'val(l_dig6+48);
			else
				l_char6 := character'val(l_dig6+55);
			end if;
			if (l_dig7 < 10) then
				l_char7 := character'val(l_dig7+48);
			else
				l_char7 := character'val(l_dig7+55);
			end if;
			if (l_dig8 < 10) then
				l_char8 := character'val(l_dig8+48);
			else
				l_char8 := character'val(l_dig8+55);
			end if;
			write(left_line, l_char8);
			write(left_line, l_char7);
			write(left_line, l_char6);
			write(left_line, l_char5);
			write(left_line, l_char4);
			write(left_line, l_char3);
			write(left_line, l_char2);
			write(left_line, l_char1);
			left_num:=to_integer(ieee.numeric_std.unsigned(left_dout));
			--write(left_line,left_num);			
			writeline (left_file, left_line);
			
			r_dig8 := to_integer(ieee.numeric_std.unsigned(right_dout(31 downto 28)));
			r_dig7 := to_integer(ieee.numeric_std.unsigned(right_dout(27 downto 24)));
			r_dig6 := to_integer(ieee.numeric_std.unsigned(right_dout(23 downto 20)));
			r_dig5 := to_integer(ieee.numeric_std.unsigned(right_dout(19 downto 16)));
			r_dig4 := to_integer(ieee.numeric_std.unsigned(right_dout(15 downto 12)));
			r_dig3 := to_integer(ieee.numeric_std.unsigned(right_dout(11 downto 8)));
			r_dig2 := to_integer(ieee.numeric_std.unsigned(right_dout(7 downto 4)));
			r_dig1 := to_integer(ieee.numeric_std.unsigned(right_dout(3 downto 0)));
			if (r_dig1 < 10) then
				r_char1 := character'val(r_dig1+48);
			else
				r_char1 := character'val(r_dig1+55);
			end if;
			if (r_dig2 < 10) then
				r_char2 := character'val(r_dig2+48);
			else
				r_char2 := character'val(r_dig2+55);
			end if;
			if (r_dig3 < 10) then
				r_char3 := character'val(r_dig3+48);
			else
				r_char3 := character'val(r_dig3+55);
			end if;
			if (r_dig4 < 10) then
				r_char4 := character'val(r_dig4+48);
			else
				r_char4 := character'val(r_dig4+55);
			end if;
			if (r_dig5 < 10) then
				r_char5 := character'val(r_dig5+48);
			else
				r_char5 := character'val(r_dig5+55);
			end if;
			if (r_dig6 < 10) then
				r_char6 := character'val(r_dig6+48);
			else
				r_char6 := character'val(r_dig6+55);
			end if;
			if (r_dig7 < 10) then
				r_char7 := character'val(r_dig7+48);
			else
				r_char7 := character'val(r_dig7+55);
			end if;
			if (r_dig8 < 10) then
				r_char8 := character'val(r_dig8+48);
			else
				r_char8 := character'val(r_dig8+55);
			end if;

			
			write(right_line, r_char8);
			write(right_line, r_char7);
			write(right_line, r_char6);
			write(right_line, r_char5);
			write(right_line, r_char4);
			write(right_line, r_char3);
			write(right_line, r_char2);
			write(right_line, r_char1);
	
			right_num:=to_integer(ieee.numeric_std.unsigned(right_dout));
			--write(right_line,right_num);	
			writeline (right_file, right_line);
			wait until (clock='0');
		end loop;
		out_rd_en<='0';
	end loop;
	file_close(left_file);
	file_close(right_file);
	write_done <= '1';
	wait;
end process output_fifo_to_output_file_process;


tb_process : 
process
	variable start_time : time;
	variable end_time : time;
	variable ln: line;
begin
	wait until (reset = '1');
	wait until (reset = '0');
	wait for 100 ns;
	start_time := NOW;
	wait until (clock = '0');
	wait until (clock = '1');
	wait until (write_done = '1');
	end_time := NOW;
	
	writeline (output, ln);
	write( ln, string'("Radio filtering began at: ") );
	write( ln, start_time );
	writeline( output, ln );
	write( ln, string'("Radio filtering completed at:") );
	write( ln, end_time );
	writeline( output, ln );
	write( ln, string'("Total simulation time: "));
	write( ln, (end_time-start_time));
	writeline(output,ln);
	write( ln, string'("Total simulation cycle count: ") );
	write( ln, (end_time - start_time) / CLOCK_PERIOD );
	writeline( output, ln );
	wait;
end process tb_process;


compare_process : 
process
	file left_output	: text;
	file right_output	: text;
	file left_from_c	: text;
	file right_from_c	: text;
	variable ln1, ln2, ln3, ln4, ln : line;
	variable line_count : integer := 1;
	variable string1, string2, string3, string4	: string (8 downto 1);
	
begin
	wait until (reset = '1');
	wait until (reset = '0');
	wait until (write_done = '1');
	wait for 10 ns;
	
	file_open( left_output, "left_audio.txt", read_mode);
	file_open( right_output, "right_audio.txt", read_mode);
	file_open( left_from_c,  "left_from_c.txt",  read_mode);
	file_open( right_from_c,  "right_from_c.txt",  read_mode);
	
	while (not ENDFILE(left_from_c) ) loop
		if endfile(left_output) then
			write (ln, string'("Missing lines at the end."));
			writeline (output,ln);
			wait;
		else
			readline( left_output, ln1 );
			readline( left_from_c,ln2);
			readline( right_output, ln3 );
			readline( right_from_c,ln4);
			read(ln1, string1);
			read(ln2, string2);
			read(ln3, string3);
			read(ln4, string4);
			if ( (string1 /= string2) and ( string3 /= string4) ) then
				errors <= errors + 2;
				write( ln, string'("ERROR in left_audio.txt at line: ") );
				write( ln, line_count );
				write( ln, string'(".") );
				writeline( output, ln );
				write( ln, string'("ERROR in right_audio.txt at line: ") );
				write( ln, line_count );
				write( ln, string'(".") );
				writeline( output, ln );
			elsif (  string3 /= string4) then
				errors <= errors + 1;
				write( ln, string'("ERROR in right_audio.txt at line: ") );
				write( ln, line_count );
				write( ln, string'(".") );
				writeline( output, ln );
			elsif (string1/=string2) then
				errors <= errors + 1;
				write( ln, string'("ERROR in left_audio.txt at line: ") );
				write( ln, line_count );
				write( ln, string'(".") );
				writeline( output, ln );
			end if;
		end if;
		line_count:=line_count+1;
		wait for 5 ns;
	end loop;
	writeline(output, ln);
	write(ln,string'("Comparing completed."));
	writeline(output,ln);
	write( ln, string'("Total error count: ") );
	write( ln, errors );
	writeline( output, ln );
	file_close( left_output);
	file_close( right_output);
	file_close( left_from_c);
	file_close( right_from_c);
	hold_clock<='1';
	wait;
end process compare_process;


end architecture behavior;
