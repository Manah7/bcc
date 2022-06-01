----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 11:33:08
-- Design Name: 
-- Module Name: pipeline - Behavioral
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

entity pipeline is
    Port ( IN_A : in STD_LOGIC_VECTOR (7 downto 0);
           IN_B : in STD_LOGIC_VECTOR (7 downto 0);
           IN_C : in STD_LOGIC_VECTOR (7 downto 0);
           IN_OPP : in STD_LOGIC_VECTOR (7 downto 0);
           OUT_A : out STD_LOGIC_VECTOR (7 downto 0);
           OUT_B : out STD_LOGIC_VECTOR (7 downto 0);
           OUT_C : out STD_LOGIC_VECTOR (7 downto 0);
           OUT_OPP : out STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC);
end pipeline;

architecture Behavioral of pipeline is
begin
process
    begin
     wait until CLK'event and CLK='1';
            OUT_A <= IN_A;
            OUT_B <= IN_B;
            OUT_C <= IN_C;
            OUT_OPP <= IN_OPP;
    end process;



end Behavioral;
