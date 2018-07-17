library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
use std.textio.all;
use work.divider_const.all;


entity divider_tb is

end entity divider_tb;


architecture tb_arch of divider_tb is

component divider is 
         port(	  --clk     : in std_logic;
		  start     : in std_logic;
		  dividend  : in std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
		  divisor   : in std_logic_vector(DIVISOR_WIDTH-1 downto 0);
		  
		  quotient  : out std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
		  remainder : out std_logic_vector(DIVISOR_WIDTH-1 downto 0);
		  overflow  : out std_logic);
end component divider;

signal START : std_logic;
signal DIVIDEND : std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
signal DIVISOR : std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
signal QUOTIENT : std_logic_vector(DIVIDEND_WIDTH -1 downto 0);
signal REMAINDER : std_logic_vector(DIVISOR_WIDTH -1 downto 0);
signal OVERFLOW  : std_logic;


begin

dut : divider  port map(
start => START,
dividend => DIVIDEND,
divisor => DIVISOR,
quotient => QUOTIENT,
remainder => REMAINDER,
overflow => OVERFLOW );

    process
	    
        file infile:  TEXT open READ_MODE is "divider16.in";
        file outfile:  TEXT open WRITE_MODE is "divider16.out";
        variable myline:  LINE;
       


        variable v1:  integer;
        variable v2:  integer;
 
    begin
	    START <= '1';
	  

        writeline(outfile, myline);
        while not endfile(infile) loop
            readline(infile,myline);
            read(myline,v1);
            readline(infile,myline);
            read(myline,v2);
           
            DIVIDEND <= std_logic_vector(to_unsigned(v1,DIVIDEND_WIDTH));
            DIVISOR <=  std_logic_vector(to_unsigned(v2,DIVISOR_WIDTH));
            
			

            write(myline, to_integer(unsigned(DIVIDEND)));
			write(myline, '/');
			write(myline, to_integer(unsigned(DIVISOR)));
			write(myline, '=');
			write(myline, to_integer(unsigned(QUOTIENT)));
			write(myline, string'("----"));
			write(myline, to_integer(unsigned(REMAINDER)));
            writeline (outfile, myline);

            wait for 30 ns;
			
        end loop;
		
	----------------write outfile for output--------------	
        writeline(outfile, myline);
		
        wait;
		
    end process;

end architecture ; 