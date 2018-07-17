

library IEEE;
use IEEE.std_logic_1164.all;
use WORK.divider_const.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.decoder.all;
use std.textio.all;



--Additional standard or custom libraries go here
entity divider is
port(
--Inputs
clk : in std_logic;
--COMMENT OUT clk signal for Part A.
start : in std_logic;
reset : in std_logic;
dividend : in std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
divisor : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
--Outputs
quotient : out std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
remainder : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
overflow : out std_logic;
sign: out std_logic

 );
end entity divider;

architecture structural_combinational of divider is
--Signals and components go here
	signal a : integer;
	signal b: integer;
	signal e : integer;
	signal f: integer;
	signal result : integer;
	signal result_final: std_logic_vector(DIVIDEND_WIDTH -1 downto 0);
	signal sumvector: std_logic;
	signal temsum: integer;
	signal sum: integer;
	signal tem1: std_logic_vector(DATA_WIDTH -1 downto 0);
	signal tem0: std_logic_vector(DATA_WIDTH -1 downto 0);
	constant c : integer:=0;
	type tem_arrayint is array (0 to 54) of std_logic_vector(DATA_WIDTH downto 0);
	signal temin : tem_arrayint;
	type tem_arrayout is array (0 to 54) of std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal temout : tem_arrayout;
	signal recaltem : std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal starttest: std_logic;
-------------------comparator--------------------------

component comparator is
generic(
	DATA_WIDTH : natural := 4);

port(
--Inputs
DINL : in std_logic_vector (DATA_WIDTH downto 0);
DINR : in std_logic_vector (DATA_WIDTH - 1 downto 0);
--Outputs
DOUT : out std_logic_vector (DATA_WIDTH - 1 downto 0);
isGreaterEq : out std_logic
 );
--end entity comparator;
end component;
-----------------------signal---------------------------------
	
--------------------------------------------------------------------


begin

	temout(DIVIDEND_WIDTH - 1)<= "00000000";

comp:	for i in DIVIDEND_WIDTH -1 downto 1 GENERATE
------------------i = 15 -------

	temin(i) <= temout(i)&dividend(i);
       

	divisioncal: comparator port map( DINL=>temin(i), 
			     DINR=>divisor,
			     DOUT=>temout(i-1),
			     isGreaterEq=>result_final(i)
			    );
	
end generate comp;


	temin(0) <= temout(0)&dividend(0);

	divisioncal: comparator port map( DINL=>temin(0), 
			     DINR=>divisor,
			     DOUT=>temout(54),
			     isGreaterEq=>result_final(0));

	--starttest<=start;

process(start,result_final,temout,divisor)
begin
	if start = '0' then
		if to_integer(unsigned(divisor)) = 0 then
       		overflow <= '1';
		else
		overflow <= '0';
    		end if;
	quotient<=result_final;
	remainder<=temout(54);
	
	else 
		if to_integer(unsigned(divisor)) = 0 then
       		overflow <= '1';
		else
		overflow <= '0';
    		end if;
	quotient<=(others=>'0');
	remainder<=(others=>'0');
	end if;
	
end process;

end architecture structural_combinational;
-----------------------------










