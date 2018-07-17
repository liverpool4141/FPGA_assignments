library IEEE;
use IEEE.std_logic_1164.all;
--Additional standard or custom libraries go here
package tank_const is
constant REG_WIDTH : natural := 10;
constant CYCLES_PER_PERIOD : natural := 1048576;--2^20
constant LCD_WIDTH : natural := 480;
constant LCD_HEIGHT : natural := 320;
constant TANK_WIDTH : natural := 30;
constant TANK_HEIGHT : natural := 30;
constant BULLET_WIDTH : natural := 2;
constant BULLET_HEIGHT : natural := 5;
constant SPEED1 : natural := 10;
constant SPEED2 : natural := 20;
constant SPEED3 : natural := 30;
constant BULLET_SPEED : natural := 40;
constant Y_COORD_A : natural := 0;
constant Y_COORD_B : natural := LCD_HEIGHT - TANK_HEIGHT;
constant FOUR_ZEROS : std_logic_vector(3 downto 0) := "0000";
--Other constants, types, subroutines, components go here
end package tank_const;
package body tank_const is
--Subroutine declarations go here
-- you will not have any need for it now, this package is only for defining -
-- some useful constants
end package body tank_const;