library ieee;

use ieee.std_logic_1164.all;
use work.divider_const.all;

entity display_divider is
    port(
				clk : in std_logic;
	          start     : in std_logic;
		  dividend  : in std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
		  divisor   : in std_logic_vector(DIVISOR_WIDTH-1 downto 0);
		  
		  out_dividend  : out std_logic_vector(7*DIVIDEND_WIDTH/4-1 downto 0);
		  out_divisor   : out std_logic_vector(7*DIVISOR_WIDTH/4-1 downto 0);
		  out_quotient  : out std_logic_vector(7*DIVIDEND_WIDTH/4-1 downto 0);
		  out_remainder : out std_logic_vector(7*DIVISOR_WIDTH/4-1 downto 0);
		  out_overflow  : out std_logic_vector(6 downto 0)
	     );
end entity;

architecture structural of display_divider is


signal sig_quotient  : std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
signal sig_remainder : std_logic_vector(DIVISOR_WIDTH-1 downto 0);
signal sig_overflow  : std_logic;
--signal sig_start     : std_logic;
-- signal temp_quotient : std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
-- signal temp_remainder: std_logic_vector(DIVISOR_WIDTH-1 downto 0);
-- signal temp_overflow : std_logic;

component divider is
    port(
	      clk     : in std_logic;
		  start     : in std_logic;
		  dividend  : in std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
		  divisor   : in std_logic_vector(DIVISOR_WIDTH-1 downto 0);
		  
		  quotient  : out std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
		  remainder : out std_logic_vector(DIVISOR_WIDTH-1 downto 0);
		  overflow  : out std_logic
		  );
end component;

component leddcd is
	port(
		 data_in : in std_logic_vector(3 downto 0);
		 segments_out : out std_logic_vector(6 downto 0)
		);
end component;

begin
   
dividemap: divider port map(
					clk=>clk,
              		  start => start,
			  dividend => dividend,
			  divisor => divisor,
			  quotient => sig_quotient,
			  remainder => sig_remainder,
			  overflow => sig_overflow
			  );
			  
dividenddisplay: for i in 0 to DIVIDEND_WIDTH/4-1 generate 

ledmap1: leddcd port map( 
           data_in(3 downto 0) => dividend(4*i+3 downto 4*i),
	       segments_out => out_dividend(7*i+6 downto 7*i)
		   );
end generate;

divisordisplay: leddcd port map( 
           data_in(3 downto 0) => divisor(3 downto 0),
	       segments_out => out_divisor(6 downto 0)
		   );
		   
quotient_display: for i in 0 to DIVIDEND_WIDTH/4-1 generate 
ledmap2: leddcd port map( 
           data_in(3 downto 0) => sig_quotient(4*i+3 downto 4*i),
	       segments_out => out_quotient(7*i+6 downto 7*i)
		   );
end generate;

remainder_display: leddcd port map( 
           data_in(3 downto 0) => sig_remainder(3 downto 0),
	       segments_out => out_remainder(6 downto 0)
		   );

overflow_display: leddcd port map( 
           data_in(3 downto 1) => "000",
           data_in(0) => sig_overflow,
	       segments_out => out_overflow(6 downto 0)
		   );

end architecture structural;