--------------------------------
architecture behavioral_sequential of divider is
--Signals and components go here
	signal a : integer;
	signal b: integer;
	signal e : integer;
	signal f: integer;
	signal result : integer;
	signal result_final: std_logic_vector(DIVIDEND_WIDTH downto 0);
	signal sumvector: std_logic;
	signal temsum: integer;
	signal sig_dividend : std_logic_vector(DIVIDEND_WIDTH - 1 downto 0);
	signal sig_divisor : std_logic_vector(DIVISOR_WIDTH  - 1 downto 0);
	signal sum: integer;
	signal tem1: std_logic_vector(DATA_WIDTH -1 downto 0);
	signal tem0: std_logic_vector(DATA_WIDTH -1 downto 0);
	constant c : integer:=0;
	type tem_arrayint is array (0 to 54) of std_logic_vector(DIVISOR_WIDTH downto 0);
	signal temin : tem_arrayint;
	type tem_arrayout is array (0 to 54) of std_logic_vector(DIVISOR_WIDTH - 1 downto 0);
	signal temout : tem_arrayout;
	signal recaltem : std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal starttest: std_logic;
	signal clk_good : std_logic;
	signal i : integer := DIVIDEND_WIDTH - 1;
	signal sig_DINL: std_logic_vector(DIVISOR_WIDTH downto 0):= std_logic_vector(to_unsigned(0,DIVISOR_WIDTH + 1));
	signal sig_isGreaterEq: std_logic;
	signal sig_DOUT: std_logic_vector(DIVISOR_WIDTH - 1 downto 0):= std_logic_vector(to_unsigned(0,DIVISOR_WIDTH));
	signal sig_DOUT_zero: std_logic_vector(DIVISOR_WIDTH - 1 downto 0)    := std_logic_vector(to_unsigned(0,DIVISOR_WIDTH));
	signal sig_quotient_result: std_logic_vector(DIVIDEND_WIDTH downto 0);
	signal sig_quotient_zero: std_logic_vector(DIVIDEND_WIDTH - 1 downto 0)   := std_logic_vector(to_unsigned(0,DIVIDEND_WIDTH));
-------------------comparator--------------------------

component comparator is
generic(
	DATA_WIDTH : natural := 4);

port(
--Inputs
DINL : in std_logic_vector (DATA_WIDTH downto 0);
DINR : in std_logic_vector (DATA_WIDTH - 1 downto 0);
--Outputs
DOUT : out std_logic_vector (DATA_WIDTH - 1 downto 0);
isGreaterEq : out std_logic
 );
--end entity comparator;
end component;
-----------------------signal---------------------------------
	
--------------------------------------------------------------------


begin

process(start,dividend,divisor)
	begin
	if rising_edge(start) then
		sig_dividend <= dividend;
		sig_divisor <= divisor;
	end if;
end process;

process(sig_divisor)
begin
    if to_integer(unsigned(sig_divisor)) = 0 then
       		overflow <= '1';
	else
		overflow <= '0';
    end if;
end process; 

	--temout(DIVIDEND_WIDTH - 1)<= "00000000";

process(start,clk,i,sig_dividend,sig_DINL,sig_isGreaterEq,sig_DOUT,sig_quotient_result)
begin
	--clk_good<=clk;
	if(start = '1') then
	--cal:	for i in DIVIDEND_WIDTH -1 to 0 generate 
		if (rising_edge(clk) and i = DIVIDEND_WIDTH - 1) then

			sig_DINL(0) <= sig_dividend(DIVIDEND_WIDTH - 1);
			sig_DINL(DIVISOR_WIDTH downto 1) <= sig_DOUT_zero;
			sig_quotient_result(DIVIDEND_WIDTH - 1 downto 0) <= sig_quotient_zero;
			sig_quotient_result(DIVIDEND_WIDTH) <= sig_isGreaterEq;
			i <= i - 1;
			
		
		elsif(rising_edge(clk) and i <= 6 and i >= 0) then

			sig_DINL(0) <= sig_dividend(i);
			sig_DINL(DIVISOR_WIDTH downto 1) <= sig_DOUT;
			sig_quotient_result(i + 1) <= sig_isGreaterEq;
			i <= i - 1;
			--wait for 20 ns;
			
		elsif (rising_edge(clk) and i=-1) then

				--temin(0) <= temout(0)&sig_dividend(0);

	                     --sig_DINL<=temin(0), 
			     
			     --sig_DINL(DIVISOR_WIDTH downto 1)<=sig_DOUT;
			    sig_quotient_result(i+1)<=sig_isGreaterEq;
				--i <= DIVIDEND_WIDTH - 1;
			--wait for 20 ns;
			--end loop;
		end if;
		--end generate cal;

           else
		i <= DIVIDEND_WIDTH - 1;
	end if;

end process;

