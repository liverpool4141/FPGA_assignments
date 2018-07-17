library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.tank_const.all;

entity game is
PORT(
	clk : in std_logic;
	speedA_in: in integer;
	speedB_in: in integer
   ); 

end entity game;

architecture behavioral of game is
signal tankA_X : integer := (LCD_WIDTH - TANK_WIDTH)/2 - 1;
signal tankB_X : integer := (LCD_WIDTH - TANK_WIDTH)/2 - 1;
signal tankA_dir : std_logic := '0';-- '0' means right, '1' means left.
signal tankB_dir : std_logic := '0';
signal speedA : integer;
signal speedB : integer;

begin

speedB <= speedB_in;
speedA <= speedA_in;

tank_proc : process (clk)
begin
if (rising_edge(clk)) then
	if (tankA_dir = '0') then
		if (speedA = 1) then
			if (tankA_X + SPEED1 <= LCD_WIDTH - TANK_WIDTH - 1) then
				tankA_X <= tankA_X + SPEED1;
			else
				tankA_X <= LCD_WIDTH - TANK_WIDTH - 1;
				tankA_dir <= not tankA_dir;
			end if;
		elsif (speedA = 2) then
			if (tankA_X + SPEED2 <= LCD_WIDTH - TANK_WIDTH - 1) then
				tankA_X <= tankA_X + SPEED2;
			else
				tankA_X <= LCD_WIDTH - TANK_WIDTH - 1;
				tankA_dir <= not tankA_dir;
			end if;
			
		else 
			if (tankA_X + SPEED3 <= LCD_WIDTH - TANK_WIDTH - 1) then
				tankA_X <= tankA_X + SPEED3;
			else
				tankA_X <= LCD_WIDTH - TANK_WIDTH - 1;
				tankA_dir <= not tankA_dir;
			end if;
		end if;
	else
		if (speedA = 1) then
			if (tankA_X - SPEED1 >= 0) then
				tankA_X <= tankA_X - SPEED1;
			else
				tankA_X <= 0 - (tankA_X - SPEED1);
				tankA_dir <= not tankA_dir;
			end if;
		elsif (speedA = 2) then
			if (tankA_X - SPEED2 >= 0) then
				tankA_X <= tankA_X - SPEED2;
			else
				tankA_X <= 0 - (tankA_X - SPEED2);
				tankA_dir <= not tankA_dir;
			end if;
		else 
			if (tankA_X - SPEED3 >= 0) then
				tankA_X <= tankA_X - SPEED3;
			else
				tankA_X <= 0 - (tankA_X - SPEED3);
				tankA_dir <= not tankA_dir;
			end if;
		end if;
	end if;
end if;


--tankB movement
if (rising_edge(clk)) then
	if (tankB_dir = '0') then
		if (speedB = 1) then
			if (tankB_X + SPEED1 <= LCD_WIDTH - TANK_WIDTH - 1) then
				tankB_X <= tankB_X + SPEED1;
			else
				tankB_X <= LCD_WIDTH - TANK_WIDTH - 1;
				tankB_dir <= not tankB_dir;
			end if;
		elsif (speedB = 2) then
			if (tankB_X + SPEED2 <= LCD_WIDTH - TANK_WIDTH - 1) then
				tankB_X <= tankB_X + SPEED2;
			else
				tankB_X <= LCD_WIDTH - TANK_WIDTH - 1;
				tankB_dir <= not tankB_dir;
			end if;
			
		else 
			if (tankB_X + SPEED3 <= LCD_WIDTH - TANK_WIDTH - 1) then
				tankB_X <= tankB_X + SPEED3;
			else
				tankB_X <= LCD_WIDTH - TANK_WIDTH - 1;
				tankB_dir <= not tankB_dir;
			end if;
		end if;
	else
		if (speedB = 1) then
			if (tankB_X - SPEED1 >= 0) then
				tankB_X <= tankB_X - SPEED1;
			else
				tankB_X <= 0 - (tankB_X - SPEED1);
				tankB_dir <= not tankB_dir;
			end if;
		elsif (speedB = 2) then
			if (tankB_X - SPEED2 >= 0) then
				tankB_X <= tankB_X - SPEED2;
			else
				tankB_X <= 0 - (tankB_X - SPEED2);
				tankB_dir <= not tankB_dir;
			end if;
		else 
			if (tankB_X - SPEED3 >= 0) then
				tankB_X <= tankB_X - SPEED3;
			else
				tankB_X <= 0 - (tankB_X - SPEED3);
				tankB_dir <= not tankB_dir;
			end if;
		end if;
	end if;
end if;
			end process tank_proc;



end architecture behavioral;