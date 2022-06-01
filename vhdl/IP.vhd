----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 11:43:58
-- Design Name: 
-- Module Name: IP - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IP is
port ( CK : in STD_LOGIC;
       RST : in STD_LOGIC;
           LOAD : in STD_LOGIC;
           EN : in STD_LOGIC;
           Din : in STD_LOGIC_VECTOR (7 downto 0);
           Dout : out STD_LOGIC_VECTOR (7 downto 0));
end IP;

architecture Behavioral of IP is
    signal Aux: STD_LOGIC_VECTOR (7 downto 0) := X"00";
begin
process
    begin
            wait until CK'Event and CK = '1';
            
            if (RST = '0') then
                Aux <= X"00";
            elsif (LOAD = '1') then
                Aux <= Din;
            elsif (EN = '0') then
                Aux <= (Aux + 1);
            end if;
    end process;
    Dout <= Aux;

end Behavioral;