divisionmap: comparator 
			--generic map(DIVISOR_WIDTH)
			port map(
				DINL => sig_DINL,
        		        DINR => sig_divisor,
				DOUT => sig_DOUT,
				isGreaterEq => sig_isGreaterEq
			);
			
remainder <= sig_DOUT;
quotient  <= sig_quotient_result(DIVIDEND_WIDTH-1 downto 0);




end architecture behavioral_sequential;
---------------------------------------------





-----------------------------------------------------

architecture fsm_behaviour of divider is 



type state is (state_0, state_1, state_2, state_3, state_4);

--signal N : integer := 8;
signal aa : std_logic_vector(DIVIDEND_WIDTH -1 downto 0);
signal bb : std_logic_vector(DIVIDEND_WIDTH -1 downto 0);
--signal p : integer := 0;
--signal q : integer;
--signal x : integer;
signal sig_sign : std_logic;
signal sig_quotient : std_logic_vector(DIVIDEND_WIDTH -1 downto 0);
signal sig_dividend : std_logic_vector(DIVIDEND_WIDTH -1 downto 0);
signal sig_divisor : std_logic_vector(DIVISOR_WIDTH - 1 downto 0); 
signal sig_reminder : std_logic_vector(DATA_WIDTH -1 downto 0);
signal current_state, next_state : state;
signal sig_clk : std_logic;
signal p1: integer:=0;
signal p2: integer:=0;
signal avector: std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
signal bvector: std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);







function get_msb_pos1 (sig_dividend : std_logic_vector)
     return integer is
     variable num1 : integer;
     variable i : integer;
     begin
     for i in DIVIDEND_WIDTH -1 downto 0 loop
     if (sig_dividend(i) = '1') then 
	num1 := i;
	exit;
        end if;
	end loop;

        return (num1);
     
   end function  get_msb_pos1;

function get_msb_pos2 (signal data: std_logic_vector)
   return integer is
     variable num2 : integer;
     variable i : integer;
     begin
     for i in DIVISOR_WIDTH -1 downto 0 loop
     if (data(i) = '1') then 
	num2 := i;
	exit;
        end if;
	end loop;

        return (num2);
     
   end function  get_msb_pos2;


begin 


stateReg: process(reset, clk, start, divisor, dividend) is

variable a: integer;
variable b: integer;
variable p: integer:=0;
variable q: integer:=0;
variable N: integer:=DIVIDEND_WIDTH; 




begin

if (reset = '1') then 
current_state <= state_0;
next_state <= state_0;
b:=abs(to_integer(signed(divisor)));
a:=abs(to_integer(signed(dividend)));
p:=0;
q:=0;
elsif (rising_edge(clk) and reset='0') then 


case current_state is
 
  when state_0 =>

     if b=1 then
     q:=a;
     next_state <= state_4;
     else
     next_state <= state_1;
     end if;   


  when state_1 =>

	p:= get_msb_pos1(avector) - get_msb_pos2 (bvector);
	if((b*(2**p)) > a) then 
	next_state <= state_2;
        else
	next_state <=state_3;
  	end if;
 
  when state_2 =>
	p:=p-1;
	next_state <= state_3;


when state_3 =>

	q:=q+2**p;
	a:=a-b*(2**p);
	if(b/=0 and b<a) then

	next_state<=state_1;
	else
	next_state <= state_4;
	end if;
  
when state_4 =>

        if(start='1') then
	  if (to_integer(unsigned(divisor)) = 0) then
		overflow <= '1';
	  else
		overflow <= '0';
	  end if;
	sign <= dividend(DIVIDEND_WIDTH - 1 ) xor divisor(DIVISOR_WIDTH - 1 );
	quotient <= std_logic_vector(to_signed(abs(q),dividend'length));
	remainder <= std_logic_vector(to_signed(a,divisor'length));
    	end if;
	next_state<=state_4;


end case;	
elsif (falling_edge(clk) and reset='0') then 
current_state <= next_state;
end if;
end process;


end architecture;
            

