library STD;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.tank_const.all;

entity game_tb is
end entity game_tb;

architecture behavioral of game_tb is

component game is
        PORT(
            clk : in std_logic;
            speedA_in: in integer;
            speedB_in: in integer
           ); 
        
end component game;

signal clk : std_logic := '1';
signal rst: std_logic;
signal speedA : integer;
signal speedB : integer;
constant clk_half_period : time := 1ps;

begin


dut : game port map(clk,speedA,speedB);

clk <= not clk after clk_half_period;


gametest: process
begin
    speedA <= 1;
    speedB <= 1;

    wait for 5 ns;

    speedA <= 3;
    speedB <= 3;

    wait for 5 ns;



end process gametest;

end architecture behavioral;
