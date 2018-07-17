library IEEE;
library STD;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use IEEE.numeric_std.all;
use STD.textio.all;
use WORK.calc_const.all;
use WORK.decoder.all;

entity calculator_tb is
end entity calculator_tb;

architecture behavioral of calculator_tb is
COMPONENT calculator is
    port(
      ----------Inputs---------------------
       DIN1     : in std_logic_vector(DIN1_WIDTH  - 1 downto 0);
       DIN2     : in std_logic_vector(DIN2_WIDTH  - 1 downto 0);
       operation  : in std_logic_vector(OP_WIDTH  - 1 downto 0);
      ----------Outputs--------------------
       DOUT     : out std_logic_vector(DOUT_WIDTH - 1 downto 0);
       sign     : out std_logic
      );
END COMPONENT calculator; 
      ----------Inputs---------------------
   SIGNAL DIN1 : std_logic_vector(DIN1_WIDTH  - 1 downto 0);
   SIGNAL DIN2 : std_logic_vector(DIN2_WIDTH  - 1 downto 0);
   SIGNAL operation : std_logic_vector(OP_WIDTH  - 1 downto 0);
      ----------Outputs---------------------
   SIGNAL DOUT : std_logic_vector(DOUT_WIDTH - 1 downto 0);
   SIGNAL sign : std_logic;
 
begin

P1 : calculator port map (
   DIN1 =>  DIN1,
   DIN2 =>  DIN2,
   operation   =>  operation,
   DOUT  =>  DOUT,
   sign =>  sign

);

read_text_input : process 

   variable my_line : line; 
   variable out_line : line;
   variable vnum1, vnum2 : integer;
   variable op : character;
   file infile: text open read_mode is "cal16.in";
   file outfile: text open write_mode is "cal16.out";

     
    begin
    while not (endfile(infile)) loop
    readline(infile, my_line);
    read(my_line, vnum1);
    write(out_line, vnum1);
    --write(out_line, ");
    DIN1 <= std_logic_vector(to_signed(vnum1,DIN1_WIDTH));
    readline(infile, my_line);
    read(my_line, vnum2);
    DIN2 <= std_logic_vector(to_signed(vnum2,DIN2_WIDTH));
    readline(infile, my_line);
    read(my_line, op);
	
		if (op = '+') then
			operation <= "00";
		elsif (op = '-') then
			operation <= "01";
		elsif (op = '*') then
			operation <= "10";
		end if;
		wait for 50 ns;
		write(out_line,op);
		write(out_line, vnum2);
		write(out_line,string'(" = "));
		
		if (sign = '1') then
			write(out_line, string'("-"));
		end if;

		write(out_line, to_integer(signed(DOUT)));
		writeline(outfile, out_line);
		wait for 50 ns;
	end loop;
	wait;

end process read_text_input;

end architecture behavioral;