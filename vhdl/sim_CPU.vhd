----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2022 16:35:37
-- Design Name: 
-- Module Name: sim_CPU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sim_CPU is
--  Port ( );
end sim_CPU;

architecture Behavioral of sim_CPU is

component CPU is
    Port ( 
        CKCPU : in STD_LOGIC;
        RSTCPU : in STD_LOGIC);
end component;

signal clock : std_logic := '0';
signal reset :  std_logic;
begin
    process
        begin
            wait for 100ns;
            if clock = '0' then clock <= '1';
            else clock <= '0'; end if;
    end process;
    reset <= '0', '1' after 200ns;
    cpu_test : CPU port map (CKCPU => clock, RSTCPU => reset);
    --clock <= '1' after 10 ns when clock = '0' else '0' after 10 ns when clock = '1';
   
end Behavioral;
